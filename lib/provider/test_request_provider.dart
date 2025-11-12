import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:labtest/models/client_profile.dart';
import 'package:labtest/models/lab_details.dart';
import 'package:labtest/models/lab_request.dart';
import 'package:labtest/models/request_status.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/provider/settings_provider.dart';
import 'package:labtest/services/firebase_request_service.dart';
import 'package:labtest/utils/custom_snackbar.dart';
import 'package:labtest/utils/k_debug_print.dart';

class TestRequestProvider extends ChangeNotifier {
  TestRequestProvider({FirebaseRequestService? requestService})
      : _requestService = requestService ?? FirebaseRequestService();

  final FirebaseRequestService _requestService;
  SettingsProvider? _settings;

  // State
  List<LabRequest> _labRequests = [];
  List<TestRequest> _testRequests = [];
  bool _isLoading = false;
  String? _error;

  // Form state
  TestRequest? _currentFormRequest;
  String _formUrgency = 'Normal';

  // Getters
  List<LabRequest> get labRequests => _labRequests;
  List<TestRequest> get testRequests => _testRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TestRequest? get currentFormRequest => _currentFormRequest;
  bool get isFormAlreadySubmitted => _currentFormRequest?.isSubmitted ?? false;
  String get formUrgency => _formUrgency;
  List<TestRequest> get pendingRequests => _testRequests
      .where((r) => r.status.toLowerCase() == RequestStatus.pending.value)
      .toList();
  List<TestRequest> get acceptedRequests => _testRequests
      .where((r) => r.status.toLowerCase() == RequestStatus.accepted.value)
      .toList();
  List<TestRequest> get activeRequests => _testRequests
      .where((r) => r.status.toLowerCase() == RequestStatus.inProgress.value)
      .toList();
  List<TestRequest> get inProgressRequests => activeRequests;
  List<TestRequest> get completedRequests => _testRequests
      .where((r) => r.status.toLowerCase() == RequestStatus.completed.value)
      .toList();
  List<TestRequest> get cancelledRequests => _testRequests
      .where((r) => r.status.toLowerCase() == RequestStatus.cancelled.value)
      .toList();

  SettingsProvider? get settings => _settings;

  void updateSettings(SettingsProvider settings) {
    _settings = settings;
  }

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
    String? urgency,
    String? labId,
    String? phoneNumber,
    String? email,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? additionalNotes,
    List<String>? requestedTests,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      final settings = _ensureSettings(context);
      final effectiveUrgency =
          (urgency ?? settings.defaultUrgency).trim().isEmpty
              ? settings.defaultUrgency
              : (urgency ?? settings.defaultUrgency);

      final labDetails = _buildLabDetailsFromSettings(
        settings,
        overrideId: labId,
      );

      final trimmedName = patientName.trim();
      final trimmedLocation = location.trim();
      final trimmedTest = bloodTestType.trim();
      final trimmedPhone = phoneNumber?.trim();
      final trimmedEmail = email?.trim();
      final trimmedAddress2 = addressLine2?.trim();
      final trimmedCity = city?.trim();
      final trimmedState = state?.trim();
      final trimmedPostal = postalCode?.trim();
      final trimmedNotes = additionalNotes?.trim();

      final geoPoint = (latitude != null && longitude != null)
          ? GeoPoint(latitude, longitude)
          : null;

      final tests = _normalizeTestList(
        provided: requestedTests,
        fallback: trimmedTest,
      );

      ClientProfile? clientProfile;
      if (trimmedName.isNotEmpty ||
          trimmedLocation.isNotEmpty ||
          (trimmedPhone?.isNotEmpty ?? false) ||
          (trimmedEmail?.isNotEmpty ?? false) ||
          geoPoint != null) {
        final names = _splitName(trimmedName);
        clientProfile = ClientProfile(
          firstName: names[0],
          lastName: names[1],
          phoneNumber:
              trimmedPhone?.isNotEmpty == true ? trimmedPhone : null,
          email: trimmedEmail?.isNotEmpty == true ? trimmedEmail : null,
          addressLine1: trimmedLocation.isNotEmpty ? trimmedLocation : null,
          addressLine2:
              trimmedAddress2?.isNotEmpty == true ? trimmedAddress2 : null,
          city: trimmedCity?.isNotEmpty == true ? trimmedCity : null,
          state: trimmedState?.isNotEmpty == true ? trimmedState : null,
          postalCode:
              trimmedPostal?.isNotEmpty == true ? trimmedPostal : null,
          location: geoPoint,
          notes: trimmedNotes?.isNotEmpty == true ? trimmedNotes : null,
        );
      }

