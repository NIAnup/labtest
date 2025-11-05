import 'package:flutter/material.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

/// Custom widget for displaying a test request card
class TestRequestCard extends StatelessWidget {
  final TestRequest request;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpdateStatus;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const TestRequestCard({
    Key? key,
    required this.request,
    this.onViewDetails,
    this.onUpdateStatus,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final colors = theme.colors;

    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Container(
          margin: EdgeInsets.only(
            top: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 10,
              tablet: 10,
              desktop: 10,
            ),
          ),
          padding: EdgeInsets.only(
            top: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 10,
              tablet: 10,
              desktop: 10,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.surface, colors.surface.withOpacity(0.8)],
            ),
          ),
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.all(12),
              tablet: const EdgeInsets.all(10),
              desktop: const EdgeInsets.all(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with patient name and status
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 8,
                          tablet: 8,
                          desktop: 12,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          request.status,
                          colors,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person,
                        color: _getStatusColor(request.status, colors),
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 18,
                          tablet: 20,
                          desktop: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 8,
                        tablet: 8,
                        desktop: 12,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            request.patientName.isNotEmpty
                                ? request.patientName
                                : 'Form ${request.formLinkId.length > 8 ? request.formLinkId.substring(0, 8) + "..." : request.formLinkId}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 13,
                                tablet: 14,
                                desktop: 18,
                              ),
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                              fontFamily: "uber",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 2,
                            tablet: 3,
                            desktop: 4,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 6,
                              tablet: 6,
                              desktop: 8,
                            ),
                            vertical: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 2,
                              tablet: 3,
                              desktop: 4,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(request.status, colors),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            request.status,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 9,
                                tablet: 10,
                                desktop: 12,
                              ),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "uber",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 6,
                    tablet: 6,
                    desktop: 12,
                  ),
                ),

                // Test type
                _buildInfoRow(
                  icon: Iconsax.bag_2,
                  label: 'Test Type',
                  value: request.bloodTestType.isNotEmpty
                      ? request.bloodTestType
                      : 'Not specified',
                  colors: colors,
                  context: context,
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 6,
                  ),
                ),

                // Location
                _buildInfoRow(
                  icon: Iconsax.location,
                  label: 'Location',
                  value: request.location.isNotEmpty
                      ? request.location
                      : 'Not specified',
                  colors: colors,
                  context: context,
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 6,
                  ),
                ),

                // Urgency
                _buildInfoRow(
                  icon: Iconsax.warning_2,
                  label: 'Urgency',
                  value: request.urgency,
                  colors: colors,
                  valueColor: _getUrgencyColor(request.urgency, colors),
                  context: context,
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 6,
                  ),
                ),

                // Created date
                _buildInfoRow(
                  icon: Iconsax.calendar,
                  label: 'Created',
                  value: _formatDate(request.createdAt),
                  colors: colors,
                  context: context,
                ),

                // Show submission info if submitted
                if (request.isSubmitted) ...[
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 3,
                      tablet: 4,
                      desktop: 6,
                    ),
                  ),
                  _buildInfoRow(
                    icon: Iconsax.tick_circle,
                    label: 'Submitted',
                    value: _formatDate(request.submittedAt!),
                    colors: colors,
                    valueColor: colors.success,
                    context: context,
                  ),
                ],

                // Actions
                if (showActions) ...[
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 6,
                      tablet: 6,
                      desktop: 12,
                    ),
                  ),
                  ResponsiveHelper.isMobile(context) ||
                          ResponsiveHelper.isTablet(context)
                      ? Wrap(
                          spacing: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 4,
                            tablet: 4,
                            desktop: 8,
                          ),
                          runSpacing: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 4,
                            tablet: 4,
                            desktop: 8,
                          ),
                          alignment: WrapAlignment.spaceEvenly,
                          children: _buildActionButtons(context, colors),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _buildActionButtons(context, colors),
                        ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, AppColors colors) {
    final isMobileOrTablet = ResponsiveHelper.isMobile(context) ||
        ResponsiveHelper.isTablet(context);
    return [
      if (onViewDetails != null)
        isMobileOrTablet
            ? _buildActionButton(
                icon: Iconsax.eye,
                label: "View",
                color: colors.info,
                onPressed: onViewDetails!,
                context: context,
              )
            : Expanded(
                child: _buildActionButton(
                  icon: Iconsax.eye,
                  label: "View",
                  color: colors.info,
                  onPressed: onViewDetails!,
                  context: context,
                ),
              ),
      if (onEdit != null && request.status == 'New')
        isMobileOrTablet
            ? _buildActionButton(
                icon: Iconsax.edit,
                label: "Edit",
                color: colors.warning,
                onPressed: onEdit!,
                context: context,
              )
            : Expanded(
                child: _buildActionButton(
                  icon: Iconsax.edit,
                  label: "Edit",
                  color: colors.warning,
                  onPressed: onEdit!,
                  context: context,
                ),
              ),
      if (onUpdateStatus != null && request.status == 'New')
        isMobileOrTablet
            ? _buildActionButton(
                icon: Iconsax.tick_square,
                label: "Accept",
                color: colors.success,
                onPressed: onUpdateStatus!,
                context: context,
              )
            : Expanded(
                child: _buildActionButton(
                  icon: Iconsax.tick_square,
                  label: "Accept",
                  color: colors.success,
                  onPressed: onUpdateStatus!,
                  context: context,
                ),
              ),
      if (onDelete != null && request.status == 'New')
        isMobileOrTablet
            ? _buildActionButton(
                icon: Iconsax.trash,
                label: "Delete",
                color: colors.error,
                onPressed: onDelete!,
                context: context,
              )
            : Expanded(
                child: _buildActionButton(
                  icon: Iconsax.trash,
                  label: "Delete",
                  color: colors.error,
                  onPressed: onDelete!,
                  context: context,
                ),
              ),
    ];
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColors colors,
    Color? valueColor,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 12,
            tablet: 13,
            desktop: 16,
          ),
          color: colors.primary,
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 6,
            tablet: 6,
            desktop: 8,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 9,
                    tablet: 10,
                    desktop: 12,
                  ),
                  color: colors.textSecondary,
                  fontFamily: "uber",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 1,
                  tablet: 1,
                  desktop: 3,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 9,
                    tablet: 10,
                    desktop: 12,
                  ),
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
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: BoxConstraints(
          minWidth: ResponsiveHelper.isMobile(context)
              ? 55
              : ResponsiveHelper.isTablet(context)
                  ? 60
                  : 70,
          maxWidth: ResponsiveHelper.isTablet(context) ? 100 : double.infinity,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 5,
            tablet: 5,
            desktop: 10,
          ),
          vertical: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 3,
            tablet: 3,
            desktop: 6,
          ),
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 13,
                tablet: 14,
                desktop: 18,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 2,
                tablet: 2,
                desktop: 3,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 8,
                  tablet: 8,
                  desktop: 11,
                ),
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: "uber",
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
