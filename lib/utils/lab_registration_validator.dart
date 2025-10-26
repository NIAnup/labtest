import 'dart:io';

class LabRegistrationValidator {
  // Validation patterns
  static final RegExp _panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  static final RegExp _gstPattern =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
  static final RegExp _phonePattern = RegExp(r'^[+]?[0-9]{10,15}$');
  static final RegExp _emailPattern =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _licensePattern = RegExp(r'^[A-Z]{2}/[A-Z]{2}/\d{4}$');

  // Basic field validations
  static String? validateLabName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter lab name';
    }
    if (value.length < 3) {
      return 'Lab name must be at least 3 characters';
    }
    return null;
  }

  static String? validateOwnerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter owner name';
    }
    if (value.length < 2) {
      return 'Owner name must be at least 2 characters';
    }
    return null;
  }

  static String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter contact number';
    }
    if (!_phonePattern.hasMatch(value)) {
      return 'Please enter valid phone number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!_emailPattern.hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter address';
    }
    if (value.length < 10) {
      return 'Address must be at least 10 characters';
    }
    return null;
  }

  static String? validateCityStatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter city/state/pincode';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Business validation
  static String? validateGstNumber(String? value, bool isGstRegistered) {
    if (isGstRegistered) {
      if (value == null || value.isEmpty) {
        return 'Please enter GST number';
      }
      if (!_gstPattern.hasMatch(value)) {
        return 'Please enter valid GST number (15-digit GSTIN)';
      }
    }
    return null;
  }

  static String? validatePanNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter PAN number';
    }
    if (!_panPattern.hasMatch(value)) {
      return 'Please enter valid PAN number';
    }
    return null;
  }

  static String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter license number';
    }
    // Basic validation - can be enhanced based on specific state formats
    if (value.length < 5) {
      return 'License number seems too short';
    }
    return null;
  }

  static String? validateIssuedBy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter issuing authority';
    }
    return null;
  }

  // File validation
  static String? validateFileUpload(File? file, String fieldName) {
    if (file == null) {
      return 'Please upload $fieldName';
    }

    // Check file size (10MB limit)
    int fileSizeInBytes = file.lengthSync();
    int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);

    if (fileSizeInMB > 10) {
      return 'File size must be less than 10MB';
    }

    return null;
  }

  // Document validation
  static String? validateIdentityProof(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select identity proof';
    }
    return null;
  }

  static String? validateBusinessType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select business type';
    }
    return null;
  }

  static String? validateGstRegistration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select GST registration status';
    }
    return null;
  }

  static String? validateLicenseExpiryDate(DateTime? value) {
    if (value == null) {
      return 'Please select license expiry date';
    }
    if (value.isBefore(DateTime.now())) {
      return 'License expiry date cannot be in the past';
    }
    return null;
  }

  // GST API validation (mock implementation)
  static Future<bool> validateGstWithApi(
      String gstNumber, String businessName) async {
    // This would typically make an API call to GST validation service
    // For now, returning true as a mock
    await Future.delayed(Duration(seconds: 1)); // Simulate API call
    return true;
  }

  // PAN API validation (mock implementation)
  static Future<bool> validatePanWithApi(String panNumber) async {
    // This would typically make an API call to PAN validation service
    // For now, returning true as a mock
    await Future.delayed(Duration(seconds: 1)); // Simulate API call
    return true;
  }

  // License format validation based on state
  static bool validateLicenseFormat(String licenseNumber, String state) {
    // Different states have different license formats
    // This is a simplified implementation
    switch (state.toLowerCase()) {
      case 'up':
      case 'uttar pradesh':
        return RegExp(r'^CE/UP/\d{4}$').hasMatch(licenseNumber);
      case 'mh':
      case 'maharashtra':
        return RegExp(r'^CE/MH/\d{4}$').hasMatch(licenseNumber);
      case 'ka':
      case 'karnataka':
        return RegExp(r'^CE/KA/\d{4}$').hasMatch(licenseNumber);
      default:
        return licenseNumber.length >= 5; // Basic validation
    }
  }

  // Complete form validation
  static Map<String, String> validateCompleteForm({
    required String labName,
    required String ownerName,
    required String contactNumber,
    required String email,
    required String address,
    required String cityStatePincode,
    required String password,
    required String confirmPassword,
    required String? identityProof,
    required String? businessType,
    required String? isGstRegistered,
    required String? gstNumber,
    required File? businessRegistrationFile,
    required File? gstCertificateFile,
    required String licenseNumber,
    required String issuedBy,
    required DateTime? licenseExpiryDate,
    required File? clinicalLicenseFile,
  }) {
    Map<String, String> errors = {};

    // Basic information validation
    String? error = validateLabName(labName);
    if (error != null) errors['labName'] = error;

    error = validateOwnerName(ownerName);
    if (error != null) errors['ownerName'] = error;

    error = validateContactNumber(contactNumber);
    if (error != null) errors['contactNumber'] = error;

    error = validateEmail(email);
    if (error != null) errors['email'] = error;

    error = validateAddress(address);
    if (error != null) errors['address'] = error;

    error = validateCityStatePincode(cityStatePincode);
    if (error != null) errors['cityStatePincode'] = error;

    error = validatePassword(password);
    if (error != null) errors['password'] = error;

    error = validateConfirmPassword(confirmPassword, password);
    if (error != null) errors['confirmPassword'] = error;

    // Identity proof validation
    error = validateIdentityProof(identityProof);
    if (error != null) errors['identityProof'] = error;

    // Business information validation
    error = validateBusinessType(businessType);
    if (error != null) errors['businessType'] = error;

    error = validateGstRegistration(isGstRegistered);
    if (error != null) errors['gstRegistration'] = error;

    if (isGstRegistered == 'Yes') {
      error = validateGstNumber(gstNumber, true);
      if (error != null) errors['gstNumber'] = error;

      error = validateFileUpload(gstCertificateFile, 'GST certificate');
      if (error != null) errors['gstCertificate'] = error;
    }

    error = validateFileUpload(
        businessRegistrationFile, 'business registration certificate');
    if (error != null) errors['businessRegistration'] = error;

    // Clinical information validation
    error = validateLicenseNumber(licenseNumber);
    if (error != null) errors['licenseNumber'] = error;

    error = validateIssuedBy(issuedBy);
    if (error != null) errors['issuedBy'] = error;

    error = validateLicenseExpiryDate(licenseExpiryDate);
    if (error != null) errors['licenseExpiryDate'] = error;

    error = validateFileUpload(clinicalLicenseFile, 'clinical license');
    if (error != null) errors['clinicalLicense'] = error;

    return errors;
  }
}
