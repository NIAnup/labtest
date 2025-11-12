import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/provider/lab_registration_provider.dart';
import 'package:provider/provider.dart';

class LabRegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LabRegistrationProvider(),
      child: Consumer2<AppTheme, LabRegistrationProvider>(
        builder: (context, theme, provider, child) {
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
                      _buildHeader(context, theme, provider),

                      // Progress indicator
                      _buildProgressIndicator(context, theme, provider),

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
                            controller: provider.pageController,
                            onPageChanged: (index) {
                              provider.currentStep = index;
                            },
                            children: [
                              _buildBasicInformationStep(
                                  context, theme, provider),
                              _buildIdentityProofStep(context, theme, provider),
                              _buildBusinessInformationStep(
                                  context, theme, provider),
                              _buildClinicalInformationStep(
                                  context, theme, provider),
                            ],
                          ),
                        ),
                      ),

                      // Navigation buttons
                      _buildNavigationButtons(context, theme, provider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
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
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.login);
              }
            },
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

  Widget _buildProgressIndicator(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
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
            children: List.generate(provider.totalSteps, (index) {
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
                        color: index <= provider.currentStep
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
                            color: index <= provider.currentStep
                                ? theme.colors.onPrimary
                                : theme.colors.textSecondary,
                            fontFamily: 'uber',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ResponsiveText(
                      provider.getStepTitle(index),
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
              widthFactor: (provider.currentStep + 1) / provider.totalSteps,
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

  Widget _buildBasicInformationStep(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
        context,
        mobile: 16,
        tablet: 24,
        desktop: 32,
      )),
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
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Customtextfield(
                            controller: provider.labNameController,
                            hintText: 'Lab Name',
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter lab name' : null,
                          ),
                          SizedBox(height: 16),
                          Customtextfield(
                            controller: provider.ownerNameController,
                            hintText: 'Owner / Authorized Person Name',
                            validator: (value) => value!.isEmpty
                                ? 'Please enter owner name'
                                : null,
                          ),
                          SizedBox(height: 16),
                          Customtextfield(
                            controller: provider.contactNumberController,
                            hintText: 'Contact Number',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter contact number';
                              if (!provider.phonePattern.hasMatch(value))
                                return 'Please enter valid phone number';
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          Customtextfield(
                            controller: provider.emailController,
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
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Customtextfield(
                            controller: provider.labAddressController,
                            hintText: 'Lab Address',
                            maxLines: 3,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter lab address'
                                : null,
                          ),
                          SizedBox(height: 16),
                          Customtextfield(
                            controller: provider.cityStatePincodeController,
                            hintText: 'City / State / Pincode',
                            validator: (value) => value!.isEmpty
                                ? 'Please enter city/state/pincode'
                                : null,
                          ),
                          SizedBox(height: 16),
                          Customtextfield(
                            controller: provider.passwordController,
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
                            controller: provider.confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please confirm password';
                              if (value != provider.passwordController.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile layout - single column
                return Column(
                  children: [
                    Customtextfield(
                      controller: provider.labNameController,
                      hintText: 'Lab Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter lab name' : null,
                    ),
                    SizedBox(height: 16),
                    Customtextfield(
                      controller: provider.ownerNameController,
                      hintText: 'Owner / Authorized Person Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter owner name' : null,
                    ),
                    SizedBox(height: 16),
                    Customtextfield(
                      controller: provider.contactNumberController,
                      hintText: 'Contact Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter contact number';
                        if (!provider.phonePattern.hasMatch(value))
                          return 'Please enter valid phone number';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Customtextfield(
                      controller: provider.emailController,
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
                      controller: provider.labAddressController,
                      hintText: 'Lab Address',
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter lab address' : null,
                    ),
                    SizedBox(height: 16),
                    Customtextfield(
                      controller: provider.cityStatePincodeController,
                      hintText: 'City / State / Pincode',
                      validator: (value) => value!.isEmpty
                          ? 'Please enter city/state/pincode'
                          : null,
                    ),
                    SizedBox(height: 16),
                    Customtextfield(
                      controller: provider.passwordController,
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
                      controller: provider.confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please confirm password';
                        if (value != provider.passwordController.text)
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
    );
  }

  Widget _buildIdentityProofStep(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
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
            value: provider.selectedIdentityProof,
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
              provider.selectedIdentityProof = newValue;
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
            onTap: () => provider.pickIdentityDocument(),
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

  Widget _buildBusinessInformationStep(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
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
            value: provider.selectedBusinessType,
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
              provider.selectedBusinessType = newValue;
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
            onTap: () => provider.pickBusinessRegistrationFile(),
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
                  provider.businessRegistrationFile != null
                      ? 'File selected: ${provider.businessRegistrationFile!.path.split('/').last}'
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
                  groupValue: provider.isGstRegistered,
                  onChanged: (String? value) {
                    provider.isGstRegistered = value;
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
                  groupValue: provider.isGstRegistered,
                  onChanged: (String? value) {
                    provider.isGstRegistered = value;
                  },
                  activeColor: theme.colors.primary,
                ),
              ),
            ],
          ),

          if (provider.isGstRegistered == 'Yes') ...[
            SizedBox(height: 20),
            Customtextfield(
              controller: provider.gstNumberController,
              hintText: 'GST Number (15-digit GSTIN)',
              validator: (value) {
                if (provider.isGstRegistered == 'Yes') {
                  if (value!.isEmpty) return 'Please enter GST number';
                  if (!provider.gstPattern.hasMatch(value))
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
              onTap: () => provider.pickGstCertificateFile(),
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
                    provider.gstCertificateFile != null
                        ? 'File selected: ${provider.gstCertificateFile!.path.split('/').last}'
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

  Widget _buildClinicalInformationStep(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
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
            controller: provider.licenseNumberController,
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
            onTap: () => provider.pickClinicalLicenseFile(),
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
                  provider.clinicalLicenseFile != null
                      ? 'File selected: ${provider.clinicalLicenseFile!.path.split('/').last}'
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
            onTap: () => provider.selectLicenseExpiryDate(context),
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
                    provider.licenseExpiryDate != null
                        ? '${provider.licenseExpiryDate!.day}/${provider.licenseExpiryDate!.month}/${provider.licenseExpiryDate!.year}'
                        : 'Select expiry date',
                    style: TextStyle(
                      color: provider.licenseExpiryDate != null
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
            controller: provider.issuedByController,
            hintText: 'Issued By (Authority)',
            validator: (value) =>
                value!.isEmpty ? 'Please enter issuing authority' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
      BuildContext context, AppTheme theme, LabRegistrationProvider provider) {
    final isFinalStep = provider.currentStep == provider.totalSteps - 1;
    final primaryButtonText = provider.isSubmitting
        ? 'Submitting...'
        : isFinalStep
            ? 'Submit Registration'
            : 'Next';

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          if (provider.currentStep > 0)
            Expanded(
              child: Custombutton(
                text: 'Previous',
                onTap: provider.isSubmitting
                    ? null
                    : () => provider.previousStep(),
              ),
            ),
          if (provider.currentStep > 0) SizedBox(width: 16),
          Expanded(
            child: Custombutton(
              text: primaryButtonText,
              onTap: provider.isSubmitting
                  ? null
                  : isFinalStep
                      ? () => provider.submitRegistration(context)
                      : () {
                          if (provider.validateCurrentStep()) {
                            provider.nextStep();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please complete all required fields',
                                ),
                              ),
                            );
                          }
                        },
            ),
          ),
        ],
      ),
    );
  }
}
