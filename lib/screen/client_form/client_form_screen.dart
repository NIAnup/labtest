import 'package:flutter/material.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';

/// Screen for clients to fill and submit the test request form
class ClientFormScreen extends StatefulWidget {
  final String formLinkId;

  const ClientFormScreen({Key? key, required this.formLinkId})
      : super(key: key);

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bloodTestTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    final testRequestProvider = Provider.of<TestRequestProvider>(
      context,
      listen: false,
    );

    // Get the request by form link ID - this will update the provider state
    await testRequestProvider.getRequestByFormLinkId(widget.formLinkId);
  }

  @override
  void dispose() {
    // Clear form state when leaving the screen
    final testRequestProvider = Provider.of<TestRequestProvider>(
      context,
      listen: false,
    );
    testRequestProvider.clearFormState();

    patientNameController.dispose();
    locationController.dispose();
    bloodTestTypeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final testRequestProvider = Provider.of<TestRequestProvider>(
      context,
      listen: false,
    );

    final success = await testRequestProvider.submitClientForm(
      formLinkId: widget.formLinkId,
      patientName: patientNameController.text,
      location: locationController.text,
      bloodTestType: bloodTestTypeController.text,
      urgency: testRequestProvider.formUrgency,
      context: context,
    );

    if (success && mounted) {
      // Navigate back after successful submission
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestRequestProvider>(
      builder: (context, testRequestProvider, child) {
        return Consumer<AppTheme>(
          builder: (context, theme, child) {
            return Scaffold(
              appBar: AppBar(
                title: ResponsiveText(
                  'Lab Test Request Form',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                    fontWeight: FontWeight.bold,
                    color: theme.colors.textPrimary,
                    fontFamily: 'uber',
                  ),
                ),
                backgroundColor: theme.colors.surface,
                foregroundColor: theme.colors.textPrimary,
                elevation: 0,
              ),
              backgroundColor: theme.colors.background,
              body: _buildBody(theme, testRequestProvider),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(AppTheme theme, TestRequestProvider testRequestProvider) {
    final currentRequest = testRequestProvider.currentFormRequest;

    // Show loading while fetching form
    if (testRequestProvider.isLoading && currentRequest == null) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colors.primary,
        ),
      );
    }

    // Show error view if form doesn't exist
    if (currentRequest == null) {
      return _buildInvalidFormView(theme);
    }

    // Show expired view ONLY if form exists and is expired (after 1 hour)
    if (currentRequest.isExpired) {
      return _buildExpiredView(theme);
    }

    // Show already submitted view
    if (testRequestProvider.isFormAlreadySubmitted) {
      return _buildAlreadySubmittedView(theme);
    }

    // Show form view (with expiration warning if needed)
    // This shows the EMPTY form fields where client can add details
    return _buildFormView(theme, testRequestProvider);
  }

  Widget _buildInvalidFormView(AppTheme theme) {
    final colors = theme.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.close_circle,
                size: 64, color: colors.textSecondary),
          ),
          const SizedBox(height: 24),
          Text(
            'Form Not Found',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This form link is invalid.\nPlease check the link and try again.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              color: colors.textSecondary,
              fontFamily: 'uber',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredView(AppTheme theme) {
    final colors = theme.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.timer, size: 64, color: colors.error),
          ),
          const SizedBox(height: 24),
          Text(
            'Form Expired',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This form link has expired.\nPlease request a new form link from your lab.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              color: colors.textSecondary,
              fontFamily: 'uber',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadySubmittedView(AppTheme theme) {
    final colors = theme.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 64, color: colors.success),
          ),
          const SizedBox(height: 24),
          Text(
            'Form Already Submitted',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'uber',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This form has already been submitted.',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              color: colors.textSecondary,
              fontFamily: 'uber',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(
    AppTheme theme,
    TestRequestProvider testRequestProvider,
  ) {
    final colors = theme.colors;

    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.all(16.0),
        tablet: const EdgeInsets.all(24.0),
        desktop: const EdgeInsets.all(32.0),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: double.infinity,
              tablet: 600,
              desktop: 700,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withOpacity(0.1),
                      colors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.document_text,
                      size: 48,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lab Test Request Form',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 24,
                          tablet: 26,
                          desktop: 28,
                        ),
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: 'uber',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please fill in the details below to submit your request',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 14,
                          tablet: 15,
                          desktop: 16,
                        ),
                        color: colors.textSecondary,
                        fontFamily: 'uber',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Expiration warning (if form is expiring soon)
              if (testRequestProvider.currentFormRequest?.isExpiringSoon ??
                  false)
                _buildExpirationWarning(
                    theme, testRequestProvider.currentFormRequest!),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Customtextfield(
                      controller: patientNameController,
                      hintText: 'Patient Name',
                      labelText: 'Patient Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    Customtextfield(
                      controller: locationController,
                      hintText: 'Location',
                      labelText: 'Location',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    Customtextfield(
                      controller: bloodTestTypeController,
                      hintText: 'Blood Test Type',
                      labelText: 'Blood Test Type',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter blood test type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Urgency',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 6,
                              tablet: 8,
                              desktop: 10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: colors.border,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 6,
                              tablet: 8,
                              desktop: 10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 6,
                              tablet: 8,
                              desktop: 10,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: colors.border,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colors.surface,
                      ),
                      value: testRequestProvider.formUrgency,
                      items: ['Normal', 'Urgent'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'uber',
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          testRequestProvider.setFormUrgency(newValue);
                        }
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),
                    Custombutton(
                      onTap: testRequestProvider.isLoading ? null : _submitForm,
                      text: testRequestProvider.isLoading
                          ? 'Submitting...'
                          : 'Submit Request',
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpirationWarning(AppTheme theme, TestRequest request) {
    final colors = theme.colors;
    final timeRemaining = request.timeUntilExpiry;

    if (timeRemaining == null) return const SizedBox.shrink();

    final minutes = timeRemaining.inMinutes;
    final seconds = timeRemaining.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.warning.withOpacity(0.1),
        border: Border.all(
          color: colors.warning.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.info_circle,
            color: colors.warning,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Expiring Soon',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.bold,
                    color: colors.warning,
                    fontFamily: 'uber',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please submit within ${minutes}m ${seconds}s',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    color: colors.textSecondary,
                    fontFamily: 'uber',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
