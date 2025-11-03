import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

/// Dialog for sharing the generated form link
class LinkShareDialog extends StatelessWidget {
  final String formLink;
  final String patientName;
  final String testType;

  const LinkShareDialog({
    Key? key,
    required this.formLink,
    required this.patientName,
    required this.testType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final colors = theme.colors;

    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isMobile(context) ? 350 : 500,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.link,
                    color: colors.success,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Test Request Created!",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: "uber",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "Share this link with the client",
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                    fontFamily: "uber",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Patient info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.user, color: colors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: "uber",
                              ),
                            ),
                            Text(
                              testType,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                                fontFamily: "uber",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Link display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border.all(color: colors.border, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          formLink,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 11,
                              tablet: 12,
                              desktop: 13,
                            ),
                            color: colors.textPrimary,
                            fontFamily: "uber",
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Iconsax.copy,
                          color: colors.primary,
                          size: 20,
                        ),
                        onPressed: () => _copyToClipboard(context, formLink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: colors.border),
                            ),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontFamily: "uber",
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 15,
                                  desktop: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _copyToClipboard(context, formLink),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.copy,
                                  color: colors.onPrimary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Copy Link",
                                  style: TextStyle(
                                    color: colors.onPrimary,
                                    fontFamily: "uber",
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // View Form button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _viewForm(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: colors.success, width: 2),
                        ),
                        icon: Icon(
                          Iconsax.eye,
                          color: colors.success,
                          size: 18,
                        ),
                        label: Text(
                          "View Form",
                          style: TextStyle(
                            color: colors.success,
                            fontFamily: "uber",
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 14,
                              tablet: 15,
                              desktop: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    CustomSnackBar.success(context, 'Link copied to clipboard!');
  }

  void _viewForm(BuildContext context) {
    // Extract formLinkId from the URL
    final uri = Uri.parse(formLink);
    final formLinkId = uri.pathSegments.last;

    // Close the dialog
    Navigator.pop(context);

    // Navigate to the form
    context.push('/form/$formLinkId');
  }
}
