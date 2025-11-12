import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';

Color _withOpacity(Color color, double opacity) {
  final clampedOpacity = opacity.clamp(0.0, 1.0);
  final newAlpha = (color.a * clampedOpacity).clamp(0.0, 1.0);
  return color.withValues(alpha: newAlpha);
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: theme.colors.background,
            appBar: AppBar(
              backgroundColor: theme.colors.surface,
              foregroundColor: theme.colors.textPrimary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colors.textPrimary,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Notifications',
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
              bottom: TabBar(
                indicatorColor: theme.colors.primary,
                labelColor: theme.colors.primary,
                unselectedLabelColor: theme.colors.textSecondary,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'Client Forms'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('test_requests')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colors.primary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _NotificationPlaceholder(
                    icon: Icons.error_outline,
                    message: 'Unable to load notifications right now.',
                    theme: theme,
                  );
                }

                final requests = snapshot.data?.docs
                        .map(TestRequest.fromFirestore)
                        .toList() ??
                    [];

                final accepted = requests
                    .where((r) => r.status.toLowerCase() == 'active')
                    .toList();
                final clientForms =
                    requests.where((r) => r.clientSubmission != null).toList();
                final completed = requests
                    .where((r) => r.status.toLowerCase() == 'completed')
                    .toList();

                return TabBarView(
                  children: [
                    _NotificationsList(
                      requests: requests,
                      emptyMessage: 'No notifications yet.',
                    ),
                    _NotificationsList(
                      requests: accepted,
                      emptyMessage:
                          'Accepted requests will show up here once available.',
                    ),
                    _NotificationsList(
                      requests: clientForms,
                      emptyMessage:
                          'Client form submissions will appear in this tab.',
                    ),
                    _NotificationsList(
                      requests: completed,
                      emptyMessage:
                          'Completed requests will be listed in this section.',
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({
    required this.requests,
    required this.emptyMessage,
  });

  final List<TestRequest> requests;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();

    if (requests.isEmpty) {
      return _NotificationPlaceholder(
        icon: Icons.notifications_none_outlined,
        message: emptyMessage,
        theme: theme,
      );
    }

    return ListView.separated(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        desktop: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      ),
      itemBuilder: (context, index) {
        final request = requests[index];
        return _NotificationTile(request: request);
      },
      separatorBuilder: (context, index) => SizedBox(
        height: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
      ),
      itemCount: requests.length,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.request});

  final TestRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    final timestamp = DateFormat('MMM dd, yyyy • hh:mm a')
        .format(request.createdAt.toLocal());
    final title = _titleForRequest(request);
    final details = _subtitleForRequest(request);
    final statusColor = _statusColor(theme, request);
    final statusIcon = _statusIcon(request);

    return Card(
      color: theme.colors.surface,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(18),
          desktop: const EdgeInsets.all(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 44,
                tablet: 48,
                desktop: 52,
              ),
              width: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 44,
                tablet: 48,
                desktop: 52,
              ),
              decoration: BoxDecoration(
                color: _withOpacity(statusColor, 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
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
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'uber',
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                      color: theme.colors.textPrimary,
                    ),
                  ),
                  if (details.isNotEmpty) ...[
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 6,
                        tablet: 8,
                        desktop: 10,
                      ),
                    ),
                    Text(
                      details,
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
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 14,
                          tablet: 15,
                          desktop: 16,
                        ),
                        color: theme.colors.textSecondary,
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 6,
                          tablet: 8,
                          desktop: 10,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: TextStyle(
                          fontFamily: 'uber',
                          color: theme.colors.textSecondary,
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 12,
                            tablet: 13,
                            desktop: 14,
                          ),
                        ),
                      ),
                    ],
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
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _withOpacity(statusColor, 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                request.status,
                style: TextStyle(
                  fontFamily: 'uber',
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _titleForRequest(TestRequest request) {
    if (request.status.toLowerCase() == 'active') {
      return 'Request accepted for collection';
    }

    if (request.status.toLowerCase() == 'completed') {
      return 'Request completed successfully';
    }

    if (request.clientSubmission != null) {
      return 'Client form submitted';
    }

    if (request.status.toLowerCase() == 'pending') {
      return 'Request awaiting confirmation';
    }

    return 'New test request created';
  }

  String _subtitleForRequest(TestRequest request) {
    final details = <String>[];

    if (request.patientName.isNotEmpty) {
      details.add(request.patientName);
    }

    if (request.bloodTestType.isNotEmpty) {
      details.add(request.bloodTestType);
    }

    if (request.location.isNotEmpty) {
      details.add(request.location);
    }

    if (request.clientSubmission != null) {
      final submission = ClientSubmission.fromMap(request.clientSubmission!);
      details.add(
          'Submitted ${DateFormat('MMM dd • hh:mm a').format(submission.submittedAt)}');
    }

    return details.join(' • ');
  }

  Color _statusColor(AppTheme theme, TestRequest request) {
    switch (request.status.toLowerCase()) {
      case 'active':
        return theme.colors.info;
      case 'pending':
        return theme.colors.warning;
      case 'completed':
        return theme.colors.success;
      case 'cancelled':
        return theme.colors.error;
      default:
        return theme.colors.primary;
    }
  }

  IconData _statusIcon(TestRequest request) {
    switch (request.status.toLowerCase()) {
      case 'active':
        return Icons.local_shipping_outlined;
      case 'pending':
        return Icons.hourglass_bottom_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}

class _NotificationPlaceholder extends StatelessWidget {
  const _NotificationPlaceholder({
    required this.icon,
    required this.message,
    required this.theme,
  });

  final IconData icon;
  final String message;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 48,
              tablet: 56,
              desktop: 64,
            ),
            color: _withOpacity(theme.colors.textSecondary, 0.6),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
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
    );
  }
}
