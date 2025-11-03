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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Request Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: "uber",
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Patient info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person, size: 64, color: colors.primary),
                      const SizedBox(height: 16),
                      Text(
                        request.patientName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontFamily: "uber",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request.status, colors),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          request.status,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: "uber",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          const SizedBox(width: 12),
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
                    fontSize: 16,
                    color: valueColor ?? colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "uber",
                  ),
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
    final theme = AppTheme();
    final colors = theme.colors;
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    "Edit Test Request",
                    style: TextStyle(
                      fontFamily: 'uber',
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                      color: theme.colors.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Iconsax.close_square,
                      color: theme.colors.textPrimary,
                      size: ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 24,
                        tablet: 28,
                        desktop: 30,
                      ),
                    ),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  width: ResponsiveHelper.getResponsiveValue(
                    context,
                    mobile: 280,
                    tablet: 320,
                    desktop: 360,
                  ),
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
    final isMobile = ResponsiveHelper.isMobile(context);

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
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Iconsax.document_text,
                                color: colors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Test Requests",
                                    style: TextStyle(
                                      fontSize: isMobile ? 24 : 28,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                      fontFamily: "uber",
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${testRequestProvider.testRequests.length} total requests",
                                    style: TextStyle(
                                      fontSize: 16,
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
                            ? _buildEmptyState(colors)
                            : ResponsiveLayout(
                                mobile: _buildMobileList(
                                  testRequestProvider,
                                  colors,
                                ),
                                tablet: _buildTabletList(
                                  testRequestProvider,
                                  colors,
                                ),
                                desktop: _buildDesktopList(
                                  testRequestProvider,
                                  colors,
                                ),
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

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.document_text, size: 64, color: colors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            "No Test Requests",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: "uber",
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create a new test request to get started",
            style: TextStyle(
              fontSize: 16,
              color: colors.textSecondary,
              fontFamily: "uber",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(TestRequestProvider provider, AppColors colors) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.testRequests.length,
      itemBuilder: (context, index) {
        final request = provider.testRequests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildTabletList(TestRequestProvider provider, AppColors colors) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: provider.testRequests.length,
      itemBuilder: (context, index) {
        final request = provider.testRequests[index];
        return TestRequestCard(
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
        );
      },
    );
  }

  Widget _buildDesktopList(TestRequestProvider provider, AppColors colors) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: provider.testRequests.length,
      itemBuilder: (context, index) {
        final request = provider.testRequests[index];
        return TestRequestCard(
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
        );
      },
    );
  }
}
