import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/provider/settings_provider.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/utils/route_names.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _inviteEmailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final _inviteFormKey = GlobalKey<FormState>();
  final _feedbackFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inviteEmailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, SettingsProvider>(
      builder: (context, theme, settings, child) {
        final colors = theme.colors;
        final sectionGap = SizedBox(
          height: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        );

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 24,
              desktop: 36,
            ),
            vertical: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Settings & Support',
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 26,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                ResponsiveText(
                  'Review the information captured during sign-up, manage notifications, and reach our team in a tap.',
                  style: TextStyle(
                    fontFamily: 'uber',
                    color: colors.textSecondary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 18,
                    tablet: 22,
                    desktop: 26,
                  ),
                ),
                _SettingsSection(
                  title: 'Account Details',
                  description:
                      'Update the primary details that your clients and riders rely on.',
                  children: [
                    _SettingsTextField(
                      label: 'Lab Name',
                      initialValue: settings.labName,
                      onChanged: settings.updateLabName,
                    ),
                    _SettingsTextField(
                      label: 'Owner / Contact Person',
                      initialValue: settings.ownerName,
                      onChanged: settings.updateOwnerName,
                    ),
                    _SettingsTextField(
                      label: 'Contact Email',
                      keyboardType: TextInputType.emailAddress,
                      initialValue: settings.contactEmail,
                      onChanged: settings.updateContactEmail,
                    ),
                    _SettingsTextField(
                      label: 'Contact Number',
                      keyboardType: TextInputType.phone,
                      initialValue: settings.contactPhone,
                      onChanged: settings.updateContactPhone,
                    ),
                  ],
                ),
                sectionGap,
                _SettingsSection(
                  title: 'Location & Operating Hours',
                  description:
                      'These details help collectors plan pickups and clients schedule visits.',
                  children: [
                    _SettingsTextField(
                      label: 'Lab Address',
                      initialValue: settings.labAddress,
                      onChanged: settings.updateLabAddress,
                      maxLines: ResponsiveHelper.isDesktop(context) ? 2 : 3,
                    ),
                    _SettingsTextField(
                      label: 'City / State / Pincode',
                      initialValue: settings.cityStatePincode,
                      onChanged: settings.updateCityStatePincode,
                    ),
                    _SettingsTextField(
                      label: 'Operating Hours',
                      initialValue: settings.operatingHours,
                      onChanged: settings.updateOperatingHours,
                    ),
                  ],
                ),
                sectionGap,
                _SettingsSection(
                  title: 'Notification Channels',
                  description:
                      'Pick how you want to receive alerts when new requests arrive or clients respond.',
                  children: [
                    _SettingsSwitchTile(
                      title: 'Email updates',
                      subtitle: 'Receive confirmations and daily summaries.',
                      value: settings.notifyByEmail,
                      onChanged: settings.toggleNotifyByEmail,
                    ),
                    _SettingsSwitchTile(
                      title: 'SMS alerts',
                      subtitle: 'Quick nudges for urgent pickups.',
                      value: settings.notifyBySms,
                      onChanged: settings.toggleNotifyBySms,
                    ),
                    _SettingsSwitchTile(
                      title: 'WhatsApp notifications',
                      subtitle:
                          'Send real-time collection status to your team.',
                      value: settings.notifyByWhatsApp,
                      onChanged: settings.toggleNotifyByWhatsApp,
                    ),
                  ],
                ),
                sectionGap,
                _SettingsSection(
                  title: 'Terms & Privacy',
                  description:
                      'Stay compliant with the latest Blood Lab policies.',
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Accepted Terms & Conditions',
                        style: TextStyle(
                          fontFamily: 'uber',
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        settings.termsAcceptedAt != null
                            ? 'Accepted on ${_formatDate(settings.termsAcceptedAt!)}'
                            : 'Not accepted yet',
                        style: TextStyle(
                          fontFamily: 'uber',
                          color: colors.textSecondary,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () => _showTermsDialog(context, theme),
                        child: const Text('View'),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: colors.primary,
                      value: settings.acceptTerms,
                      onChanged: (value) =>
                          settings.updateAcceptTerms(value ?? false),
                      title: Text(
                        'I agree to the Blood Lab Terms & Conditions and privacy guidelines.',
                        style: TextStyle(
                          fontFamily: 'uber',
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                sectionGap,
                _SettingsSection(
                  title: 'Invite & Feedback',
                  description:
                      'Bring another lab partner onboard or share how we can improve.',
                  children: [
                    Form(
                      key: _inviteFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _inviteEmailController,
                            keyboardType: TextInputType.emailAddress,
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
                              labelText: 'Invite colleague by email',
                              hintText: 'phlebotomist@partnerlab.com',
                              labelStyle: TextStyle(
                                fontFamily: 'uber',
                                color: colors.textSecondary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: colors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter an email address to send an invite.';
                              }
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Custombutton(
                              height: 40,
                              width: ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 140,
                                tablet: 160,
                                desktop: 180,
                              ),
                              text: 'Send Invite',
                              onTap: () => _handleSendInvite(
                                context: context,
                                theme: theme,
                                settings: settings,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (settings.lastFeedback != null &&
                              settings.lastFeedback!.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Latest feedback sent',
                                    style: TextStyle(
                                      fontFamily: 'uber',
                                      fontWeight: FontWeight.w600,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    settings.lastFeedback!,
                                    style: TextStyle(
                                      fontFamily: 'uber',
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 12),
                          Form(
                            key: _feedbackFormKey,
                            child: TextFormField(
                              controller: _feedbackController,
                              maxLines: 4,
                              style: TextStyle(
                                fontFamily: 'uber',
                                color: colors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Share feedback with Blood Lab',
                                hintText:
                                    'Tell us what works well or what you expect next.',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: colors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a message before sending.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Custombutton(
                              height: 40,
                              width: ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 150,
                                tablet: 170,
                                desktop: 190,
                              ),
                              text: 'Send Feedback',
                              onTap: () => _handleSubmitFeedback(
                                context: context,
                                theme: theme,
                                settings: settings,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sectionGap,
                _SettingsSection(
                  title: 'Support & Logout',
                  description:
                      'Need anything else? Reach us directly or end this session safely.',
                  children: [
                    Wrap(
                      spacing: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                      runSpacing: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                      children: [
                        _SupportActionChip(
                          label: 'Call Us',
                          icon: Icons.call,
                          onTap: () => _showSupportSnackBar(
                            context,
                            theme,
                            'Call us at ${settings.supportPhone}',
                          ),
                        ),
                        _SupportActionChip(
                          label: 'Support Chat',
                          icon: Icons.chat_bubble_outline,
                          onTap: () => _showSupportSnackBar(
                            context,
                            theme,
                            'Connecting you to a live support specialist…',
                          ),
                        ),
                        _SupportActionChip(
                          label: 'WhatsApp',
                          icon: Icons.phone_iphone,
                          onTap: () => _showSupportSnackBar(
                            context,
                            theme,
                            'Opening WhatsApp chat at ${settings.supportWhatsApp}',
                          ),
                        ),
                        _SupportActionChip(
                          label: 'Email Support',
                          icon: Icons.email_outlined,
                          onTap: () => _showSupportSnackBar(
                            context,
                            theme,
                            'Email us at ${settings.supportEmail}',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    Custombutton(
                      width: double.infinity,
                      height: 44,
                      text: 'Logout',
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: colors.warning,
                            content: const Text(
                              'You have been signed out from this session.',
                            ),
                          ),
                        );
                        context.go(RouteNames.login);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Custombutton(
                    height: 44,
                    text: 'Save Changes',
                    onTap: () {
                      FocusScope.of(context).unfocus();
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

  void _handleSendInvite({
    required BuildContext context,
    required AppTheme theme,
    required SettingsProvider settings,
  }) {
    if (_inviteFormKey.currentState?.validate() ?? false) {
      final email = _inviteEmailController.text.trim();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colors.success,
          content: Text(
            'Invite sent to $email via ${settings.inviteLink}.',
            style: const TextStyle(fontFamily: 'uber'),
          ),
        ),
      );
      _inviteEmailController.clear();
    }
  }

  void _handleSubmitFeedback({
    required BuildContext context,
    required AppTheme theme,
    required SettingsProvider settings,
  }) {
    if (_feedbackFormKey.currentState?.validate() ?? false) {
      final feedback = _feedbackController.text.trim();
      FocusScope.of(context).unfocus();
      settings.saveFeedback(feedback);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colors.success,
          content: const Text(
            'Thank you for sharing feedback with Blood Lab!',
            style: TextStyle(fontFamily: 'uber'),
          ),
        ),
      );
      _feedbackController.clear();
    }
  }

  void _showSupportSnackBar(
    BuildContext context,
    AppTheme theme,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colors.primary,
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'uber'),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context, AppTheme theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colors.surface,
          title: ResponsiveText(
            'Terms & Conditions',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.bold,
              color: theme.colors.textPrimary,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  '• All patient information collected through Blood Lab must adhere to HIPAA and local compliance.\n'
                  '• Invites are restricted to verified lab partners only.\n'
                  '• You are responsible for keeping contact details current for emergency notifications.\n'
                  '• Misuse or unauthorised sharing of credentials may lead to suspension of services.',
                  style: TextStyle(
                    fontFamily: 'uber',
                    color: theme.colors.textSecondary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'uber',
                  color: theme.colors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
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
    this.maxLines = 1,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
    this.subtitle,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

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
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(
                fontFamily: 'uber',
                color: colors.textSecondary,
              ),
            ),
      activeColor: colors.primary,
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _SupportActionChip extends StatelessWidget {
  const _SupportActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<AppTheme>().colors;

    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: colors.onPrimary,
      ),
      backgroundColor: colors.primary,
      elevation: 1,
      pressElevation: 3,
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'uber',
          color: colors.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onTap,
    );
  }
}
