import 'package:flutter/material.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

/// Custom widget for displaying a test request card
class TestRequestCard extends StatelessWidget {
  final TestRequest request;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpdateStatus;
  final VoidCallback? onDelete;
  final bool showActions;

  const TestRequestCard({
    Key? key,
    required this.request,
    this.onViewDetails,
    this.onUpdateStatus,
    this.onDelete,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final colors = theme.colors;

    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Card(
          elevation: 8,
          shadowColor: colors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface,
                  colors.surface.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with patient name and status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request.status, colors).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
                          color: _getStatusColor(request.status, colors),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.patientName,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 18,
                                  tablet: 20,
                                  desktop: 22,
                                ),
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                fontFamily: "uber",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(request.status, colors),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                request.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "uber",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Test type
                  _buildInfoRow(
                    icon: Iconsax.medical_bag,
                    label: 'Test Type',
                    value: request.bloodTestType,
                    colors: colors,
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  _buildInfoRow(
                    icon: Iconsax.location,
                    label: 'Location',
                    value: request.location,
                    colors: colors,
                  ),
                  const SizedBox(height: 8),
                  
                  // Urgency
                  _buildInfoRow(
                    icon: Iconsax.warning_2,
                    label: 'Urgency',
                    value: request.urgency,
                    colors: colors,
                    valueColor: _getUrgencyColor(request.urgency, colors),
                  ),
                  const SizedBox(height: 8),
                  
                  // Created date
                  _buildInfoRow(
                    icon: Iconsax.calendar,
                    label: 'Created',
                    value: _formatDate(request.createdAt),
                    colors: colors,
                  ),
                  
                  // Show submission info if submitted
                  if (request.isSubmitted) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Iconsax.tick_circle,
                      label: 'Submitted',
                      value: _formatDate(request.submittedAt!),
                      colors: colors,
                      valueColor: colors.success,
                    ),
                  ],
                  
                  // Actions
                  if (showActions) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (onViewDetails != null)
                          _buildActionButton(
                            icon: Iconsax.eye,
                            label: "View",
                            color: colors.info,
                            onPressed: onViewDetails!,
                          ),
                        if (onUpdateStatus != null && request.status == 'New')
                          _buildActionButton(
                            icon: Iconsax.tick_square,
                            label: "Accept",
                            color: colors.success,
                            onPressed: onUpdateStatus!,
                          ),
                        if (onDelete != null && request.status == 'New')
                          _buildActionButton(
                            icon: Iconsax.trash,
                            label: "Delete",
                            color: colors.error,
                            onPressed: onDelete!,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColors colors,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  fontFamily: "uber",
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: "uber",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: "uber",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, AppColors colors) {
    switch (status.toLowerCase()) {
      case 'new':
        return colors.info;
      case 'pending':
        return colors.warning;
      case 'active':
        return colors.primary;
      case 'completed':
        return colors.success;
      case 'cancelled':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  Color _getUrgencyColor(String urgency, AppColors colors) {
    switch (urgency.toLowerCase()) {
      case 'urgent':
        return colors.error;
      case 'normal':
        return colors.info;
      default:
        return colors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

