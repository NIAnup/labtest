import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labtest/models/request_status.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:provider/provider.dart';

/// Displays requests that have been accepted or are currently in progress.
class AcceptedRequestsScreen extends StatefulWidget {
  const AcceptedRequestsScreen({super.key});

  @override
  State<AcceptedRequestsScreen> createState() =>
      _AcceptedRequestsScreenState();
}

class _AcceptedRequestsScreenState extends State<AcceptedRequestsScreen> {
  bool _syncedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncRequests());
  }

  Future<void> _syncRequests() async {
    if (!mounted || _syncedOnce) return;
    _syncedOnce = true;
    await context.read<TestRequestProvider>().fetchTestRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, TestRequestProvider>(
      builder: (context, theme, provider, _) {
        final colors = theme.colors;
        final combined = <TestRequest>[
          ...provider.activeRequests,
          ...provider.acceptedRequests,
        ]..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );

        Widget body;
        if (provider.isLoading && combined.isEmpty) {
          body = Center(
            child: CircularProgressIndicator(color: colors.primary),
          );
        } else {
          body = RefreshIndicator(
            color: colors.primary,
            onRefresh: () => provider.fetchTestRequests(),
            child: combined.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      _EmptyState(colors: colors),
                    ],
                  )
                : ListView.builder(
                    padding: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: const EdgeInsets.all(16),
                      tablet: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      desktop: const EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 32,
                      ),
                    ),
                    itemCount: combined.length,
                    itemBuilder: (context, index) => _RequestCard(
                      request: combined[index],
                      colors: colors,
                    ),
                  ),
          );
        }

        return Scaffold(
          backgroundColor: colors.background,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: body,
          ),
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.colors,
  });

  final TestRequest request;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final name = _resolveName(request);
    final tests = _resolveTests(request);
    final location = _resolveLocation(request);
    final created =
        DateFormat('MMM dd, yyyy • hh:mm a').format(request.createdAt);
    final status = RequestStatusValue.fromValue(request.status).displayName;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'uber',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'uber',
                      fontWeight: FontWeight.w600,
                      color: colors.onPrimary,
                    ),
                  ),
                  backgroundColor: _statusColor(request.status, colors),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tests,
              style: TextStyle(
                fontFamily: 'uber',
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: colors.textSecondary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'uber',
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule,
                    color: colors.textSecondary, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Created $created',
                  style: TextStyle(
                    fontFamily: 'uber',
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _resolveName(TestRequest request) {
    if (request.patientName.trim().isNotEmpty) {
      return request.patientName.trim();
    }
    final submissionName = request.clientSubmission?['patientName'];
    if (submissionName is String && submissionName.trim().isNotEmpty) {
      return submissionName.trim();
    }
    return 'Client';
  }

  String _resolveTests(TestRequest request) {
    if (request.bloodTestType.trim().isNotEmpty) {
      return request.bloodTestType.trim();
    }
    final submissionTests = request.clientSubmission?['requestedTests'];
    if (submissionTests is List && submissionTests.isNotEmpty) {
      return submissionTests.join(', ');
    }
    return 'Tests in progress';
  }

  String _resolveLocation(TestRequest request) {
    if (request.location.trim().isNotEmpty) {
      return request.location.trim();
    }
    final submissionLocation = request.clientSubmission?['location'];
    if (submissionLocation is String &&
        submissionLocation.trim().isNotEmpty) {
      return submissionLocation.trim();
    }
    return 'Location not provided';
  }

  Color _statusColor(String status, AppColors colors) {
    switch (status) {
      case 'in_progress':
        return colors.primary;
      case 'accepted':
        return colors.info;
      default:
        return colors.primary.withOpacity(0.6);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.assignment_turned_in,
            size: 72, color: colors.textSecondary.withOpacity(0.3)),
        const SizedBox(height: 16),
        Text(
          'No active requests',
          style: TextStyle(
            fontFamily: 'uber',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Accepted or in-progress jobs will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'uber',
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}


