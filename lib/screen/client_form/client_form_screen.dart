import 'package:flutter/material.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/provider/settings_provider.dart';
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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController testsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  String _selectedUrgency = 'Normal';

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

    final request =
        await testRequestProvider.getRequestByFormLinkId(widget.formLinkId);

    if (!mounted) return;
    if (request != null) {
      _populateFromRequest(request);
    }
  }

  void _populateFromRequest(TestRequest request) {
    final submission = request.clientSubmission ?? <String, dynamic>{};

    patientNameController.text =
        (submission['patientName'] ?? request.patientName ?? '').toString();
    locationController.text =
        (submission['addressLine1'] ?? request.location ?? '').toString();
    addressLine2Controller.text =
        (submission['addressLine2'] ?? '').toString();
    phoneController.text = (submission['phoneNumber'] ?? '').toString();
    emailController.text = (submission['email'] ?? '').toString();
    cityController.text = (submission['city'] ?? '').toString();
    stateController.text = (submission['state'] ?? '').toString();
    postalCodeController.text = (submission['postalCode'] ?? '').toString();
    notesController.text = (submission['additionalNotes'] ?? '').toString();

    final requestedTests = submission['requestedTests'];
    if (requestedTests is List) {
      testsController.text =
          requestedTests.map((e) => e.toString()).join(', ');
    } else if ((submission['bloodTestType'] ?? '').toString().isNotEmpty) {
      testsController.text = submission['bloodTestType'].toString();
    } else if (request.bloodTestType.isNotEmpty) {
      testsController.text = request.bloodTestType;
    }

    final lat = submission['latitude'];
    if (lat is num) {
      latitudeController.text = lat.toString();
    }

    final lng = submission['longitude'];
    if (lng is num) {
      longitudeController.text = lng.toString();
    }

    if (locationController.text.isEmpty) {
      locationController.text = request.location;
    }

    setState(() {
      _selectedUrgency = request.urgency.isNotEmpty
          ? request.urgency
          : _selectedUrgency;
    });
  }

  List<String> _normalizeTests(String raw) {
    final set = <String>{};
    for (final part in raw.split(',')) {
      final value = part.trim();
      if (value.isNotEmpty) {
        set.add(value);
      }
    }
    return set.toList();
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
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    testsController.dispose();
    notesController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
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

    final tests = _normalizeTests(testsController.text);
    final lat = latitudeController.text.trim().isNotEmpty
        ? double.tryParse(latitudeController.text.trim())
        : null;
    final lng = longitudeController.text.trim().isNotEmpty
        ? double.tryParse(longitudeController.text.trim())
        : null;

    final success = await testRequestProvider.submitClientForm(
      formLinkId: widget.formLinkId,
      patientName: patientNameController.text.trim(),
      location: locationController.text.trim(),
      bloodTestType: tests.join(', '),
      requestedTests: tests,
      urgency: _selectedUrgency,
      phoneNumber: phoneController.text.trim().isNotEmpty
          ? phoneController.text.trim()
          : null,
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : null,
      addressLine2: addressLine2Controller.text.trim().isNotEmpty
          ? addressLine2Controller.text.trim()
          : null,
      city: cityController.text.trim().isNotEmpty
          ? cityController.text.trim()
          : null,
      state: stateController.text.trim().isNotEmpty
          ? stateController.text.trim()
          : null,
      postalCode: postalCodeController.text.trim().isNotEmpty
          ? postalCodeController.text.trim()
          : null,
      latitude: lat,
      longitude: lng,
      additionalNotes: notesController.text.trim().isNotEmpty
          ? notesController.text.trim()
          : null,
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
    final settings = Provider.of<SettingsProvider>(context, listen: false);

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
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: phoneController,
                      hintText: '+1 555 012 3456',
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: emailController,
                      hintText: 'client@email.com',
                      labelText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: locationController,
                      hintText: 'Street, Building, Apartment',
                      labelText: 'Address Line 1',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please share where the collector should arrive';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: addressLine2Controller,
                      hintText: 'Landmark or Neighborhood (optional)',
                      labelText: 'Address Line 2',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Customtextfield(
                            controller: cityController,
                            hintText: 'City',
                            labelText: 'City',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Customtextfield(
                            controller: stateController,
                            hintText: 'State/Province',
                            labelText: 'State/Province',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: postalCodeController,
                      hintText: 'ZIP/Postal Code',
                      labelText: 'Postal Code',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedUrgency,
                      decoration: InputDecoration(
                        labelText: 'Urgency',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.border,
                            width: 1.5,
                          ),
                        ),
                      ),
                      items: settings.urgencyOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option,
                              child: Text(option, style: const TextStyle(fontFamily: 'uber')),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedUrgency = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      controller: testsController,
                      hintText: 'CBC, Lipid Panel, HbA1c',
                      labelText: 'Requested Tests',
                      maxLines: 2,
                      validator: (value) {
                        if (_normalizeTests(value ?? '').isEmpty) {
                          return 'List at least one test or panel name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Customtextfield(
                      controller: notesController,
                      hintText: 'Special instructions for the collector (optional)',
                      labelText: 'Additional Notes',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Share your geo-location (optional) so nearby collectors can find you faster.',
                      style: TextStyle(
                        fontFamily: 'uber',
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Customtextfield(
                            controller: latitudeController,
                            hintText: 'Latitude',
                            labelText: 'Latitude',
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Customtextfield(
                            controller: longitudeController,
                            hintText: 'Longitude',
                            labelText: 'Longitude',
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Custombutton(
                      onTap: testRequestProvider.isLoading ? null : _submitForm,
                      text: 'Submit Request',
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
