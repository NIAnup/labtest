import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/utils/k_debug_print.dart';
import 'package:go_router/go_router.dart';

class LabRegistrationProvider extends ChangeNotifier {
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
        // Store the file path or upload to server
        notifyListeners();
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
  void submitRegistration(BuildContext context) {
    if (validateCurrentStep()) {
      // Here you would typically:
      // 1. Validate all documents
      // 2. Upload files to server
      // 3. Save lab data to database
      // 4. Set status to 'under_review'
      // 5. Navigate to verification pending screen

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      KDebugPrint.success('Lab registration submitted successfully');
      // Navigate to verification pending screen
      context.go(RouteNames.verificationPending);
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
}
