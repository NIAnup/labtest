import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:labtest/utils/custom_snackbar.dart';

class TestRequestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  List<TestRequest> _testRequests = [];
  bool _isLoading = false;
  String? _error;

  // Form state
  TestRequest? _currentFormRequest;
  String _formUrgency = 'Normal';

  // Getters
  List<TestRequest> get testRequests => _testRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TestRequest? get currentFormRequest => _currentFormRequest;
  bool get isFormAlreadySubmitted => _currentFormRequest?.isSubmitted ?? false;
  String get formUrgency => _formUrgency;
  List<TestRequest> get newRequests =>
      _testRequests.where((r) => r.status == 'New').toList();
  List<TestRequest> get pendingRequests =>
      _testRequests.where((r) => r.status == 'Pending').toList();
  List<TestRequest> get activeRequests =>
      _testRequests.where((r) => r.status == 'Active').toList();
  List<TestRequest> get completedRequests =>
      _testRequests.where((r) => r.status == 'Completed').toList();

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  /// Create a new test request and generate form link
  /// Patient details are optional - can create empty form for client to fill
  Future<String?> createTestRequest({
    String patientName = '',
    String location = '',
    String bloodTestType = '',
    String urgency = 'Normal',
    String? labId,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      // Generate unique form link ID
      final formLinkId = _generateUniqueId();

      // Set expiration time to 1 hour from now
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 1));

      final request = TestRequest(
        patientName: patientName,
        location: location,
        bloodTestType: bloodTestType,
        urgency: urgency,
        status: 'New',
        formLinkId: formLinkId,
        createdAt: now,
        labId: labId,
        expiresAt: expiresAt,
      );

      // Save to Firestore
      final docRef = await _firestore
          .collection('test_requests')
          .add(request.toFirestore());

      KDebugPrint.success('Test request created: ${docRef.id}');

      if (context != null) {
        CustomSnackBar.success(context, 'Form link created successfully!');
      }

      // Refresh the list
      await fetchTestRequests(labId: labId);

      // Return the form link
      return request.getFormLink();
    } catch (e) {
      KDebugPrint.error('Error creating test request: $e');
      error = 'Failed to create test request: $e';

      if (context != null) {
        CustomSnackBar.error(context, 'Failed to create form link');
      }

      return null;
    } finally {
      isLoading = false;
    }
  }

  /// Fetch all test requests for a lab
  /// Automatically filters out expired unsubmitted forms
  Future<void> fetchTestRequests({String? labId}) async {
    try {
      isLoading = true;
      error = null;

      Query query = _firestore.collection('test_requests');

      // Filter by labId if provided
      if (labId != null) {
        query = query.where('labId', isEqualTo: labId);
      }

      // Order by creation date
      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();

      // Filter out expired unsubmitted forms
      final allRequests =
          snapshot.docs.map((doc) => TestRequest.fromFirestore(doc)).toList();

      // Separate expired and valid requests
      final validRequests = <TestRequest>[];
      final expiredIds = <String>[];

      for (var request in allRequests) {
        if (request.isExpired && !request.isSubmitted) {
          // Mark for deletion
          if (request.id != null) {
            expiredIds.add(request.id!);
          }
        } else {
          validRequests.add(request);
        }
      }

      // Delete expired forms in batch
      if (expiredIds.isNotEmpty) {
        final batch = _firestore.batch();
        for (var id in expiredIds) {
          batch.delete(_firestore.collection('test_requests').doc(id));
        }
        await batch.commit();
        KDebugPrint.info('Deleted ${expiredIds.length} expired forms');
      }

      _testRequests = validRequests;

      KDebugPrint.info('Fetched ${_testRequests.length} test requests');
    } catch (e) {
      KDebugPrint.error('Error fetching test requests: $e');
      error = 'Failed to fetch test requests: $e';
    } finally {
      isLoading = false;
    }
  }

  /// Check if form is expired (only checks expiration, doesn't delete immediately)
  /// Returns true if form is expired and should be rejected
  Future<bool> checkFormExpiration(TestRequest request) async {
    // Only check expiration if form has expiresAt set
    if (request.expiresAt == null) {
      return false; // No expiration set, form is valid (for backward compatibility)
    }

    // Check if form is expired (current time is after expiration time)
    // Form should be valid for 1 hour, then expire
    if (request.isExpired && !request.isSubmitted) {
      KDebugPrint.info('Form expired: ${request.formLinkId}');
      // Don't delete here, let the fetch method handle cleanup
      return true; // Form is expired
    }
    return false; // Form is not expired, still valid
  }

  /// Delete all expired unsubmitted forms
  Future<int> deleteExpiredForms({String? labId}) async {
    try {
      Query query = _firestore.collection('test_requests');

      // Filter by labId if provided
      if (labId != null) {
        query = query.where('labId', isEqualTo: labId);
      }

      final snapshot = await query.get();
      int deletedCount = 0;

      for (var doc in snapshot.docs) {
        final request = TestRequest.fromFirestore(doc);

        // Delete if expired and not submitted
        if (request.isExpired && !request.isSubmitted) {
          await doc.reference.delete();
          deletedCount++;
          KDebugPrint.info('Deleted expired form: ${request.formLinkId}');
        }
      }

      if (deletedCount > 0) {
        KDebugPrint.success('Deleted $deletedCount expired forms');
        // Refresh the list
        await fetchTestRequests(labId: labId);
      }

      return deletedCount;
    } catch (e) {
      KDebugPrint.error('Error deleting expired forms: $e');
      return 0;
    }
  }

  /// Get test request by form link ID (for client form)
  /// Returns null if form is expired or doesn't exist
  Future<TestRequest?> getRequestByFormLinkId(String formLinkId) async {
    try {
      final snapshot = await _firestore
          .collection('test_requests')
          .where('formLinkId', isEqualTo: formLinkId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        KDebugPrint.warning('No request found with formLinkId: $formLinkId');
        _currentFormRequest = null;
        notifyListeners();
        return null;
      }

      final request = TestRequest.fromFirestore(snapshot.docs.first);

      // Check if form is expired
      if (await checkFormExpiration(request)) {
        KDebugPrint.warning('Form expired: $formLinkId');
        _currentFormRequest = null;
        notifyListeners();
        return null;
      }

      _currentFormRequest = request;
      notifyListeners();
      return _currentFormRequest;
    } catch (e) {
      KDebugPrint.error('Error getting request by form link ID: $e');
      _currentFormRequest = null;
      notifyListeners();
      return null;
    }
  }

  /// Set form urgency
  void setFormUrgency(String urgency) {
    _formUrgency = urgency;
    notifyListeners();
  }

  /// Clear form state
  void clearFormState() {
    _currentFormRequest = null;
    _formUrgency = 'Normal';
    notifyListeners();
  }

  /// Submit client form data
  Future<bool> submitClientForm({
    required String formLinkId,
    required String patientName,
    required String location,
    required String bloodTestType,
    required String urgency,
    String? additionalNotes,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      // Get the request
      final request = await getRequestByFormLinkId(formLinkId);
      if (request == null) {
        if (context != null) {
          CustomSnackBar.error(context, 'Invalid or expired form link');
        }
        return false;
      }

      // Check if form is expired
      if (request.isExpired) {
        if (context != null) {
          CustomSnackBar.error(
            context,
            'This form has expired. Please request a new form link.',
          );
        }
        // Delete expired form
        if (request.id != null) {
          await _firestore
              .collection('test_requests')
              .doc(request.id!)
              .delete();
        }
        return false;
      }

      // Check if already submitted
      if (request.isSubmitted) {
        if (context != null) {
          CustomSnackBar.warning(
            context,
            'This form has already been submitted',
          );
        }
        return false;
      }

      // Create client submission
      final submission = ClientSubmission(
        patientName: patientName,
        location: location,
        bloodTestType: bloodTestType,
        urgency: urgency,
        submittedAt: DateTime.now(),
        additionalNotes: additionalNotes,
      );

      // Update the request
      await _firestore.collection('test_requests').doc(request.id).update({
        'clientSubmission': submission.toMap(),
        'submittedAt': Timestamp.fromDate(DateTime.now()),
        'status': 'Pending', // Change status to Pending after submission
      });

      KDebugPrint.success('Client form submitted: $formLinkId');

      if (context != null) {
        CustomSnackBar.success(context, 'Form submitted successfully!');
      }

      // Refresh the list
      await fetchTestRequests(labId: request.labId);

      return true;
    } catch (e) {
      KDebugPrint.error('Error submitting client form: $e');
      error = 'Failed to submit form: $e';

      if (context != null) {
        CustomSnackBar.error(context, 'Failed to submit form');
      }

      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Update request details
  Future<bool> updateRequest({
    required String requestId,
    required String patientName,
    required String location,
    required String bloodTestType,
    required String urgency,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      await _firestore.collection('test_requests').doc(requestId).update({
        'patientName': patientName,
        'location': location,
        'bloodTestType': bloodTestType,
        'urgency': urgency,
      });

      KDebugPrint.success('Request updated: $requestId');

      if (context != null) {
        CustomSnackBar.success(context, 'Request updated successfully');
      }

      // Refresh the list
      await fetchTestRequests();

      return true;
    } catch (e) {
      KDebugPrint.error('Error updating request: $e');
      error = 'Failed to update request: $e';

      if (context != null) {
        CustomSnackBar.error(context, 'Failed to update request');
      }

      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Update request status
  Future<bool> updateRequestStatus({
    required String requestId,
    required String status,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      await _firestore.collection('test_requests').doc(requestId).update({
        'status': status,
      });

      KDebugPrint.success('Request status updated: $requestId -> $status');

      if (context != null) {
        CustomSnackBar.success(context, 'Request status updated');
      }

      // Refresh the list
      await fetchTestRequests();

      return true;
    } catch (e) {
      KDebugPrint.error('Error updating request status: $e');
      error = 'Failed to update request status: $e';

      if (context != null) {
        CustomSnackBar.error(context, 'Failed to update status');
      }

      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Delete a test request
  Future<bool> deleteRequest({
    required String requestId,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      await _firestore.collection('test_requests').doc(requestId).delete();

      KDebugPrint.success('Request deleted: $requestId');

      if (context != null) {
        CustomSnackBar.success(context, 'Request deleted successfully');
      }

      // Refresh the list
      await fetchTestRequests();

      return true;
    } catch (e) {
      KDebugPrint.error('Error deleting request: $e');
      error = 'Failed to delete request: $e';

      if (context != null) {
        CustomSnackBar.error(context, 'Failed to delete request');
      }

      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Generate unique ID for form link
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (10000 + (99999 - 10000) * (DateTime.now().microsecond / 999999))
            .toInt()
            .toString();
  }

  /// Clear all data
  void clear() {
    _testRequests = [];
    _error = null;
    _isLoading = false;
    _currentFormRequest = null;
    _formUrgency = 'Normal';
    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
