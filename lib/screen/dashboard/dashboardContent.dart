import 'package:flutter/material.dart';
import 'package:labtest/widget/starCards.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return SingleChildScrollView(
          padding: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: const EdgeInsets.all(12.0),
            tablet: const EdgeInsets.all(16.0),
            desktop: const EdgeInsets.all(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards Section
              ResponsiveText(
                'Overview',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 28,
                  ),
                  fontFamily: "uber",
                  fontWeight: FontWeight.bold,
                  color: theme.colors.textPrimary,
                ),
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              )),
              // Stats Cards Section - Responsive Layout
              ResponsiveLayout(
                mobile: _buildMobileStats(context, theme),
                tablet: _buildTabletStats(context, theme),
                desktop: _buildDesktopStats(context, theme),
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 32,
              )),
              // Upcoming Appointments Section - Responsive Layout
              ResponsiveLayout(
                mobile: _buildMobileAppointments(context, theme),
                tablet: _buildTabletAppointments(context, theme),
                desktop: _buildDesktopAppointments(context, theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentItem(
    BuildContext context,
    AppTheme theme,
    String name,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 12,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            )),
            decoration: BoxDecoration(
              color: theme.colors.primary.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
            ),
            child: Icon(
              icon,
              color: theme.colors.primary,
              size: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
          ),
          SizedBox(
              width: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 12,
            tablet: 16,
            desktop: 20,
          )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  name,
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
                  description,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    fontFamily: "uber",
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Responsive Stats Methods
  Widget _buildMobileStats(BuildContext context, AppTheme theme) {
    return Column(
      children: [
        StatCard(
          title: 'Active Requests',
          value: '120',
          color: theme.colors.error.withOpacity(0.1),
          textColor: theme.colors.error,
          icon: Icons.timeline,
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        StatCard(
          title: 'Pending Tests',
          value: '35',
          color: theme.colors.warning.withOpacity(0.1),
          textColor: theme.colors.warning,
          icon: Icons.pending_actions,
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        StatCard(
          title: 'Completed Tests',
          value: '210',
          color: theme.colors.success.withOpacity(0.1),
          textColor: theme.colors.success,
          icon: Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildTabletStats(BuildContext context, AppTheme theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Active Requests',
                value: '120',
                color: theme.colors.error.withOpacity(0.1),
                textColor: theme.colors.error,
                icon: Icons.timeline,
              ),
            ),
            SizedBox(
                width: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            )),
            Expanded(
              child: StatCard(
                title: 'Pending Tests',
                value: '35',
                color: theme.colors.warning.withOpacity(0.1),
                textColor: theme.colors.warning,
                icon: Icons.pending_actions,
              ),
            ),
          ],
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Completed Tests',
                value: '210',
                color: theme.colors.success.withOpacity(0.1),
                textColor: theme.colors.success,
                icon: Icons.check_circle,
              ),
            ),
            SizedBox(
                width: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            )),
            Expanded(
              child: Container(), // Empty space for alignment
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopStats(BuildContext context, AppTheme theme) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Active Requests',
            value: '120',
            color: theme.colors.error.withOpacity(0.1),
            textColor: theme.colors.error,
            icon: Icons.timeline,
          ),
        ),
        SizedBox(
            width: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        Expanded(
          child: StatCard(
            title: 'Pending Tests',
            value: '35',
            color: theme.colors.warning.withOpacity(0.1),
            textColor: theme.colors.warning,
            icon: Icons.pending_actions,
          ),
        ),
        SizedBox(
            width: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        Expanded(
          child: StatCard(
            title: 'Completed Tests',
            value: '210',
            color: theme.colors.success.withOpacity(0.1),
            textColor: theme.colors.success,
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  // Responsive Appointments Methods
  Widget _buildMobileAppointments(BuildContext context, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
            fontFamily: "uber",
            fontWeight: FontWeight.bold,
            color: theme.colors.textPrimary,
          ),
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        _buildAppointmentsCard(context, theme),
      ],
    );
  }

  Widget _buildTabletAppointments(BuildContext context, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
            fontFamily: "uber",
            fontWeight: FontWeight.bold,
            color: theme.colors.textPrimary,
          ),
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        _buildAppointmentsCard(context, theme),
      ],
    );
  }

  Widget _buildDesktopAppointments(BuildContext context, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
            fontFamily: "uber",
            fontWeight: FontWeight.bold,
            color: theme.colors.textPrimary,
          ),
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
        _buildAppointmentsCard(context, theme),
      ],
    );
  }

  Widget _buildAppointmentsCard(BuildContext context, AppTheme theme) {
    return Card(
      color: theme.colors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 8,
          tablet: 10,
          desktop: 12,
        )),
      ),
      child: Container(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(12),
          tablet: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(20),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppointmentItem(
              context,
              theme,
              'Gilbert Sandoval',
              'Blood Test - 9:30 AM',
              Icons.bloodtype,
            ),
            Divider(color: theme.colors.divider),
            _buildAppointmentItem(
              context,
              theme,
              'Sofia Velasquez',
              'Consultation - 10:15 AM',
              Icons.medical_services,
            ),
            Divider(color: theme.colors.divider),
            _buildAppointmentItem(
              context,
              theme,
              'Emma Johnson',
              'Surgery - 11:00 AM',
              Icons.local_hospital,
            ),
          ],
        ),
      ),
    );
  }
}
