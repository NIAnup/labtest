import 'package:cloud_firestore/cloud_firestore.dart';

import 'client_profile.dart';
import 'lab_details.dart';
import 'request_status.dart';
import 'test_request_model.dart';

/// Represents a single lab request stored in Firestore with normalized relations.
class LabRequest {
  final String? id;
  final String labId;
  final String? labDetailsId;
  final String? clientProfileId;
  final String createdBy;
  final String? acceptedBy;
  final String? completedBy;
  final String? cancelledBy;
  final RequestStatus status;
  final String urgency;
  final List<String> requestedTests;
  final String? notes;
  final GeoPoint? location;
  final String? formLinkId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? submittedAt;
  final DateTime? acceptedAt;
  final DateTime? inProgressAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? expiresAt;
  final ClientProfile? clientSnapshot;
  final LabDetails? labSnapshot;
  final Map<String, dynamic>? metadata;

  LabRequest({
    this.id,
    required this.labId,
    this.labDetailsId,
    this.clientProfileId,
    required this.createdBy,
    this.acceptedBy,
    this.completedBy,
    this.cancelledBy,
    this.status = RequestStatus.pending,
    this.urgency = 'Normal',
    List<String>? requestedTests,
    this.notes,
    this.location,
    this.formLinkId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.submittedAt,
    this.acceptedAt,
    this.inProgressAt,
    this.completedAt,
    this.cancelledAt,
    this.expiresAt,
    this.clientSnapshot,
    this.labSnapshot,
    this.metadata,
  })  : requestedTests = List.unmodifiable(requestedTests ?? const []),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get hasClientSubmission => clientSnapshot != null;

  LabRequest copyWith({
    String? id,
    String? labId,
    String? labDetailsId,
    String? clientProfileId,
    String? createdBy,
    String? acceptedBy,
    String? completedBy,
    String? cancelledBy,
    RequestStatus? status,
    String? urgency,
    List<String>? requestedTests,
    String? notes,
    GeoPoint? location,
    String? formLinkId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? submittedAt,
    DateTime? acceptedAt,
    DateTime? inProgressAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? expiresAt,
    ClientProfile? clientSnapshot,
    bool clearClientSnapshot = false,
    LabDetails? labSnapshot,
    bool clearLabSnapshot = false,
    Map<String, dynamic>? metadata,
  }) {
    return LabRequest(
      id: id ?? this.id,
      labId: labId ?? this.labId,
      labDetailsId: labDetailsId ?? this.labDetailsId,
      clientProfileId: clientProfileId ?? this.clientProfileId,
      createdBy: createdBy ?? this.createdBy,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      completedBy: completedBy ?? this.completedBy,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      requestedTests: requestedTests ?? this.requestedTests,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      formLinkId: formLinkId ?? this.formLinkId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      submittedAt: submittedAt ?? this.submittedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      inProgressAt: inProgressAt ?? this.inProgressAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      expiresAt: expiresAt ?? this.expiresAt,
      clientSnapshot: clearClientSnapshot ? null : (clientSnapshot ?? this.clientSnapshot),
      labSnapshot: clearLabSnapshot ? null : (labSnapshot ?? this.labSnapshot),
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'labId': labId,
      'labDetailsId': labDetailsId,
      'clientProfileId': clientProfileId,
      'createdBy': createdBy,
      'acceptedBy': acceptedBy,
      'completedBy': completedBy,
      'cancelledBy': cancelledBy,
      'status': status.value,
      'urgency': urgency,
      'requestedTests': requestedTests,
      'notes': notes,
      'location': location,
      'formLinkId': formLinkId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'submittedAt':
          submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'inProgressAt':
          inProgressAt != null ? Timestamp.fromDate(inProgressAt!) : null,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'cancelledAt':
          cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'clientSnapshot': clientSnapshot?.toEmbeddedMap(),
      'labSnapshot': labSnapshot?.toEmbeddedMap(),
      'metadata': metadata,
    };
  }

