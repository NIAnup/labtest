import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:labtest/provider/settings_provider.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/widget/link_share_dialog.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _testsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  late String _selectedUrgency;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = context.read<SettingsProvider>();
      setState(() {
        _selectedUrgency = settings.defaultUrgency;
        _addressLine1Controller.text = settings.labAddress;
        _addressLine2Controller.text = settings.cityStatePincode;
      });
    });
    _selectedUrgency = 'Normal';
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _testsController.dispose();
    _notesController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<TestRequestProvider>();

    final tests = _normalizeTests(_testsController.text);
    final lat = _latitudeController.text.trim().isNotEmpty
        ? double.tryParse(_latitudeController.text.trim())
        : null;
    final lng = _longitudeController.text.trim().isNotEmpty
        ? double.tryParse(_longitudeController.text.trim())
        : null;

    final formLink = await provider.createTestRequest(
      patientName: _patientNameController.text.trim(),
      location: _addressLine1Controller.text.trim(),
      bloodTestType: tests.join(', '),
      requestedTests: tests,
      urgency: _selectedUrgency,
      phoneNumber: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      email:
          _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      addressLine2: _addressLine2Controller.text.trim().isNotEmpty
          ? _addressLine2Controller.text.trim()
          : null,
      city: _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : null,
      state: _stateController.text.trim().isNotEmpty
          ? _stateController.text.trim()
          : null,
      postalCode: _postalCodeController.text.trim().isNotEmpty
          ? _postalCodeController.text.trim()
          : null,
      latitude: lat,
      longitude: lng,
      additionalNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      context: context,
    );

    if (!mounted || formLink == null) return;

    final displayTests = tests.isNotEmpty ? tests.join(', ') : 'Custom Panel';

    await showDialog(
      context: context,
      builder: (dialogContext) => LinkShareDialog(
        formLink: formLink,
        patientName: _patientNameController.text.trim().isEmpty
            ? 'Client'
            : _patientNameController.text.trim(),
        testType: displayTests,
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  List<String> _normalizeTests(String raw) {
    final set = <String>{};
    for (final value in raw.split(',')) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        set.add(trimmed);
      }
    }
    return set.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppTheme, SettingsProvider, TestRequestProvider>(
      builder: (context, theme, settings, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: ResponsiveText(
              'Create Lab Request',
              style: TextStyle(
                fontFamily: 'uber',
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
                color: theme.colors.textPrimary,
              ),
            ),
            backgroundColor: theme.colors.surface,
            foregroundColor: theme.colors.textPrimary,
            elevation: 0,
          ),
          backgroundColor: theme.colors.background,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: const EdgeInsets.all(16),
                  tablet: const EdgeInsets.all(24),
                  desktop: const EdgeInsets.symmetric(horizontal: 120, vertical: 32),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLabDetailsCard(theme, settings),
                      const SizedBox(height: 24),
                      _buildClientSection(theme),
                      const SizedBox(height: 24),
                      _buildRequestSection(theme, settings),
                      const SizedBox(height: 32),
                      Custombutton(
                        text: 'Create Request',
                        onTap: provider.isLoading ? null : _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading)
                Container(
                  color: theme.colors.background.withOpacity(0.4),
                  child: Center(
                    child: CircularProgressIndicator(color: theme.colors.primary),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabDetailsCard(AppTheme theme, SettingsProvider settings) {
    final colors = theme.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lab Details',
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _labDetailRow(colors, 'Lab Name', settings.labName),
          _labDetailRow(colors, 'Contact Email', settings.contactEmail),
          _labDetailRow(colors, 'Contact Phone', settings.contactPhone),
          _labDetailRow(colors, 'Address', settings.labAddress),
          _labDetailRow(colors, 'City/State/Pin', settings.cityStatePincode),
        ],
      ),
    );
  }

  Widget _labDetailRow(AppColors colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'uber',
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection(AppTheme theme) {
    final colors = theme.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Client Details',
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Customtextfield(
            controller: _patientNameController,
            labelText: 'Patient Name',
            hintText: 'Enter patient name',
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: '+1 555 012 3456',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'client@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _addressLine1Controller,
            labelText: 'Address Line 1',
            hintText: 'Street, Building',
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return 'Provide an address or pickup location';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _addressLine2Controller,
            labelText: 'Address Line 2',
            hintText: 'Apartment, Landmark (optional)',
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _cityController,
            labelText: 'City',
            hintText: 'City',
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _stateController,
            labelText: 'State',
            hintText: 'State/Province',
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _postalCodeController,
            labelText: 'Postal Code',
            hintText: 'ZIP Code',
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSection(AppTheme theme, SettingsProvider settings) {
    final colors = theme.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Details',
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedUrgency,
            decoration: InputDecoration(
              labelText: 'Urgency',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: colors.border, width: 1.5),
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
          const SizedBox(height: 12),
          Customtextfield(
            controller: _testsController,
            labelText: 'Requested Tests',
            hintText: 'E.g. CBC, Lipid Panel (comma separated)',
            maxLines: 2,
            validator: (value) {
              if (_normalizeTests(value ?? '').isEmpty) {
                return 'Add at least one test name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Customtextfield(
            controller: _notesController,
            labelText: 'Additional Notes',
            hintText: 'Collector instructions, access notes, etc.',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Geo Location (Optional)',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Customtextfield(
                  controller: _latitudeController,
                  labelText: 'Latitude',
                  hintText: '12.9716',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Customtextfield(
                  controller: _longitudeController,
                  labelText: 'Longitude',
                  hintText: '77.5946',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
