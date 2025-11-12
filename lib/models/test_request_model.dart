import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for Lab Test Request
class TestRequest {
  final String? id;
  final String patientName;
  final String location;
  final String bloodTestType;
  final String urgency; // 'Normal' or 'Urgent'
  final String status; // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
  final String formLinkId; // Unique ID for the form link
  final DateTime createdAt;
  final DateTime? submittedAt;
  final String? submittedBy;
  final String? labId; // Lab user who created this form
  final DateTime? expiresAt; // Form expiration time (1 hour after creation)
  final Map<String, dynamic>? clientSubmission; // Client's filled data

  TestRequest({
    this.id,
    this.patientName = '',
    this.location = '',
    this.bloodTestType = '',
    this.urgency = 'Normal',
    this.status = 'pending',
    required this.formLinkId,
    required this.createdAt,
    this.submittedAt,
    this.submittedBy,
    this.labId,
    this.expiresAt,
    this.clientSubmission,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'patientName': patientName,
      'location': location,
      'bloodTestType': bloodTestType,
      'urgency': urgency,
      'status': status,
      'formLinkId': formLinkId,
      'createdAt': Timestamp.fromDate(createdAt),
      'submittedAt':
          submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
      'submittedBy': submittedBy,
      'labId': labId,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'clientSubmission': clientSubmission,
    };
  }

  // Create from Firestore document
  factory TestRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TestRequest(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      location: data['location'] ?? '',
      bloodTestType: data['bloodTestType'] ?? '',
      urgency: data['urgency'] ?? 'Normal',
      status: _normalizeStatus(data['status']),
      formLinkId: data['formLinkId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      submittedBy: data['submittedBy'],
      labId: data['labId'],
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      clientSubmission: data['clientSubmission'],
    );
  }

  // Copy with method for updates
  TestRequest copyWith({
    String? patientName,
    String? location,
    String? bloodTestType,
    String? urgency,
    String? status,
    DateTime? submittedAt,
    String? submittedBy,
    DateTime? expiresAt,
    Map<String, dynamic>? clientSubmission,
  }) {
    return TestRequest(
      id: id,
      patientName: patientName ?? this.patientName,
      location: location ?? this.location,
      bloodTestType: bloodTestType ?? this.bloodTestType,
      urgency: urgency ?? this.urgency,
      status: status != null ? _normalizeStatus(status) : this.status,
      formLinkId: formLinkId,
      createdAt: createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      submittedBy: submittedBy ?? this.submittedBy,
      labId: labId,
      expiresAt: expiresAt ?? this.expiresAt,
      clientSubmission: clientSubmission ?? this.clientSubmission,
    );
  }

  // Get the shareable form link
  String getFormLink({bool useAbsoluteUrl = true}) {
    if (useAbsoluteUrl) {
      // In production, this would be the actual domain
      return 'https://localhost:51973/form/$formLinkId';
    } else {
      // Relative URL for in-app navigation
      return '/form/$formLinkId';
    }
  }

  // Check if form has been submitted
  bool get isSubmitted => submittedAt != null && clientSubmission != null;

  // Check if form has expired (not submitted and expired)
  bool get isExpired {
    if (isSubmitted) return false; // Submitted forms don't expire
    if (expiresAt == null) return false; // No expiration set
    return DateTime.now().isAfter(expiresAt!);
  }

  // Check if form is close to expiring (within 10 minutes)
  bool get isExpiringSoon {
    if (isSubmitted || expiresAt == null) return false;
    final timeUntilExpiry = expiresAt!.difference(DateTime.now());
    return timeUntilExpiry.inMinutes <= 10 && timeUntilExpiry.inMinutes > 0;
  }

  // Get remaining time until expiration
  Duration? get timeUntilExpiry {
    if (isSubmitted || expiresAt == null) return null;
    final diff = expiresAt!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  static String _normalizeStatus(dynamic rawStatus) {
    final value = rawStatus?.toString().toLowerCase().trim();
    switch (value) {
      case 'accepted':
        return 'accepted';
      case 'active':
      case 'in_progress':
      case 'in progress':
        return 'in_progress';
      case 'completed':
        return 'completed';
      case 'cancelled':
      case 'canceled':
        return 'cancelled';
      case 'pending':
      case 'new':
      case '':
      case null:
        return 'pending';
      default:
        return 'pending';
    }
  }
}

/// Model for client form submission
class ClientSubmission {
  final String patientName;
  final String location;
  final String bloodTestType;
  final String urgency;
  final DateTime submittedAt;
  final String? additionalNotes;

  ClientSubmission({
    required this.patientName,
    required this.location,
    required this.bloodTestType,
    required this.urgency,
    required this.submittedAt,
    this.additionalNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'location': location,
      'bloodTestType': bloodTestType,
      'urgency': urgency,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'additionalNotes': additionalNotes,
    };
  }

  factory ClientSubmission.fromMap(Map<String, dynamic> map) {
    return ClientSubmission(
      patientName: map['patientName'] ?? '',
      location: map['location'] ?? '',
      bloodTestType: map['bloodTestType'] ?? '',
      urgency: map['urgency'] ?? 'Normal',
      submittedAt:
          (map['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      additionalNotes: map['additionalNotes'],
    );
  }
}