  factory LabRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LabRequest.fromMap(data, id: doc.id);
  }

  factory LabRequest.fromMap(Map<String, dynamic> data, {String? id}) {
    ClientProfile? client;
    final clientData = data['clientSnapshot'];
    if (clientData is Map<String, dynamic>) {
      client = ClientProfile.fromMap(clientData);
    }

    LabDetails? lab;
    final labData = data['labSnapshot'];
    if (labData is Map<String, dynamic>) {
      lab = LabDetails.fromMap(labData);
    }

    return LabRequest(
      id: id,
      labId: (data['labId'] ?? '') as String,
      labDetailsId: data['labDetailsId'] as String?,
      clientProfileId: data['clientProfileId'] as String?,
      createdBy: (data['createdBy'] ?? '') as String,
      acceptedBy: data['acceptedBy'] as String?,
      completedBy: data['completedBy'] as String?,
      cancelledBy: data['cancelledBy'] as String?,
      status: RequestStatusValue.fromValue(data['status'] as String?),
      urgency: (data['urgency'] ?? 'Normal') as String,
      requestedTests: (data['requestedTests'] as List<dynamic>?)
              ?.map((value) => value.toString())
              .toList() ??
          const [],
      notes: data['notes'] as String?,
      location: data['location'] is GeoPoint ? data['location'] as GeoPoint : null,
      formLinkId: data['formLinkId'] as String?,
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
      submittedAt: _nullableTimestamp(data['submittedAt']),
      acceptedAt: _nullableTimestamp(data['acceptedAt']),
      inProgressAt: _nullableTimestamp(data['inProgressAt']),
      completedAt: _nullableTimestamp(data['completedAt']),
      cancelledAt: _nullableTimestamp(data['cancelledAt']),
      expiresAt: _nullableTimestamp(data['expiresAt']),
      clientSnapshot: client,
      labSnapshot: lab,
      metadata: (data['metadata'] as Map<String, dynamic>?),
    );
  }

  TestRequest toLegacyTestRequest() {
    final client = clientSnapshot;

    double? _toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return null;
    }

    final metadataCoords = metadata?['coordinates'];
    final metadataLat = metadataCoords is Map ? _toDouble(metadataCoords['lat']) : null;
    final metadataLng = metadataCoords is Map ? _toDouble(metadataCoords['lng']) : null;

    final patientName = client?.fullName ??
        metadata?['patientName'] as String? ??
        '';
    final locationText = client?.fullAddress ??
        metadata?['addressLine1'] as String? ??
        metadata?['location'] as String? ??
        notes ??
        '';

    final submissionMap = <String, dynamic>{
      'patientName': patientName,
      'location': locationText,
      'bloodTestType': requestedTests.join(', '),
      'urgency': urgency,
    };

    if (requestedTests.isNotEmpty) {
      submissionMap['requestedTests'] = requestedTests;
    }

    final combinedNotes = client?.notes ?? metadata?['notes'] as String?;
    if (combinedNotes != null && combinedNotes.isNotEmpty) {
      submissionMap['additionalNotes'] = combinedNotes;
    }

    final phoneNumber = client?.phoneNumber ?? metadata?['phoneNumber'] as String?;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      submissionMap['phoneNumber'] = phoneNumber;
    }

    final email = client?.email ?? metadata?['email'] as String?;
    if (email != null && email.isNotEmpty) {
      submissionMap['email'] = email;
    }

    final addressLine1 = client?.addressLine1 ?? metadata?['addressLine1'] as String?;
    if (addressLine1 != null && addressLine1.isNotEmpty) {
      submissionMap['addressLine1'] = addressLine1;
    }

    final addressLine2 = client?.addressLine2 ?? metadata?['addressLine2'] as String?;
    if (addressLine2 != null && addressLine2.isNotEmpty) {
      submissionMap['addressLine2'] = addressLine2;
    }

    final city = client?.city ?? metadata?['city'] as String?;
    if (city != null && city.isNotEmpty) {
      submissionMap['city'] = city;
    }

    final state = client?.state ?? metadata?['state'] as String?;
    if (state != null && state.isNotEmpty) {
      submissionMap['state'] = state;
    }

    final postalCode = client?.postalCode ?? metadata?['postalCode'] as String?;
    if (postalCode != null && postalCode.isNotEmpty) {
      submissionMap['postalCode'] = postalCode;
    }

    final latitude = client?.location?.latitude ?? metadataLat;
    if (latitude != null) {
      submissionMap['latitude'] = latitude;
    }

    final longitude = client?.location?.longitude ?? metadataLng;
    if (longitude != null) {
      submissionMap['longitude'] = longitude;
    }

    if (submittedAt != null) {
      submissionMap['submittedAt'] = Timestamp.fromDate(submittedAt!);
    }

    return TestRequest(
      id: id,
      patientName: patientName,
      location: locationText,
      bloodTestType: requestedTests.join(', '),
      urgency: urgency,
      status: status.value,
      formLinkId: formLinkId ?? '',
      createdAt: createdAt,
      submittedAt: submittedAt,
      submittedBy: client?.id ?? submittedByFallback,
      labId: labId,
      expiresAt: expiresAt,
      clientSubmission: submissionMap,
    );
  }

  String? get submittedByFallback => clientSnapshot?.id ?? clientProfileId;

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  static DateTime? _nullableTimestamp(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}

