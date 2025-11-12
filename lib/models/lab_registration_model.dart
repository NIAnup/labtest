import 'package:cloud_firestore/cloud_firestore.dart';

class LabDocumentTypes {
  LabDocumentTypes._();

  static const String identityProof = 'identity_proof';
  static const String businessRegistration = 'business_registration';
  static const String gstCertificate = 'gst_certificate';
  static const String clinicalLicense = 'clinical_license';
}

class LabDocument {
  const LabDocument({
    required this.type,
    required this.label,
    required this.originalFileName,
    this.storagePath,
    this.uploaded = false,
    this.uploadedAt,
  });

  final String type;
  final String label;
  final String originalFileName;
  final String? storagePath;
  final bool uploaded;
  final DateTime? uploadedAt;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'label': label,
      'originalFileName': originalFileName,
      'storagePath': storagePath,
      'uploaded': uploaded,
      'uploadedAt': uploadedAt != null ? Timestamp.fromDate(uploadedAt!) : null,
    }..removeWhere((key, value) => value == null);
  }

  factory LabDocument.fromMap(Map<String, dynamic> map) {
    return LabDocument(
      type: map['type'] as String,
      label: map['label'] as String? ?? '',
      originalFileName: map['originalFileName'] as String? ?? '',
      storagePath: map['storagePath'] as String?,
      uploaded: map['uploaded'] as bool? ?? false,
      uploadedAt: map['uploadedAt'] is Timestamp
          ? (map['uploadedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

class LabRegistrationStatus {
  LabRegistrationStatus._();

  static const String underReview = 'under_review';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
}

class LabRegistration {
  const LabRegistration({
    required this.labName,
    required this.ownerName,
    required this.contactNumber,
    required this.email,
    required this.labAddress,
    required this.cityStatePincode,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.issuedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.documents,
    this.id,
    this.authUid,
    this.identityProofType,
    this.businessType,
    this.gstNumber,
    this.panNumber,
    this.isGstRegistered,
    this.reviewNotes,
    this.emailVerified = false,
  });

  static const String collectionName = 'lab_registrations';

  final String? id;
  final String? authUid;
  final String labName;
  final String ownerName;
  final String contactNumber;
  final String email;
  final String labAddress;
  final String cityStatePincode;
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final String issuedBy;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LabDocument> documents;
  final String? identityProofType;
  final String? businessType;
  final String? gstNumber;
  final String? panNumber;
  final String? isGstRegistered;
  final String? reviewNotes;
  final bool emailVerified;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'authUid': authUid,
      'labName': labName,
      'ownerName': ownerName,
      'contactNumber': contactNumber,
      'email': email,
      'labAddress': labAddress,
      'cityStatePincode': cityStatePincode,
      'identityProofType': identityProofType,
      'businessType': businessType,
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'isGstRegistered': isGstRegistered,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': Timestamp.fromDate(licenseExpiryDate),
      'issuedBy': issuedBy,
      'status': status,
      'reviewNotes': reviewNotes,
      'emailVerified': emailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'documents': documents.map((doc) => doc.toMap()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  factory LabRegistration.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return LabRegistration(
      id: data['id'] as String? ?? snapshot.id,
      authUid: data['authUid'] as String?,
      labName: data['labName'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? '',
      contactNumber: data['contactNumber'] as String? ?? '',
      email: data['email'] as String? ?? '',
      labAddress: data['labAddress'] as String? ?? '',
      cityStatePincode: data['cityStatePincode'] as String? ?? '',
      identityProofType: data['identityProofType'] as String?,
      businessType: data['businessType'] as String?,
      gstNumber: data['gstNumber'] as String?,
      panNumber: data['panNumber'] as String?,
      isGstRegistered: data['isGstRegistered'] as String?,
      licenseNumber: data['licenseNumber'] as String? ?? '',
      licenseExpiryDate: (data['licenseExpiryDate'] as Timestamp).toDate(),
      issuedBy: data['issuedBy'] as String? ?? '',
      status: data['status'] as String? ?? LabRegistrationStatus.underReview,
      reviewNotes: data['reviewNotes'] as String?,
      emailVerified: data['emailVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      documents: (data['documents'] as List<dynamic>? ?? [])
          .map((item) => LabDocument.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  LabRegistration copyWith({
    String? id,
    String? authUid,
    String? labName,
    String? ownerName,
    String? contactNumber,
    String? email,
    String? labAddress,
    String? cityStatePincode,
    String? identityProofType,
    String? businessType,
    String? gstNumber,
    String? panNumber,
    String? isGstRegistered,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    String? issuedBy,
    String? status,
    String? reviewNotes,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<LabDocument>? documents,
  }) {
    return LabRegistration(
      id: id ?? this.id,
      authUid: authUid ?? this.authUid,
      labName: labName ?? this.labName,
      ownerName: ownerName ?? this.ownerName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      labAddress: labAddress ?? this.labAddress,
      cityStatePincode: cityStatePincode ?? this.cityStatePincode,
      identityProofType: identityProofType ?? this.identityProofType,
      businessType: businessType ?? this.businessType,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      isGstRegistered: isGstRegistered ?? this.isGstRegistered,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      issuedBy: issuedBy ?? this.issuedBy,
      status: status ?? this.status,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documents: documents ?? this.documents,
    );
  }
}
