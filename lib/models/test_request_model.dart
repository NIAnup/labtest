import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for Lab Test Request
class TestRequest {
  final String? id;
  final String patientName;
  final String location;
  final String bloodTestType;
  final String urgency; // 'Normal' or 'Urgent'
  final String status; // 'New', 'Pending', 'Active', 'Completed', 'Cancelled'
  final String formLinkId; // Unique ID for the form link
  final DateTime createdAt;
  final DateTime? submittedAt;
  final String? submittedBy;
  final String? labId;
  final Map<String, dynamic>? clientSubmission; // Client's filled data

  TestRequest({
    this.id,
    required this.patientName,
    required this.location,
    required this.bloodTestType,
    required this.urgency,
    this.status = 'New',
    required this.formLinkId,
    required this.createdAt,
    this.submittedAt,
    this.submittedBy,
    this.labId,
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
      status: data['status'] ?? 'New',
      formLinkId: data['formLinkId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      submittedBy: data['submittedBy'],
      labId: data['labId'],
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
    Map<String, dynamic>? clientSubmission,
  }) {
    return TestRequest(
      id: id,
      patientName: patientName ?? this.patientName,
      location: location ?? this.location,
      bloodTestType: bloodTestType ?? this.bloodTestType,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      formLinkId: formLinkId,
      createdAt: createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      submittedBy: submittedBy ?? this.submittedBy,
      labId: labId,
      clientSubmission: clientSubmission ?? this.clientSubmission,
    );
  }

  // Get the shareable form link
  String getFormLink({bool useAbsoluteUrl = true}) {
    if (useAbsoluteUrl) {
      // In production, this would be the actual domain
      return 'https://labtest.com/form/$formLinkId';
    } else {
      // Relative URL for in-app navigation
      return '/form/$formLinkId';
    }
  }

  // Check if form has been submitted
  bool get isSubmitted => submittedAt != null && clientSubmission != null;
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
