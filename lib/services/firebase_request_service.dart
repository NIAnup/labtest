import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client_profile.dart';
import '../models/lab_details.dart';
import '../models/lab_request.dart';
import '../models/request_status.dart';

class FirebaseRequestService {
  FirebaseRequestService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _labRequestsCollection = 'lab_requests';
  static const String _clientProfilesCollection = 'client_profiles';
  static const String _labDetailsCollection = 'lab_details';

  /// Creates or updates a client profile document.
  Future<ClientProfile> upsertClientProfile(ClientProfile profile) async {
    final data = profile.copyWith(updatedAt: DateTime.now()).toFirestore();
    if (profile.id == null) {
      final doc =
          await _firestore.collection(_clientProfilesCollection).add(data);
      return profile.copyWith(id: doc.id, updatedAt: DateTime.now());
    } else {
      await _firestore
          .collection(_clientProfilesCollection)
          .doc(profile.id)
          .set(data, SetOptions(merge: true));
      return profile.copyWith(updatedAt: DateTime.now());
    }
  }

  /// Creates or updates a lab details document.
  Future<LabDetails> upsertLabDetails(LabDetails details) async {
    final payload = details.copyWith(updatedAt: DateTime.now()).toFirestore();
    if (details.id == null) {
      final doc = await _firestore.collection(_labDetailsCollection).add(payload);
      return details.copyWith(id: doc.id, updatedAt: DateTime.now());
    } else {
      await _firestore
          .collection(_labDetailsCollection)
          .doc(details.id)
          .set(payload, SetOptions(merge: true));
      return details.copyWith(updatedAt: DateTime.now());
    }
  }

