import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LabRegistrationForm extends StatefulWidget {
  @override
  _LabRegistrationFormState createState() => _LabRegistrationFormState();
}

class _LabRegistrationFormState extends State<LabRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Controllers for basic information
  final TextEditingController _labNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _labAddressController = TextEditingController();
  final TextEditingController _cityStatePincodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controllers for business information
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();

  // Controllers for clinical information
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _issuedByController = TextEditingController();

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
  final RegExp _gstPattern =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
  final RegExp _phonePattern = RegExp(r'^[+]?[0-9]{10,15}$');

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Scaffold(
          backgroundColor: theme.colors.background,
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: double.infinity,
                    tablet: 800,
                    desktop: 1000,
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(theme),

                    // Progress indicator
                    _buildProgressIndicator(theme),

                    // Form content
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 16,
                            tablet: 24,
                            desktop: 32,
                          ),
                        ),
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentStep = index;
                            });
                          },
                          children: [
                            _buildBasicInformationStep(theme),
                            _buildIdentityProofStep(theme),
                            _buildBusinessInformationStep(theme),
                            _buildClinicalInformationStep(theme),
                          ],
                        ),
                      ),
                    ),

                    // Navigation buttons
                    _buildNavigationButtons(theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppTheme theme) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
        context,
        mobile: 16,
        tablet: 20,
        desktop: 24,
      )),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: theme.colors.textPrimary,
              size: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
          ),

          SizedBox(width: 16),

          // Title
          Expanded(
            child: ResponsiveText(
              'Lab Registration',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                color: theme.colors.textPrimary,
                fontFamily: 'uber',
              ),
            ),
          ),

          // Logo or branding
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
              vertical: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: theme.colors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ResponsiveText(
              'Blood Lab',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: FontWeight.bold,
                color: theme.colors.onPrimary,
                fontFamily: 'uber',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(AppTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
        vertical: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
      ),
      child: Column(
        children: [
          // Step labels
          Row(
            children: List.generate(_totalSteps, (index) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? theme.colors.primary
                            : theme.colors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ResponsiveText(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 18,
                            ),
                            fontWeight: FontWeight.bold,
                            color: index <= _currentStep
                                ? theme.colors.onPrimary
                                : theme.colors.textSecondary,
                            fontFamily: 'uber',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ResponsiveText(
                      _getStepTitle(index),
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 10,
                          tablet: 12,
                          desktop: 14,
                        ),
                        color: theme.colors.textSecondary,
                        fontFamily: 'uber',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(
              height: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          )),

          // Progress bar
          Container(
            height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 6,
              tablet: 8,
              desktop: 10,
            ),
            decoration: BoxDecoration(
              color: theme.colors.border,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentStep + 1) / _totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
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

  Widget _buildBasicInformationStep(AppTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
        context,
        mobile: 16,
        tablet: 24,
        desktop: 32,
      )),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveText(
              'Basic Information',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                color: theme.colors.textPrimary,
                fontFamily: 'uber',
              ),
            ),
            SizedBox(
                height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            )),

            // Responsive grid layout
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;

                if (isWideScreen) {
                  // Desktop/Tablet layout - 2 columns
                  return Column(
                    children: [
                      // First row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Customtextfield(
                                  controller: _labNameController,
                                  hintText: 'Lab Name',
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter lab name'
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _ownerNameController,
                                  hintText: 'Owner / Authorized Person Name',
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter owner name'
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _contactNumberController,
                                  hintText: 'Contact Number',
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please enter contact number';
                                    if (!_phonePattern.hasMatch(value))
                                      return 'Please enter valid phone number';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please enter email';
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Customtextfield(
                                  controller: _labAddressController,
                                  hintText: 'Lab Address',
                                  maxLines: 3,
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter lab address'
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _cityStatePincodeController,
                                  hintText: 'City / State / Pincode',
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter city/state/pincode'
                                      : null,
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please enter password';
                                    if (value.length < 8)
                                      return 'Password must be at least 8 characters';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Customtextfield(
                                  controller: _confirmPasswordController,
                                  hintText: 'Confirm Password',
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'Please confirm password';
                                    if (value != _passwordController.text)
                                      return 'Passwords do not match';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Mobile layout - single column
                  return Column(
                    children: [
                      Customtextfield(
                        controller: _labNameController,
                        hintText: 'Lab Name',
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter lab name' : null,
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _ownerNameController,
                        hintText: 'Owner / Authorized Person Name',
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter owner name' : null,
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _contactNumberController,
                        hintText: 'Contact Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter contact number';
                          if (!_phonePattern.hasMatch(value))
                            return 'Please enter valid phone number';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _labAddressController,
                        hintText: 'Lab Address',
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter lab address' : null,
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _cityStatePincodeController,
                        hintText: 'City / State / Pincode',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter city/state/pincode'
                            : null,
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter password';
                          if (value.length < 8)
                            return 'Password must be at least 8 characters';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please confirm password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityProofStep(AppTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Identity Proof',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 20),
          ResponsiveText(
            'Required Identity Proof',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedIdentityProof,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.primary,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.border,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: theme.colors.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
                vertical: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
            ),
            hint: ResponsiveText(
              'Select Identity Proof',
              style: TextStyle(
                color: theme.colors.textSecondary,
                fontFamily: 'uber',
              ),
            ),
            items: ['Aadhar Card', 'PAN Card', 'Voter ID'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: ResponsiveText(
                  value,
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontWeight: FontWeight.w500,
                    color: theme.colors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedIdentityProof = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please select identity proof' : null,
          ),
          SizedBox(height: 20),
          ResponsiveText(
            'Upload Identity Proof Document',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _pickIdentityDocument,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colors.border,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: theme.colors.surface,
              ),
              child: Center(
                child: ResponsiveText(
                  'Tap to upload document',
                  style: TextStyle(
                    color: theme.colors.textSecondary,
                    fontFamily: 'uber',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInformationStep(AppTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Business Information',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 20),

          // Business Registration Type
          ResponsiveText(
            'Business Registration Type',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _selectedBusinessType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.primary,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                borderSide: BorderSide(
                  color: theme.colors.border,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: theme.colors.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
                vertical: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
            ),
            hint: ResponsiveText(
              'Select Business Type',
              style: TextStyle(
                color: theme.colors.textSecondary,
                fontFamily: 'uber',
              ),
            ),
            items: [
              'Proprietorship',
              'LLP',
              'Pvt. Ltd.',
              'Partnership',
              'Public Ltd.'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: ResponsiveText(
                  value,
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontWeight: FontWeight.w500,
                    color: theme.colors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedBusinessType = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please select business type' : null,
          ),

          SizedBox(height: 20),

          // Business Registration Certificate Upload
          ResponsiveText(
            'Business Registration Certificate',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),

          GestureDetector(
            onTap: _pickBusinessRegistrationFile,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colors.border,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: theme.colors.surface,
              ),
              child: Center(
                child: ResponsiveText(
                  _businessRegistrationFile != null
                      ? 'File selected: ${_businessRegistrationFile!.path.split('/').last}'
                      : 'Tap to upload certificate',
                  style: TextStyle(
                    color: theme.colors.textSecondary,
                    fontFamily: 'uber',
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // GST Registration
          ResponsiveText(
            'GST Registered?',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: ResponsiveText(
                    'Yes',
                    style: TextStyle(
                      fontFamily: 'uber',
                      color: theme.colors.textPrimary,
                    ),
                  ),
                  value: 'Yes',
                  groupValue: _isGstRegistered,
                  onChanged: (String? value) {
                    setState(() {
                      _isGstRegistered = value;
                    });
                  },
                  activeColor: theme.colors.primary,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: ResponsiveText(
                    'No',
                    style: TextStyle(
                      fontFamily: 'uber',
                      color: theme.colors.textPrimary,
                    ),
                  ),
                  value: 'No',
                  groupValue: _isGstRegistered,
                  onChanged: (String? value) {
                    setState(() {
                      _isGstRegistered = value;
                    });
                  },
                  activeColor: theme.colors.primary,
                ),
              ),
            ],
          ),

          if (_isGstRegistered == 'Yes') ...[
            SizedBox(height: 20),
            Customtextfield(
              controller: _gstNumberController,
              hintText: 'GST Number (15-digit GSTIN)',
              validator: (value) {
                if (_isGstRegistered == 'Yes') {
                  if (value!.isEmpty) return 'Please enter GST number';
                  if (!_gstPattern.hasMatch(value))
                    return 'Please enter valid GST number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ResponsiveText(
              'Upload GST Certificate',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                fontWeight: FontWeight.w600,
                color: theme.colors.textPrimary,
                fontFamily: 'uber',
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _pickGstCertificateFile,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors.border,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colors.surface,
                ),
                child: Center(
                  child: ResponsiveText(
                    _gstCertificateFile != null
                        ? 'File selected: ${_gstCertificateFile!.path.split('/').last}'
                        : 'Tap to upload GST certificate',
                    style: TextStyle(
                      color: theme.colors.textSecondary,
                      fontFamily: 'uber',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicalInformationStep(AppTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            'Clinical Establishment Information',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 20),
          Customtextfield(
            controller: _licenseNumberController,
            hintText: 'Clinical Establishment License No.',
            validator: (value) =>
                value!.isEmpty ? 'Please enter license number' : null,
          ),
          SizedBox(height: 16),
          ResponsiveText(
            'Upload Clinical Establishment License',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _pickClinicalLicenseFile,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colors.border,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: theme.colors.surface,
              ),
              child: Center(
                child: ResponsiveText(
                  _clinicalLicenseFile != null
                      ? 'File selected: ${_clinicalLicenseFile!.path.split('/').last}'
                      : 'Tap to upload license',
                  style: TextStyle(
                    color: theme.colors.textSecondary,
                    fontFamily: 'uber',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ResponsiveText(
            'License Expiry Date',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w600,
              color: theme.colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _selectLicenseExpiryDate,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colors.border,
                  width: 1.5,
                ),
                borderRadius:
                    BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 6,
                  tablet: 8,
                  desktop: 10,
                )),
                color: theme.colors.surface,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
              child: Row(
                children: [
                  ResponsiveText(
                    _licenseExpiryDate != null
                        ? '${_licenseExpiryDate!.day}/${_licenseExpiryDate!.month}/${_licenseExpiryDate!.year}'
                        : 'Select expiry date',
                    style: TextStyle(
                      color: _licenseExpiryDate != null
                          ? theme.colors.textPrimary
                          : theme.colors.textSecondary,
                      fontFamily: 'uber',
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.calendar_today,
                    color: theme.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Customtextfield(
            controller: _issuedByController,
            hintText: 'Issued By (Authority)',
            validator: (value) =>
                value!.isEmpty ? 'Please enter issuing authority' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(AppTheme theme) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: Custombutton(
                text: 'Previous',
                onTap: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16),
          Expanded(
            child: Custombutton(
              text: _currentStep == _totalSteps - 1
                  ? 'Submit Registration'
                  : 'Next',
              onTap: _currentStep == _totalSteps - 1
                  ? _submitRegistration
                  : _nextStep,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState!.validate();
      case 1:
        if (_selectedIdentityProof == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select identity proof')),
          );
          return false;
        }
        return true;
      case 2:
        if (_selectedBusinessType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select business type')),
          );
          return false;
        }
        if (_isGstRegistered == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select GST registration status')),
          );
          return false;
        }
        return true;
      case 3:
        if (_licenseExpiryDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select license expiry date')),
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _submitRegistration() {
    if (_validateCurrentStep()) {
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

      // Navigate to verification pending screen
      Navigator.pushReplacementNamed(context, '/verification-pending');
    }
  }

  Future<void> _pickIdentityDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          // Store the file path or upload to server
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _pickBusinessRegistrationFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _businessRegistrationFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _pickGstCertificateFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _gstCertificateFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _pickClinicalLicenseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _clinicalLicenseFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _selectLicenseExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    );

    if (picked != null) {
      setState(() {
        _licenseExpiryDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _labNameController.dispose();
    _ownerNameController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _labAddressController.dispose();
    _cityStatePincodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gstNumberController.dispose();
    _panNumberController.dispose();
    _licenseNumberController.dispose();
    _issuedByController.dispose();
    super.dispose();
  }
}