      final metadata = <String, dynamic>{};
      if (trimmedName.isNotEmpty) {
        metadata['patientName'] = trimmedName;
      }
      if (trimmedLocation.isNotEmpty) {
        metadata['addressLine1'] = trimmedLocation;
      }
      if (trimmedAddress2?.isNotEmpty == true) {
        metadata['addressLine2'] = trimmedAddress2;
      }
      if (trimmedCity?.isNotEmpty == true) {
        metadata['city'] = trimmedCity;
      }
      if (trimmedState?.isNotEmpty == true) {
        metadata['state'] = trimmedState;
      }
      if (trimmedPostal?.isNotEmpty == true) {
        metadata['postalCode'] = trimmedPostal;
      }
      if (trimmedPhone?.isNotEmpty == true) {
        metadata['phoneNumber'] = trimmedPhone;
      }
      if (trimmedEmail?.isNotEmpty == true) {
        metadata['email'] = trimmedEmail;
      }
      if (tests.isNotEmpty) {
        metadata['requestedTests'] = tests;
      }
      if (trimmedTest.isNotEmpty) {
        metadata['legacyTestType'] = trimmedTest;
      }
      if (geoPoint != null) {
        metadata['coordinates'] = {
          'lat': geoPoint.latitude,
          'lng': geoPoint.longitude,
        };
      }
      if (trimmedNotes?.isNotEmpty == true) {
        metadata['notes'] = trimmedNotes;
      }

      final request = await _requestService.createLabRequest(
        labDetails: labDetails,
        clientProfile: clientProfile,
        requestedTests: tests,
        urgency: effectiveUrgency,
        createdBy: labId ?? labDetails.id ?? settings.labName,
        notes: trimmedNotes?.isNotEmpty == true ? trimmedNotes : null,
        location: geoPoint,
        formExpiry: Duration(hours: settings.formExpiryHours),
        metadata: metadata.isNotEmpty ? metadata : null,
      );

      _upsertRequest(request);

      if (context != null) {
        CustomSnackBar.success(context, 'Form link created successfully!');
      }

      final legacy = request.toLegacyTestRequest();
      return legacy.getFormLink();
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

      final effectiveLabId = labId ?? _settings?.labName;
      final requests = await _requestService.fetchRequests(
        labId: (effectiveLabId != null && effectiveLabId.isNotEmpty)
            ? effectiveLabId
            : null,
      );

      final shouldAutoDelete = _settings?.autoDeleteExpiredForms ?? true;
      final now = DateTime.now();
      final validRequests = <LabRequest>[];

      if (shouldAutoDelete) {
        final expired = <LabRequest>[];
        for (final request in requests) {
          if (request.expiresAt != null &&
              request.expiresAt!.isBefore(now) &&
              !request.hasClientSubmission) {
            expired.add(request);
          } else {
            validRequests.add(request);
          }
        }

        if (expired.isNotEmpty) {
          for (final request in expired) {
            if (request.id != null) {
              await _requestService.deleteRequest(request.id!);
            }
          }
          KDebugPrint.info('Deleted ${expired.length} expired forms');
        }
      } else {
        validRequests.addAll(requests);
      }

      _labRequests = validRequests;
      _syncDerivedTestRequests();

      KDebugPrint.info('Fetched ${_labRequests.length} lab requests');
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
      int deletedCount = 0;

      final requests = await _requestService.fetchRequests(
        labId: labId ?? _settings?.labName,
      );
      final now = DateTime.now();

