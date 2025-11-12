import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/models/lab_registration_model.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:labtest/utils/route_names.dart';

class LabRegistrationProvider extends ChangeNotifier {
  LabRegistrationProvider();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController labNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController labAddressController = TextEditingController();
  final TextEditingController cityStatePincodeController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController issuedByController = TextEditingController();

  // Form state
  final PageController pageController = PageController();
  int _currentStep = 0;
  final int totalSteps = 4;
  bool _isSubmitting = false;

  // Dropdown values
  String? _selectedIdentityProof;
  String? _selectedBusinessType;
  String? _isGstRegistered;

  // Date
  DateTime? _licenseExpiryDate;

  // File uploads
  File? _businessRegistrationFile;
  File? _gstCertificateFile;
  File? _clinicalLicenseFile;
  File? _identityProofFile;

  // Validation patterns
  final RegExp gstPattern =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
  final RegExp phonePattern = RegExp(r'^[+]?[0-9]{10,15}$');

  // Getters
  int get currentStep => _currentStep;
  String? get selectedIdentityProof => _selectedIdentityProof;
  String? get selectedBusinessType => _selectedBusinessType;
  String? get isGstRegistered => _isGstRegistered;
  DateTime? get licenseExpiryDate => _licenseExpiryDate;
  File? get businessRegistrationFile => _businessRegistrationFile;
  File? get gstCertificateFile => _gstCertificateFile;
  File? get clinicalLicenseFile => _clinicalLicenseFile;
  File? get identityProofFile => _identityProofFile;
  bool get isSubmitting => _isSubmitting;

  // Setters
  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  set selectedIdentityProof(String? value) {
    _selectedIdentityProof = value;
    notifyListeners();
  }

  set selectedBusinessType(String? value) {
    _selectedBusinessType = value;
    notifyListeners();
  }

  set isGstRegistered(String? value) {
    _isGstRegistered = value;
    notifyListeners();
  }

  set licenseExpiryDate(DateTime? value) {
    _licenseExpiryDate = value;
    notifyListeners();
  }

  set businessRegistrationFile(File? value) {
    _businessRegistrationFile = value;
    notifyListeners();
  }

  set gstCertificateFile(File? value) {
    _gstCertificateFile = value;
    notifyListeners();
  }

  set clinicalLicenseFile(File? value) {
    _clinicalLicenseFile = value;
    notifyListeners();
  }

  set identityProofFile(File? value) {
    _identityProofFile = value;
    notifyListeners();
  }

