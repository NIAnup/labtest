import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:labtest/provider/settings_provider.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/utils/custom_snackbar.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:provider/provider.dart';

// Top bar with user info, date, etc.

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppTheme, TestRequestProvider, SettingsProvider>(
      builder: (context, theme, requestProvider, settings, child) {
        final pendingNotifications = requestProvider.testRequests
            .where((request) => request.status.toLowerCase() != 'completed')
            .length;
        final bool showBadge = pendingNotifications > 0;
        final String badgeText = pendingNotifications > 99
            ? '99+'
            : pendingNotifications > 9
                ? '9+'
                : pendingNotifications.toString();

        return Container(
          color: theme.colors.surface,
          padding: EdgeInsets.symmetric(
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      '${getGreeting()}, ${settings.ownerName}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        fontFamily: "uber",
                        fontWeight: FontWeight.bold,
                        color: theme.colors.textPrimary,
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 4,
                      tablet: 6,
                      desktop: 8,
                    )),
                    ResponsiveText(
                      'Welcome back to your dashboard',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        fontFamily: "uber",
                        color: theme.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveText(
                'Today: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  fontFamily: "uber",
                  color: theme.colors.textSecondary,
                ),
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              )),
              GestureDetector(
                onTap: () => context.push(RouteNames.notifications),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: theme.colors.textPrimary,
                      size: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 20,
                        tablet: 22,
                        desktop: 24,
                      ),
                    ),
                    if (showBadge)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: theme.colors.onError,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 10,
                                  tablet: 10,
                                  desktop: 11,
                                ),
                                fontFamily: 'uber',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                  width: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              )),
              GestureDetector(
                onTap: () => _showProfileDetails(context, theme, settings),
                child: CircleAvatar(
                  radius: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                  backgroundColor: theme.colors.primary,
                  child: Icon(
                    Icons.person,
                    color: theme.colors.onPrimary,
                    size: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileDetails(
    BuildContext context,
    AppTheme theme,
    SettingsProvider settings,
  ) {
    final parentContext = context;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
          ),
          title: ResponsiveText(
            'Lab Profile',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
              fontWeight: FontWeight.bold,
              fontFamily: 'uber',
              color: theme.colors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Owner',
                  value: settings.ownerName,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Lab Name',
                  value: settings.labName,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Contact Email',
                  value: settings.contactEmail,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Contact Phone',
                  value: settings.contactPhone,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Address',
                  value: settings.labAddress,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'City / State / Pincode',
                  value: settings.cityStatePincode,
                ),
                _buildProfileDetailRow(
                  context,
                  theme,
                  label: 'Operating Hours',
                  value: settings.operatingHours,
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.only(
            right: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
            bottom: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleEditProfile(parentContext, settings, theme);
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Details'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleEditProfile(
    BuildContext context,
    SettingsProvider settings,
    AppTheme theme,
  ) async {
    final updatedValues =
        await _showEditProfileDialog(context, theme, settings);

    if (updatedValues == null) {
      return;
    }

    CustomSnackBar.info(
      context,
      'Your new details are in review. Please confirm to apply changes.',
    );

    final confirmed = await _showReviewDialog(context, theme, updatedValues);

    if (!confirmed) {
      CustomSnackBar.warning(context, 'Profile update cancelled.');
      return;
    }

    settings.updateOwnerName(updatedValues['ownerName']!);
    settings.updateLabName(updatedValues['labName']!);
    settings.updateContactEmail(updatedValues['contactEmail']!);
    settings.updateContactPhone(updatedValues['contactPhone']!);
    settings.updateLabAddress(updatedValues['labAddress']!);
    settings.updateCityStatePincode(updatedValues['cityStatePincode']!);
    settings.updateOperatingHours(updatedValues['operatingHours']!);

    CustomSnackBar.success(
      context,
      'Profile details updated successfully.',
    );
  }

  Widget _buildProfileDetailRow(
    BuildContext context,
    AppTheme theme, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 6,
          tablet: 8,
          desktop: 10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
              fontWeight: FontWeight.w600,
              fontFamily: 'uber',
              color: theme.colors.textSecondary,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 4,
              tablet: 6,
              desktop: 8,
            ),
          ),
          ResponsiveText(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 13,
                tablet: 15,
                desktop: 16,
              ),
              fontWeight: FontWeight.w500,
              fontFamily: 'uber',
              color: theme.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _showEditProfileDialog(
    BuildContext context,
    AppTheme theme,
    SettingsProvider settings,
  ) async {
    final labNameController = TextEditingController(text: settings.labName);
    final ownerNameController = TextEditingController(text: settings.ownerName);
    final contactEmailController =
        TextEditingController(text: settings.contactEmail);
    final contactPhoneController =
        TextEditingController(text: settings.contactPhone);
    final labAddressController =
        TextEditingController(text: settings.labAddress);
    final cityStatePincodeController =
        TextEditingController(text: settings.cityStatePincode);
    final operatingHoursController =
        TextEditingController(text: settings.operatingHours);
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: theme.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
            ),
            title: ResponsiveText(
              'Edit Profile Details',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
                fontWeight: FontWeight.bold,
                fontFamily: 'uber',
                color: theme.colors.textPrimary,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ProfileTextField(
                      controller: ownerNameController,
                      label: 'Owner Name',
                      keyboardType: TextInputType.name,
                    ),
                    _ProfileTextField(
                      controller: labNameController,
                      label: 'Lab Name',
                      keyboardType: TextInputType.name,
                    ),
                    _ProfileTextField(
                      controller: contactEmailController,
                      label: 'Contact Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _ProfileTextField(
                      controller: contactPhoneController,
                      label: 'Contact Phone',
                      keyboardType: TextInputType.phone,
                    ),
                    _ProfileTextField(
                      controller: labAddressController,
                      label: 'Address',
                      keyboardType: TextInputType.streetAddress,
                    ),
                    _ProfileTextField(
                      controller: cityStatePincodeController,
                      label: 'City / State / Pincode',
                      keyboardType: TextInputType.text,
                    ),
                    _ProfileTextField(
                      controller: operatingHoursController,
                      label: 'Operating Hours',
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: EdgeInsets.only(
              right: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
              bottom: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.of(dialogContext).pop({
                      'ownerName': ownerNameController.text.trim(),
                      'labName': labNameController.text.trim(),
                      'contactEmail': contactEmailController.text.trim(),
                      'contactPhone': contactPhoneController.text.trim(),
                      'labAddress': labAddressController.text.trim(),
                      'cityStatePincode':
                          cityStatePincodeController.text.trim(),
                      'operatingHours': operatingHoursController.text.trim(),
                    });
                  }
                },
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Review Details'),
              ),
            ],
          );
        },
      );

      return result;
    } finally {
      labNameController.dispose();
      ownerNameController.dispose();
      contactEmailController.dispose();
      contactPhoneController.dispose();
      labAddressController.dispose();
      cityStatePincodeController.dispose();
      operatingHoursController.dispose();
    }
  }

  Future<bool> _showReviewDialog(
    BuildContext context,
    AppTheme theme,
    Map<String, String> updatedValues,
  ) async {
    const labelMap = {
      'ownerName': 'Owner',
      'labName': 'Lab Name',
      'contactEmail': 'Contact Email',
      'contactPhone': 'Contact Phone',
      'labAddress': 'Address',
      'cityStatePincode': 'City / State / Pincode',
      'operatingHours': 'Operating Hours',
    };

    final fieldOrder = labelMap.keys.toList();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
          ),
          title: ResponsiveText(
            'Review Profile Changes',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
              fontWeight: FontWeight.bold,
              fontFamily: 'uber',
              color: theme.colors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: fieldOrder
                  .map(
                    (key) => _buildProfileDetailRow(
                      context,
                      theme,
                      label: labelMap[key] ?? key,
                      value: updatedValues[key] ?? '',
                    ),
                  )
                  .toList(),
            ),
          ),
          actionsPadding: EdgeInsets.only(
            right: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
            bottom: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Make Changes'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirm & Save'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 18,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: theme.colors.textSecondary,
            fontFamily: 'uber',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
