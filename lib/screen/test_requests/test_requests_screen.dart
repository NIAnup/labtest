import 'package:flutter/material.dart';
import 'package:labtest/models/test_request_model.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/test_request_card.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/k_debug_print.dart';

/// Screen to display all test requests
class TestRequestsScreen extends StatefulWidget {
  @override
  State<TestRequestsScreen> createState() => _TestRequestsScreenState();
}

class _TestRequestsScreenState extends State<TestRequestsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Load test requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestRequestProvider>(
        context,
        listen: false,
      ).fetchTestRequests();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showRequestDetails(TestRequest request) {
    final theme = AppTheme();
    final colors = theme.colors;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: MediaQuery.of(context).size.width * 0.9,
                tablet: 450,
                desktop: 500,
              ),
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.all(16),
              tablet: const EdgeInsets.all(20),
              desktop: const EdgeInsets.all(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Request Details",
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
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: colors.textSecondary,
                          size: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 20,
                            tablet: 22,
                            desktop: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),

                  // Patient info
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 48,
                            tablet: 56,
                            desktop: 64,
                          ),
                          color: colors.primary,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                        Text(
                          request.patientName,
                          textAlign: TextAlign.center,
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
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 6,
                            tablet: 7,
                            desktop: 8,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 10,
                              tablet: 11,
                              desktop: 12,
                            ),
                            vertical: ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 4,
                              tablet: 5,
                              desktop: 6,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(request.status, colors),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                            ),
                          ),
                          child: Text(
                            request.status,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 11,
                                tablet: 12,
                                desktop: 13,
                              ),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "uber",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),

                  // Details
                  _buildDetailRow(
                    Icons.medical_services,
                    "Blood Test Type",
                    request.bloodTestType,
                    colors,
                  ),
                  _buildDetailRow(
                    Icons.location_on,
                    "Location",
                    request.location,
                    colors,
                  ),
                  _buildDetailRow(
                    Icons.priority_high,
                    "Urgency",
                    request.urgency,
                    colors,
                    valueColor: _getUrgencyColor(request.urgency, colors),
                  ),
                  _buildDetailRow(
                    Icons.calendar_today,
                    "Created",
                    _formatDate(request.createdAt),
                    colors,
                  ),
                  if (request.isSubmitted)
                    _buildDetailRow(
                      Iconsax.tick_circle,
                      "Submitted",
                      _formatDate(request.submittedAt!),
                      colors,
                      valueColor: colors.success,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    AppColors colors, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 6,
          tablet: 7,
          desktop: 8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colors.primary,
            size: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 18,
              tablet: 19,
              desktop: 20,
            ),
          ),
          SizedBox(
            width: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 10,
              tablet: 11,
              desktop: 12,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 11,
                      tablet: 11.5,
                      desktop: 12,
                    ),
                    color: colors.textSecondary,
                    fontFamily: "uber",
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
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                    color: valueColor ?? colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "uber",
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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

  void _showEditDialog(TestRequest request) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController patientNameController = TextEditingController(
      text: request.patientName,
    );
    final TextEditingController locationController = TextEditingController(
      text: request.location,
    );
    final TextEditingController testTypeController = TextEditingController(
      text: request.bloodTestType,
    );
    String urgency = request.urgency;

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<AppTheme>(
          builder: (context, theme, child) {
            return AlertDialog(
              backgroundColor: theme.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ResponsiveText(
                      "Edit Test Request",
                      style: TextStyle(
                        fontFamily: 'uber',
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                        color: theme.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Iconsax.close_square,
                      color: theme.colors.textPrimary,
                      size: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 22,
                        tablet: 26,
                        desktop: 30,
                      ),
                    ),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getResponsiveValue(
                      context,
                      mobile: MediaQuery.of(context).size.width * 0.85,
                      tablet: 400,
                      desktop: 450,
                    ),
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Customtextfield(
                          controller: patientNameController,
                          hintText: "Patient Name",
                          validator: (value) =>
                              value!.isEmpty ? 'Enter patient name' : null,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        Customtextfield(
                          controller: locationController,
                          hintText: "Location",
                          validator: (value) =>
                              value!.isEmpty ? 'Enter location' : null,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        Customtextfield(
                          controller: testTypeController,
                          hintText: "Blood Test Type",
                          validator: (value) =>
                              value!.isEmpty ? 'Enter test type' : null,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colors.border,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colors.primary,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colors.border,
                                width: 2.0,
                              ),
                            ),
                          ),
                          value: urgency,
                          hint: ResponsiveText(
                            "Urgency",
                            style: TextStyle(
                              color: theme.colors.textSecondary,
                              fontFamily: 'uber',
                            ),
                          ),
                          items: ['Normal', 'Urgent'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: ResponsiveText(
                                value,
                                style: TextStyle(
                                  fontFamily: 'uber',
                                  fontWeight: FontWeight.bold,
                                  color: theme.colors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            urgency = newValue!;
                          },
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveValue(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        Custombutton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final testRequestProvider =
                                  Provider.of<TestRequestProvider>(
                                context,
                                listen: false,
                              );

                              Navigator.pop(context);

                              if (request.id != null) {
                                await testRequestProvider.updateRequest(
                                  requestId: request.id!,
                                  patientName: patientNameController.text,
                                  location: locationController.text,
                                  bloodTestType: testTypeController.text,
                                  urgency: urgency,
                                  context: context,
                                );
                              }
                            }
                          },
                          text: 'Update Request',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final colors = theme.colors;

    return Consumer<TestRequestProvider>(
      builder: (context, testRequestProvider, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.background,
                    colors.background.withOpacity(0.95),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header section
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: const EdgeInsets.all(16),
                      tablet: const EdgeInsets.all(20),
                      desktop: const EdgeInsets.all(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.getResponsiveValue(
                                  context,
                                  mobile: 10,
                                  tablet: 12,
                                  desktop: 14,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getResponsiveValue(
                                    context,
                                    mobile: 10,
                                    tablet: 12,
                                    desktop: 12,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Iconsax.document_text,
                                color: colors.primary,
                                size: ResponsiveHelper.getResponsiveValue(
                                  context,
                                  mobile: 24,
                                  tablet: 26,
                                  desktop: 28,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveValue(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Test Requests",
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper
                                          .getResponsiveFontSize(
                                        context,
                                        mobile: 22,
                                        tablet: 24,
                                        desktop: 28,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                      fontFamily: "uber",
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveHelper.getResponsiveValue(
                                      context,
                                      mobile: 4,
                                      tablet: 4,
                                      desktop: 6,
                                    ),
                                  ),
                                  Text(
                                    "${testRequestProvider.testRequests.length} total requests",
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper
                                          .getResponsiveFontSize(
                                        context,
                                        mobile: 14,
                                        tablet: 15,
                                        desktop: 16,
                                      ),
                                      color: colors.textSecondary,
                                      fontFamily: "uber",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content section
                  Expanded(
                    child: testRequestProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colors.primary,
                            ),
                          )
                        : testRequestProvider.testRequests.isEmpty
                            ? _buildEmptyState(colors, context)
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  return _buildResponsiveList(
                                    testRequestProvider,
                                    colors,
                                    constraints.maxWidth,
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppColors colors, BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.document_text,
                size: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 48,
                  tablet: 56,
                  desktop: 64,
                ),
                color: colors.primary,
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 24,
              ),
            ),
            Text(
              "No Test Requests",
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
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 8,
                tablet: 8,
                desktop: 12,
              ),
            ),
            Text(
              "Create a new test request to get started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                color: colors.textSecondary,
                fontFamily: "uber",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveList(
    TestRequestProvider provider,
    AppColors colors,
    double maxWidth,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive parameters based on available width
        double spacing = ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        );

        // Calculate number of columns based on available width
        int crossAxisCount;
        if (maxWidth < AppTheme.mobileBreakpoint) {
          // Mobile: Single column
          crossAxisCount = 1;
        } else if (maxWidth < AppTheme.tabletBreakpoint) {
          // Tablet: 2 columns
          crossAxisCount = 2;
          KDebugPrint.info('Tablet: 2 columns');
        } else if (maxWidth < AppTheme.desktopBreakpoint) {
          // Small desktop: 3 columns
          crossAxisCount = 3;
          KDebugPrint.info('Small desktop: 3 columns');
        } else {
          // Large desktop: 4 columns
          crossAxisCount = 4;
          KDebugPrint.info('Large desktop: 4 columns');
        }

        // Calculate card width based on available space and number of columns
        final padding = ResponsiveHelper.getResponsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(20),
          desktop: const EdgeInsets.all(24),
        );
        final horizontalPadding = padding.left + padding.right;
        final availableWidth = constraints.maxWidth -
            horizontalPadding -
            (spacing * (crossAxisCount - 1));
        final cardWidth = availableWidth / crossAxisCount;

        // Build list of cards
        final cards = provider.testRequests.map((request) {
          return SizedBox(
            width: crossAxisCount == 1 ? null : cardWidth,
            child: TestRequestCard(
              request: request,
              onViewDetails: () => _showRequestDetails(request),
              onEdit: () => _showEditDialog(request),
              onUpdateStatus: () async {
                if (request.id != null) {
                  await provider.updateRequestStatus(
                    requestId: request.id!,
                    status: 'Active',
                    context: context,
                  );
                }
              },
              onDelete: () async {
                if (request.id != null) {
                  await provider.deleteRequest(
                    requestId: request.id!,
                    context: context,
                  );
                }
              },
            ),
          );
        }).toList();

        // For mobile, use ListView
        if (crossAxisCount == 1) {
          return ListView.builder(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              desktop: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            ),
            itemCount: provider.testRequests.length,
            itemBuilder: (context, index) {
              final request = provider.testRequests[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: spacing,
                ),
                child: TestRequestCard(
                  request: request,
                  onViewDetails: () => _showRequestDetails(request),
                  onEdit: () => _showEditDialog(request),
                  onUpdateStatus: () async {
                    if (request.id != null) {
                      await provider.updateRequestStatus(
                        requestId: request.id!,
                        status: 'Active',
                        context: context,
                      );
                    }
                  },
                  onDelete: () async {
                    if (request.id != null) {
                      await provider.deleteRequest(
                        requestId: request.id!,
                        context: context,
                      );
                    }
                  },
                ),
              );
            },
          );
        }

        // For tablet and desktop, use Wrap with SingleChildScrollView
        return SingleChildScrollView(
          padding: padding,
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: cards,
          ),
        );
      },
    );
  }
}
