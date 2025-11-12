import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a diagnostic lab location that can accept requests.
class LabDetails {
  final String? id;
  final String name;
  final String? contactEmail;
  final String? contactPhone;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabDetails({
    this.id,
    required this.name,
    this.contactEmail,
    this.contactPhone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String? get fullAddress {
    final parts = <String>[
      if ((addressLine1 ?? '').trim().isNotEmpty) addressLine1!.trim(),
      if ((addressLine2 ?? '').trim().isNotEmpty) addressLine2!.trim(),
      [
        if ((city ?? '').trim().isNotEmpty) city!.trim(),
        if ((state ?? '').trim().isNotEmpty) state!.trim(),
      ].where((value) => value.isNotEmpty).join(', '),
      if ((postalCode ?? '').trim().isNotEmpty) postalCode!.trim(),
    ].where((value) => value.isNotEmpty).toList();

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(', ');
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toEmbeddedMap() {
    return {
      'id': id,
      'name': name,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  LabDetails copyWith({
    String? id,
    String? name,
    String? contactEmail,
    String? contactPhone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool clearLocation = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory LabDetails.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LabDetails.fromMap(data, id: doc.id);
  }

  factory LabDetails.fromMap(Map<String, dynamic> data, {String? id}) {
    return LabDetails(
      id: id,
      name: (data['name'] ?? '') as String,
      contactEmail: data['contactEmail'] as String?,
      contactPhone: data['contactPhone'] as String?,
      addressLine1: data['addressLine1'] as String?,
      addressLine2: data['addressLine2'] as String?,
      city: data['city'] as String?,
      state: data['state'] as String?,
      postalCode: data['postalCode'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}