  /// Generates a client-friendly form link ID.
  String generateFormLinkId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPortion =
        (Random().nextInt(900000) + 100000).toString(); // 6 digits
    return '$timestamp$randomPortion';
  }

  /// Creates a new lab request draft and returns the full hydrated model.
  Future<LabRequest> createLabRequest({
    required LabDetails labDetails,
    ClientProfile? clientProfile,
    List<String> requestedTests = const [],
    String urgency = 'Normal',
    String? createdBy,
    String? notes,
    GeoPoint? location,
    String? formLinkId,
    Duration? formExpiry,
    Map<String, dynamic>? metadata,
  }) async {
    final now = DateTime.now();

    final savedLabDetails = await upsertLabDetails(labDetails);
    ClientProfile? savedClient;
    if (clientProfile != null) {
      savedClient = await upsertClientProfile(clientProfile);
    }

    final request = LabRequest(
      labId: savedLabDetails.id ?? savedLabDetails.name,
      labDetailsId: savedLabDetails.id,
      clientProfileId: savedClient?.id,
      createdBy: createdBy ?? savedLabDetails.id ?? 'lab',
      status: RequestStatus.pending,
      urgency: urgency,
      requestedTests: requestedTests,
      notes: notes,
      location: location ??
          (savedClient?.location ??
              (savedLabDetails.latitude != null && savedLabDetails.longitude != null
                  ? GeoPoint(savedLabDetails.latitude!, savedLabDetails.longitude!)
                  : null)),
      formLinkId: formLinkId ?? generateFormLinkId(),
      createdAt: now,
      updatedAt: now,
      submittedAt: savedClient != null ? now : null,
      expiresAt: formExpiry != null ? now.add(formExpiry) : null,
      clientSnapshot: savedClient,
      labSnapshot: savedLabDetails,
      metadata: metadata,
    );

    final doc = await _firestore
        .collection(_labRequestsCollection)
        .add(request.toFirestore());

    return request.copyWith(id: doc.id);
  }

  /// Fetches all lab requests for an optional lab identifier.
  Future<List<LabRequest>> fetchRequests({
    String? labId,
    RequestStatus? status,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(_labRequestsCollection);

    if (labId != null && labId.isNotEmpty) {
      query = query.where('labId', isEqualTo: labId);
    }

    if (status != null) {
      query = query.where('status', isEqualTo: status.value);
    }

    query = query.orderBy('createdAt', descending: true);

    final snapshot = await query.get();
    final requests = snapshot.docs
        .map((doc) => LabRequest.fromFirestore(doc))
        .toList(growable: false);

    return _hydrateRequests(requests);
  }

  /// Returns a single request by document ID.
  Future<LabRequest?> getRequestById(String requestId) async {
    final doc = await _firestore
        .collection(_labRequestsCollection)
        .doc(requestId)
        .get();
    if (!doc.exists) {
      return null;
    }
    final request = LabRequest.fromFirestore(doc);
    return (await _hydrateRequests([request])).first;
  }

  /// Locates a request by form link identifier.
  Future<LabRequest?> getRequestByFormLinkId(String formLinkId) async {
    final snapshot = await _firestore
        .collection(_labRequestsCollection)
        .where('formLinkId', isEqualTo: formLinkId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final request = LabRequest.fromFirestore(snapshot.docs.first);
    return (await _hydrateRequests([request])).first;
  }

  /// Updates a request with new details, optionally replacing client information.
  Future<LabRequest> updateRequest({
    required String requestId,
    List<String>? requestedTests,
    String? urgency,
    String? notes,
    GeoPoint? location,
    ClientProfile? clientProfile,
    bool clearClientSnapshot = false,
    RequestStatus? status,
    String? updatedBy,
    Map<String, dynamic>? metadata,
  }) async {
    final now = DateTime.now();
    final docRef =
        _firestore.collection(_labRequestsCollection).doc(requestId);
    final existingSnapshot = await docRef.get();
    if (!existingSnapshot.exists) {
      throw StateError('Request $requestId not found');
    }

    LabRequest request = LabRequest.fromFirestore(existingSnapshot);
    ClientProfile? savedClient = request.clientSnapshot;

    if (clientProfile != null) {
      savedClient = await upsertClientProfile(clientProfile);
    } else if (clearClientSnapshot) {
      savedClient = null;
    }

    final updates = <String, dynamic>{
      if (requestedTests != null) 'requestedTests': requestedTests,
      if (urgency != null) 'urgency': urgency,
      if (notes != null) 'notes': notes,
      if (location != null) 'location': location,
      if (savedClient != null) ...{
        'clientProfileId': savedClient.id,
        'clientSnapshot': savedClient.toEmbeddedMap(),
      },
      if (savedClient == null && clearClientSnapshot)
        'clientSnapshot': null,
      if (status != null) 'status': status.value,
      'updatedAt': Timestamp.fromDate(now),
      if (metadata != null) 'metadata': metadata,
    };

    if (status != null) {
      switch (status) {
        case RequestStatus.accepted:
          updates['acceptedAt'] = Timestamp.fromDate(now);
          updates['acceptedBy'] = updatedBy;
          break;
        case RequestStatus.inProgress:
          updates['inProgressAt'] = Timestamp.fromDate(now);
          break;
        case RequestStatus.completed:
          updates['completedAt'] = Timestamp.fromDate(now);
          updates['completedBy'] = updatedBy;
          break;
        case RequestStatus.cancelled:
          updates['cancelledAt'] = Timestamp.fromDate(now);
          updates['cancelledBy'] = updatedBy;
          break;
        case RequestStatus.pending:
          // No additional timestamps for pending
          break;
      }
    }

    await docRef.set(updates, SetOptions(merge: true));

    final merged = request.copyWith(
      requestedTests: requestedTests,
      urgency: urgency,
      notes: notes,
      location: location,
      clientProfileId: savedClient?.id,
      clientSnapshot: savedClient,
      status: status,
      updatedAt: now,
      metadata: metadata ?? request.metadata,
    );

    return (await _hydrateRequests([merged])).first;
  }

  /// Updates only the status and related timestamps.
  Future<LabRequest> updateStatus({
    required String requestId,
    required RequestStatus status,
    String? updatedBy,
  }) {
    return updateRequest(
      requestId: requestId,
      status: status,
      updatedBy: updatedBy,
    );
  }

  /// Attaches a client submission to an existing request.
  Future<LabRequest> submitClientForm({
    required String formLinkId,
    required ClientProfile clientProfile,
    required List<String> requestedTests,
    required String urgency,
    String? notes,
    GeoPoint? location,
    Map<String, dynamic>? metadata,
  }) async {
    final request = await getRequestByFormLinkId(formLinkId);
    if (request == null) {
      throw StateError('No request found for link $formLinkId');
    }

    if (request.expiresAt != null &&
        request.expiresAt!.isBefore(DateTime.now()) &&
        !request.hasClientSubmission) {
      if (request.id != null) {
        await deleteRequest(request.id!);
      }
      throw StateError('This form link has expired');
    }

    if (request.hasClientSubmission) {
      throw StateError('This form has already been submitted');
    }

    final profileForUpsert = (clientProfile.id == null &&
            request.clientProfileId != null)
        ? clientProfile.copyWith(id: request.clientProfileId)
        : clientProfile;

    final now = DateTime.now();
    final savedClient = await upsertClientProfile(profileForUpsert);
    final docRef =
        _firestore.collection(_labRequestsCollection).doc(request.id);

    final mergedMetadata = <String, dynamic>{
      if (request.metadata != null) ...request.metadata!,
      if (metadata != null) ...metadata,
    };

    await docRef.set({
      'clientProfileId': savedClient.id,
      'clientSnapshot': savedClient.toEmbeddedMap(),
      'requestedTests': requestedTests,
      'urgency': urgency,
      'notes': notes,
      'location': location ?? savedClient.location,
      'status': RequestStatus.pending.value,
      'submittedAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      if (mergedMetadata.isNotEmpty) 'metadata': mergedMetadata,
    }, SetOptions(merge: true));

    final merged = request.copyWith(
      clientProfileId: savedClient.id,
      clientSnapshot: savedClient,
      requestedTests: requestedTests,
      urgency: urgency,
      notes: notes,
      location: location ?? savedClient.location,
      status: RequestStatus.pending,
      submittedAt: now,
      updatedAt: now,
      metadata:
          mergedMetadata.isNotEmpty ? mergedMetadata : request.metadata,
    );

    return (await _hydrateRequests([merged])).first;
  }

  /// Removes a request document completely.
  Future<void> deleteRequest(String requestId) async {
    await _firestore
        .collection(_labRequestsCollection)
        .doc(requestId)
        .delete();
  }

  Future<List<LabRequest>> _hydrateRequests(List<LabRequest> requests) async {
    final clientIds = requests
        .map((req) => req.clientProfileId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
    final labIds = requests
        .map((req) => req.labDetailsId ?? req.labId)
        .where((id) => id.isNotEmpty)
        .toSet();

    final clientProfiles = await _fetchClientProfiles(clientIds);
    final labDetails = await _fetchLabDetails(labIds);

    return requests
        .map(
          (req) => req.copyWith(
            clientSnapshot: clientProfiles[req.clientProfileId],
            labSnapshot: labDetails[req.labDetailsId ?? req.labId],
          ),
        )
        .toList(growable: false);
  }

  Future<Map<String, ClientProfile>> _fetchClientProfiles(
      Set<String> ids) async {
    if (ids.isEmpty) {
      return {};
    }

    final chunks = _chunk(ids.toList(), 10);
    final results = <String, ClientProfile>{};
    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection(_clientProfilesCollection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snapshot.docs) {
        final profile = ClientProfile.fromFirestore(doc);
        if (profile.id != null) {
          results[profile.id!] = profile;
        }
      }
    }
    return results;
  }

  Future<Map<String, LabDetails>> _fetchLabDetails(Set<String> ids) async {
    if (ids.isEmpty) {
      return {};
    }

    final chunks = _chunk(ids.toList(), 10);
    final results = <String, LabDetails>{};
    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection(_labDetailsCollection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snapshot.docs) {
        final details = LabDetails.fromFirestore(doc);
        if (details.id != null) {
          results[details.id!] = details;
        }
      }
    }
    return results;
  }

  List<List<T>> _chunk<T>(List<T> items, int size) {
    if (items.isEmpty) {
      return const [];
    }
    if (items.length <= size) {
      return [items];
    }
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += size) {
      chunks.add(items.sublist(i, i + size > items.length ? items.length : i + size));
    }
    return chunks;
  }
}

