import 'package:flutter/material.dart';
import 'package:labtest/provider/settings_provider.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, SettingsProvider>(
      builder: (context, theme, settings, child) {
        final colors = theme.colors;

        return ResponsiveContainer(
          padding: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Lab Settings',
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 24,
                  ),
                ),
                ResponsiveText(
                  'Configure how your lab handles test requests, notifications, and security.',
                  style: TextStyle(
                    fontFamily: 'uber',
                    color: colors.textSecondary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 28,
                  ),
                ),
                _SettingsGrid(
                  children: [
                    _SettingsSection(
                      title: 'Lab Profile',
                      description:
                          'Keep your lab details up to date so they flow into client forms and notifications.',
                      children: [
                        _SettingsTextField(
                          label: 'Lab Name',
                          initialValue: settings.labName,
                          onChanged: settings.updateLabName,
                        ),
                        _SettingsTextField(
                          label: 'Contact Email',
                          keyboardType: TextInputType.emailAddress,
                          initialValue: settings.contactEmail,
                          onChanged: settings.updateContactEmail,
                        ),
                        _SettingsTextField(
                          label: 'Contact Phone',
                          keyboardType: TextInputType.phone,
                          initialValue: settings.contactPhone,
                          onChanged: settings.updateContactPhone,
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'Notification Preferences',
                      description:
                          'Decide when the team should be alerted about request activity.',
                      children: [
                        _SettingsSwitchTile(
                          title: 'Notify immediately on new requests',
                          value: settings.notifyOnNewRequest,
                          onChanged: settings.toggleNotifyOnNewRequest,
                        ),
                        _SettingsSwitchTile(
                          title: 'Alert me when pending requests age past 24h',
                          value: settings.notifyOnPendingAging,
                          onChanged: settings.toggleNotifyOnPendingAging,
                        ),
                        _SettingsSwitchTile(
                          title: 'Send daily performance summary email',
                          value: settings.dailySummaryEmail,
                          onChanged: settings.toggleDailySummaryEmail,
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'Workflow Defaults',
                      description:
                          'Tune request automation so that collectors get the right information fast.',
                      children: [
                        _SettingsDropdown<String>(
                          label: 'Default Urgency',
                          value: settings.defaultUrgency,
                          options: settings.urgencyOptions,
                          onChanged: settings.updateDefaultUrgency,
                        ),
                        _SettingsDropdown<int>(
                          label: 'Time before form link expires',
                          value: settings.formExpiryHours,
                          options: settings.formExpiryOptions,
                          optionLabelBuilder: (value) =>
                              '$value hour${value == 1 ? '' : 's'}',
                          onChanged: settings.updateFormExpiryHours,
                        ),
                        _SettingsSwitchTile(
                          title: 'Automatically assign a collector',
                          value: settings.autoAssignCollector,
                          onChanged: settings.toggleAutoAssignCollector,
                        ),
                        _SettingsSwitchTile(
                          title: 'Auto-delete expired, unused forms',
                          value: settings.autoDeleteExpiredForms,
                          onChanged: settings.toggleAutoDeleteExpiredForms,
                        ),
                      ],
                    ),
                    _SettingsSection(
                      title: 'Security & Access',
                      description:
                          'Protect patient data and make sure only authorised staff can act on requests.',
                      children: [
                        _SettingsSwitchTile(
                          title: 'Require two-factor authentication at sign-in',
                          value: settings.enableTwoFactor,
                          onChanged: settings.toggleTwoFactor,
                        ),
                        _SettingsDropdown<int>(
                          label: 'Auto sign-out after',
                          value: settings.sessionTimeoutMinutes,
                          options: settings.sessionTimeoutOptions,
                          optionLabelBuilder: (value) =>
                              '$value minute${value == 1 ? '' : 's'} of inactivity',
                          onChanged: settings.updateSessionTimeout,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 20,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Custombutton(
                    text: 'Save Preferences',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: colors.primary,
                          content: const Text(
                            'Preferences saved locally. Connect to backend to persist.',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsGrid extends StatelessWidget {
  const _SettingsGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    if (isMobile) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  child: child,
                ))
            .toList(),
      );
    }

    final crossAxisCount = isTablet ? 1 : 2;
    final spacing = ResponsiveHelper.getResponsiveValue(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - spacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map(
                (child) => SizedBox(
                  width: itemWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    final verticalSpacing = ResponsiveHelper.getResponsiveValue(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );

    return Card(
      color: colors.surface,
      elevation: ResponsiveHelper.getResponsiveValue(
        context,
        mobile: 1,
        tablet: 2,
        desktop: 3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        side: BorderSide(color: colors.border),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(20),
          desktop: const EdgeInsets.all(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveText(
              title,
              style: TextStyle(
                fontFamily: 'uber',
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing / 2),
            ResponsiveText(
              description,
              style: TextStyle(
                fontFamily: 'uber',
                color: colors.textSecondary,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 13,
                  tablet: 14,
                  desktop: 14,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            ..._intersperse(children, SizedBox(height: verticalSpacing)),
          ],
        ),
      ),
    );
  }

  List<Widget> _intersperse(List<Widget> widgets, Widget separator) {
    if (widgets.isEmpty) return const [];

    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i != widgets.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

class _SettingsTextField extends StatelessWidget {
  const _SettingsTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'uber',
        color: colors.textPrimary,
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 14,
          tablet: 15,
          desktop: 16,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'uber',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'uber',
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
        ),
      ),
      activeColor: colors.primary,
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _SettingsDropdown<T> extends StatelessWidget {
  const _SettingsDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.optionLabelBuilder,
  });

  final String label;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T value)? optionLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'uber',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      style: TextStyle(
        fontFamily: 'uber',
        color: colors.textPrimary,
      ),
      items: options
          .map(
            (option) => DropdownMenuItem<T>(
              value: option,
              child: Text(
                optionLabelBuilder != null
                    ? optionLabelBuilder!(option)
                    : option.toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (selected) {
        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }
}