  set isSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }

  // Navigation methods
  void nextStep() {
    if (currentStep < totalSteps - 1) {
      currentStep = currentStep + 1;
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep = currentStep - 1;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep = step;
      pageController.animateToPage(
        step,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Validation methods
  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return _validateBasicInformation();
      case 1:
        return _validateIdentityProof();
      case 2:
        return _validateBusinessInformation();
      case 3:
        return _validateClinicalInformation();
      default:
        return true;
    }
  }

  bool _validateBasicInformation() {
    if (labNameController.text.isEmpty) return false;
    if (ownerNameController.text.isEmpty) return false;
    if (contactNumberController.text.isEmpty ||
        !phonePattern.hasMatch(contactNumberController.text)) return false;
    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(emailController.text)) return false;
    if (labAddressController.text.isEmpty) return false;
    if (cityStatePincodeController.text.isEmpty) return false;
    if (passwordController.text.isEmpty || passwordController.text.length < 8)
      return false;
    if (confirmPasswordController.text.isEmpty ||
        confirmPasswordController.text != passwordController.text) return false;
    return true;
  }

  bool _validateIdentityProof() {
    return _selectedIdentityProof != null;
  }

  bool _validateBusinessInformation() {
    if (_selectedBusinessType == null) return false;
    if (_isGstRegistered == null) return false;
    if (_isGstRegistered == 'Yes') {
      if (gstNumberController.text.isEmpty ||
          !gstPattern.hasMatch(gstNumberController.text)) return false;
    }
    return true;
  }

  bool _validateClinicalInformation() {
    if (licenseNumberController.text.isEmpty) return false;
    if (_licenseExpiryDate == null) return false;
    if (issuedByController.text.isEmpty) return false;
    return true;
  }

  // File picker methods
  Future<void> pickIdentityDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        identityProofFile = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking identity document: $e');
    }
  }

  Future<void> pickBusinessRegistrationFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        businessRegistrationFile = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking business registration file: $e');
    }
  }

  Future<void> pickGstCertificateFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        gstCertificateFile = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking GST certificate file: $e');
    }
  }

  Future<void> pickClinicalLicenseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        clinicalLicenseFile = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking clinical license file: $e');
    }
  }

  Future<void> selectLicenseExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    );

    if (picked != null) {
      licenseExpiryDate = picked;
    }
  }

  // Form submission
  Future<void> submitRegistration(BuildContext context) async {
    if (isSubmitting) {
      return;
    }

    final expiryDate = licenseExpiryDate;
    final allStepsValid = _validateAllSteps();

    if (!allStepsValid || expiryDate == null) {
      _showSnackBar(
        context,
        'Please complete every section, including document uploads and license details.',
      );
      return;
    }

    isSubmitting = true;

    UserCredential? credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final now = DateTime.now();

      final registration = LabRegistration(
        labName: labNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        email: emailController.text.trim(),
        labAddress: labAddressController.text.trim(),
        cityStatePincode: cityStatePincodeController.text.trim(),
        identityProofType: selectedIdentityProof,
        businessType: selectedBusinessType,
        gstNumber:
            isGstRegistered == 'Yes' ? gstNumberController.text.trim() : null,
        panNumber: panNumberController.text.trim().isEmpty
            ? null
            : panNumberController.text.trim(),
        isGstRegistered: isGstRegistered,
        licenseNumber: licenseNumberController.text.trim(),
        issuedBy: issuedByController.text.trim(),
        licenseExpiryDate: expiryDate,
        status: LabRegistrationStatus.underReview,
        createdAt: now,
        updatedAt: now,
        authUid: credential.user?.uid,
        emailVerified: credential.user?.emailVerified ?? false,
        documents: _buildDocuments(),
      );

      final registrations = _firestore.collection(
        LabRegistration.collectionName,
      );

      final docRef = registrations.doc(
        credential.user?.uid ?? registrations.doc().id,
      );

      final registrationWithId = registration.copyWith(id: docRef.id);

      try {
        await docRef.set(registrationWithId.toFirestore());
      } on FirebaseException catch (firestoreError) {
        KDebugPrint.error(
          'Failed to persist lab registration data: ${firestoreError.message}',
        );

        if (credential.user != null) {
          try {
            await credential.user!.delete();
          } catch (deleteError) {
            KDebugPrint.warning(
              'Unable to rollback auth user after Firestore failure: $deleteError',
            );
          }
        }
        rethrow;
      }

      try {
        await credential.user?.sendEmailVerification();
      } catch (verificationError) {
        KDebugPrint.warning(
          'Failed to send email verification: $verificationError',
        );
      }

      _showSnackBar(
        context,
        'Registration submitted successfully. We\'ll review and confirm shortly.',
        backgroundColor: Colors.green,
      );

      KDebugPrint.success('Lab registration submitted successfully');

      clearForm();

      context.go(RouteNames.verificationPending);
    } on FirebaseAuthException catch (authError) {
      final message = _mapAuthErrorToMessage(authError);
      _showSnackBar(context, message);
      KDebugPrint.error('Firebase auth error: ${authError.code}');
    } on FirebaseException catch (firebaseError) {
      _showSnackBar(
        context,
        'We couldn\'t save your registration right now. Please try again.',
      );
      KDebugPrint.error(
        'Firebase error (${firebaseError.plugin}): ${firebaseError.message}',
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Something went wrong. Please try again.',
      );
      KDebugPrint.error('Unexpected error during registration: $e');
    } finally {
      isSubmitting = false;
    }
  }

  // Utility methods
  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Identity';
      case 2:
        return 'Business';
      case 3:
        return 'Clinical';
      default:
        return '';
    }
  }

  // Clear form
  void clearForm() {
    labNameController.clear();
    ownerNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    labAddressController.clear();
    cityStatePincodeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    gstNumberController.clear();
    panNumberController.clear();
    licenseNumberController.clear();
    issuedByController.clear();

    _currentStep = 0;
    _selectedIdentityProof = null;
    _selectedBusinessType = null;
    _isGstRegistered = null;
    _licenseExpiryDate = null;
    _businessRegistrationFile = null;
    _gstCertificateFile = null;
    _clinicalLicenseFile = null;
    _identityProofFile = null;
    _isSubmitting = false;

    notifyListeners();
  }

  @override
  void dispose() {
    labNameController.dispose();
    ownerNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    labAddressController.dispose();
    cityStatePincodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    licenseNumberController.dispose();
    issuedByController.dispose();
    pageController.dispose();
    super.dispose();
  }

  bool _validateAllSteps() {
    return _validateBasicInformation() &&
        _validateIdentityProof() &&
        _validateBusinessInformation() &&
        _validateClinicalInformation();
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  List<LabDocument> _buildDocuments() {
    return [
      if (identityProofFile != null)
        LabDocument(
          type: LabDocumentTypes.identityProof,
          label: selectedIdentityProof ?? 'Identity Proof',
          originalFileName: _extractFileName(identityProofFile!),
        ),
      if (businessRegistrationFile != null)
        LabDocument(
          type: LabDocumentTypes.businessRegistration,
          label: 'Business Registration Certificate',
          originalFileName: _extractFileName(businessRegistrationFile!),
        ),
      if (gstCertificateFile != null)
        LabDocument(
          type: LabDocumentTypes.gstCertificate,
          label: 'GST Certificate',
          originalFileName: _extractFileName(gstCertificateFile!),
        ),
      if (clinicalLicenseFile != null)
        LabDocument(
          type: LabDocumentTypes.clinicalLicense,
          label: 'Clinical Establishment License',
          originalFileName: _extractFileName(clinicalLicenseFile!),
        ),
    ];
  }

  String _extractFileName(File file) {
    final segments = file.path.split(Platform.pathSeparator);
    return segments.isNotEmpty ? segments.last : file.path;
  }

  String _mapAuthErrorToMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in instead.';
      case 'invalid-email':
        return 'The email address looks invalid. Please correct it.';
      case 'weak-password':
        return 'Please choose a stronger password (at least 6 characters).';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this project.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return 'We couldn\'t create your account. Please try again.';
    }
  }
}
