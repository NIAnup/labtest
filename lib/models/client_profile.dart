import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a patient/client who can submit a test request.
class ClientProfile {
  final String? id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final GeoPoint? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientProfile({
    this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.location,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get fullName => [firstName, lastName]
      .where((value) => value.trim().isNotEmpty)
      .join(' ')
      .trim();

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
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'location': location,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toEmbeddedMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'fullAddress': fullAddress,
      'location': location,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ClientProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    GeoPoint? location,
    bool clearLocation = false,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      location: clearLocation ? null : (location ?? this.location),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory ClientProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ClientProfile.fromMap(data, id: doc.id);
  }

  factory ClientProfile.fromMap(Map<String, dynamic> data, {String? id}) {
    return ClientProfile(
      id: id,
      firstName: (data['firstName'] ?? '') as String,
      lastName: (data['lastName'] ?? '') as String,
      phoneNumber: data['phoneNumber'] as String?,
      email: data['email'] as String?,
      addressLine1: data['addressLine1'] as String?,
      addressLine2: data['addressLine2'] as String?,
      city: data['city'] as String?,
      state: data['state'] as String?,
      postalCode: data['postalCode'] as String?,
      location: data['location'] is GeoPoint ? data['location'] as GeoPoint : null,
      notes: data['notes'] as String?,
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