      for (final request in requests) {
        if (request.expiresAt != null &&
            request.expiresAt!.isBefore(now) &&
            !request.hasClientSubmission &&
            request.id != null) {
          await _requestService.deleteRequest(request.id!);
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
      final request =
          await _requestService.getRequestByFormLinkId(formLinkId);

      if (request == null) {
        KDebugPrint.warning('No request found with formLinkId: $formLinkId');
        _currentFormRequest = null;
        notifyListeners();
        return null;
      }

      final legacy = request.toLegacyTestRequest();

      if (await checkFormExpiration(legacy)) {
        KDebugPrint.warning('Form expired: $formLinkId');
        _currentFormRequest = null;
        notifyListeners();
        return null;
      }

      _currentFormRequest = legacy;
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
    String? phoneNumber,
    String? email,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    List<String>? requestedTests,
    String? additionalNotes,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      error = null;

      final trimmedName = patientName.trim();
      final trimmedLocation = location.trim();
      final trimmedNotes = additionalNotes?.trim();
      final trimmedTest = bloodTestType.trim();
      final trimmedPhone = phoneNumber?.trim();
      final trimmedEmail = email?.trim();
      final trimmedAddress2 = addressLine2?.trim();
      final trimmedCity = city?.trim();
      final trimmedState = state?.trim();
      final trimmedPostal = postalCode?.trim();
      final geoPoint = (latitude != null && longitude != null)
          ? GeoPoint(latitude, longitude)
          : null;
      final names = _splitName(trimmedName);

      final clientProfile = ClientProfile(
        firstName: names[0],
        lastName: names[1],
        phoneNumber:
            trimmedPhone?.isNotEmpty == true ? trimmedPhone : null,
        email: trimmedEmail?.isNotEmpty == true ? trimmedEmail : null,
        addressLine1: trimmedLocation.isNotEmpty ? trimmedLocation : null,
        addressLine2:
            trimmedAddress2?.isNotEmpty == true ? trimmedAddress2 : null,
        city: trimmedCity?.isNotEmpty == true ? trimmedCity : null,
        state: trimmedState?.isNotEmpty == true ? trimmedState : null,
        postalCode:
            trimmedPostal?.isNotEmpty == true ? trimmedPostal : null,
        location: geoPoint,
        notes: trimmedNotes?.isNotEmpty == true ? trimmedNotes : null,
      );

      final tests = _normalizeTestList(
        provided: requestedTests,
        fallback: trimmedTest,
      );

      final metadata = <String, dynamic>{};
      if (trimmedName.isNotEmpty) {
        metadata['patientName'] = trimmedName;
      }
      if (trimmedLocation.isNotEmpty) {
        metadata['addressLine1'] = trimmedLocation;
      }
      if (trimmedAddress2?.isNotEmpty == true) {
        metadata['addressLine2'] = trimmedAddress2;
      }
      if (trimmedCity?.isNotEmpty == true) {
        metadata['city'] = trimmedCity;
      }
      if (trimmedState?.isNotEmpty == true) {
        metadata['state'] = trimmedState;
      }
      if (trimmedPostal?.isNotEmpty == true) {
        metadata['postalCode'] = trimmedPostal;
      }
      if (trimmedPhone?.isNotEmpty == true) {
        metadata['phoneNumber'] = trimmedPhone;
      }
      if (trimmedEmail?.isNotEmpty == true) {
        metadata['email'] = trimmedEmail;
      }
      if (tests.isNotEmpty) {
        metadata['requestedTests'] = tests;
      }
      if (trimmedTest.isNotEmpty) {
        metadata['legacyTestType'] = trimmedTest;
      }
      if (geoPoint != null) {
        metadata['coordinates'] = {
          'lat': geoPoint.latitude,
          'lng': geoPoint.longitude,
        };
      }
      if (trimmedNotes?.isNotEmpty == true) {
        metadata['notes'] = trimmedNotes;
      }

      final updatedRequest = await _requestService.submitClientForm(
        formLinkId: formLinkId,
        clientProfile: clientProfile,
        requestedTests: tests,
        urgency: urgency,
        notes: trimmedNotes,
        location: geoPoint,
        metadata: metadata.isNotEmpty ? metadata : null,
      );

      _upsertRequest(updatedRequest);

      if (context != null) {
        CustomSnackBar.success(context, 'Form submitted successfully!');
      }

      return true;
    } catch (e) {
      KDebugPrint.error('Error submitting client form: $e');
      error = 'Failed to submit form: $e';

      if (context != null) {
        final message =
            e is StateError ? e.message : 'Failed to submit form';
        CustomSnackBar.error(context, message);
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

      final trimmedName = patientName.trim();
      final trimmedLocation = location.trim();
      final trimmedTest = bloodTestType.trim();
      final existingIndex =
          _labRequests.indexWhere((req) => req.id == requestId);
      final existing = existingIndex >= 0 ? _labRequests[existingIndex] : null;

      ClientProfile? clientProfile;
      if (trimmedName.isNotEmpty || trimmedLocation.isNotEmpty) {
        final names = _splitName(trimmedName);
        final clientId = existing?.clientProfileId;
        clientProfile = ClientProfile(
          id: clientId,
          firstName: names[0],
          lastName: names[1],
          addressLine1: trimmedLocation.isNotEmpty ? trimmedLocation : null,
        );
      }

      final updated = await _requestService.updateRequest(
        requestId: requestId,
        requestedTests:
            trimmedTest.isNotEmpty ? <String>[trimmedTest] : const <String>[],
        urgency: urgency,
        notes: existing?.notes,
        location: existing?.location,
        clientProfile: clientProfile,
        metadata: existing?.metadata,
      );

      _upsertRequest(updated);

      KDebugPrint.success('Request updated: $requestId');

      if (context != null) {
        CustomSnackBar.success(context, 'Request updated successfully');
      }

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

      final targetStatus =
          RequestStatusValue.fromValue(status.toLowerCase().trim());

      final updated = await _requestService.updateStatus(
        requestId: requestId,
        status: targetStatus,
        updatedBy: _settings?.labName,
      );

      _upsertRequest(updated);

      KDebugPrint.success('Request status updated: $requestId -> $status');

      if (context != null) {
        CustomSnackBar.success(context, 'Request status updated');
      }

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

      await _requestService.deleteRequest(requestId);
      _removeRequestById(requestId);

      KDebugPrint.success('Request deleted: $requestId');

      if (context != null) {
        CustomSnackBar.success(context, 'Request deleted successfully');
      }

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

  void _syncDerivedTestRequests() {
    _testRequests =
        _labRequests.map((request) => request.toLegacyTestRequest()).toList();
  }

  void _upsertRequest(LabRequest request) {
    final updated = List<LabRequest>.of(_labRequests);
    final index = updated.indexWhere((item) => item.id == request.id);
    if (index >= 0) {
      updated[index] = request;
    } else {
      updated.insert(0, request);
    }
    _labRequests = updated;
    _syncDerivedTestRequests();
  }

  void _removeRequestById(String requestId) {
    _labRequests =
        _labRequests.where((request) => request.id != requestId).toList();
    _syncDerivedTestRequests();
  }

  SettingsProvider _ensureSettings(BuildContext? context) {
    if (_settings != null) {
      return _settings!;
    }
    if (context != null) {
      final settings =
          Provider.of<SettingsProvider>(context, listen: false);
      _settings = settings;
      return settings;
    }
    throw StateError('SettingsProvider not available');
  }

  LabDetails _buildLabDetailsFromSettings(
    SettingsProvider settings, {
    String? overrideId,
  }) {
    final slugCandidate = overrideId?.trim().isNotEmpty == true
        ? _slugify(overrideId!)
        : _slugify(settings.labName);

    return LabDetails(
      id: slugCandidate.isNotEmpty ? slugCandidate : null,
      name: settings.labName,
      contactEmail: settings.contactEmail,
      contactPhone: settings.contactPhone,
      addressLine1: settings.labAddress,
      addressLine2: settings.cityStatePincode,
    );
  }

  List<String> _splitName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return const ['Client', ''];
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first;
    final last =
        parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return [first, last];
  }

  List<String> _normalizeTestList({
    List<String>? provided,
    String? fallback,
  }) {
    final values = <String>{};

    if (provided != null) {
      for (final item in provided) {
        final trimmed = item.trim();
        if (trimmed.isNotEmpty) {
          values.add(trimmed);
        }
      }
    }

    if (fallback != null && fallback.trim().isNotEmpty) {
      for (final segment in fallback.split(',')) {
        final trimmed = segment.trim();
        if (trimmed.isNotEmpty) {
          values.add(trimmed);
        }
      }
    }

    return values.toList();
  }

  String _slugify(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return normalized.replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Clear all data
  void clear() {
    _labRequests = [];
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
