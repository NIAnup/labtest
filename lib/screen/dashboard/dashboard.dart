import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:labtest/provider/navigatorprodiver.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/screen/active_screen/active_screen.dart';
import 'package:labtest/screen/complete_screen/complete_screen.dart';
import 'package:labtest/screen/dashboard/Topappbar.dart';
import 'package:labtest/screen/dashboard/dashboardContent.dart';
import 'package:labtest/screen/pending_screen/pending_screen.dart';
import 'package:labtest/screen/test_requests/test_requests_screen.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/Navitem.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/widget/link_share_dialog.dart';
import 'package:provider/provider.dart';

class BloodLabHomePage extends StatelessWidget {
  const BloodLabHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigatorProvider>(context);

    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return Myscaffold(
          backgroundColor: theme.colors.background,
          body: ResponsiveLayout(
            mobile: _buildMobileLayout(context, provider, theme),
            tablet: _buildTabletLayout(context, provider, theme),
            desktop: _buildDesktopLayout(context, provider, theme),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: ResponsiveText(
          'Blood Lab',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
            fontWeight: FontWeight.bold,
            color: theme.colors.textPrimary,
          ),
        ),
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.textPrimary,
        actions: [
          IconButton(
            icon: Icon(
              theme.isLightTime ? Icons.dark_mode : Icons.light_mode,
              color: theme.colors.textPrimary,
            ),
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, provider, theme),
      body: _buildBody(context, provider, theme),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: ResponsiveText(
          'Blood Lab',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
            fontWeight: FontWeight.bold,
            color: theme.colors.textPrimary,
          ),
        ),
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.textPrimary,
        actions: [
          IconButton(
            icon: Icon(
              theme.isLightTime ? Icons.dark_mode : Icons.light_mode,
              color: theme.colors.textPrimary,
            ),
            onPressed: () => theme.toggleTheme(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, provider, theme),
      body: _buildBody(context, provider, theme),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return Row(
      children: [
        // Sidebar
        Container(
          width: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 200,
            tablet: 250,
            desktop: 300,
          ),
          decoration: BoxDecoration(
            color: theme.colors.primary,
            boxShadow: [
              BoxShadow(
                color: theme.colors.shadow,
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 20,
                  tablet: 30,
                  desktop: 50,
                ),
              ),
              ResponsiveText(
                'Blood Lab',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                  fontWeight: FontWeight.bold,
                  color: theme.colors.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 20,
                  tablet: 30,
                  desktop: 40,
                ),
              ),
              const Divider(color: Colors.white54),
              Expanded(
                child: Column(
                  children: _buildNavigationItems(context, provider, theme),
                ),
              ),
              // Theme toggle at bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(
                    theme.isLightTime ? Icons.dark_mode : Icons.light_mode,
                    color: theme.colors.onPrimary,
                    size: 28,
                  ),
                  onPressed: () => theme.toggleTheme(),
                ),
              ),
            ],
          ),
        ),
        // Main Content Area
        Expanded(child: _buildBody(context, provider, theme)),
      ],
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return Drawer(
      backgroundColor: theme.colors.primary,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colors.primary),
            child: ResponsiveText(
              'Blood Lab',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
                fontWeight: FontWeight.bold,
                color: theme.colors.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ..._buildNavigationItems(context, provider, theme),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return [
      NavItem(
        icon: Iconsax.home_1,
        label: 'Dashboard',
        isSelected: provider.currentIndex == 0,
        onTap: () => provider.currentIndex = 0,
      ),
      NavItem(
        icon: Iconsax.user_search,
        label: 'Pending Requests',
        isSelected: provider.currentIndex == 1,
        onTap: () => provider.currentIndex = 1,
      ),
      NavItem(
        icon: Iconsax.verify,
        label: 'Active Requests',
        isSelected: provider.currentIndex == 2,
        onTap: () => provider.currentIndex = 2,
      ),
      NavItem(
        icon: Iconsax.tick_circle,
        label: 'Completed Tests',
        isSelected: provider.currentIndex == 3,
        onTap: () => provider.currentIndex = 3,
      ),
      NavItem(
        icon: Iconsax.document_text,
        label: 'Test Requests',
        isSelected: provider.currentIndex == 4,
        onTap: () => provider.currentIndex = 4,
      ),
      NavItem(
        icon: Icons.settings,
        label: 'Settings',
        isSelected: false,
        onTap: () {},
      ),
    ];
  }

  Widget _buildBody(
    BuildContext context,
    NavigatorProvider provider,
    AppTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const TopBar(),
        Padding(
          padding: ResponsiveHelper.getResponsivePadding(
            context,
            mobile: const EdgeInsets.all(8.0),
            tablet: const EdgeInsets.all(12.0),
            desktop: const EdgeInsets.all(16.0),
          ),
          child: Custombutton(
            text: "Add New Request",
            onTap: () => _showAddRequestDialog(context),
          ),
        ),
        Expanded(child: _buildCurrentScreen(provider)),
      ],
    );
  }

  Widget _buildCurrentScreen(NavigatorProvider provider) {
    switch (provider.currentIndex) {
      case 0:
        return DashboardContent();
      case 1:
        return PendingScreen();
      case 2:
        return AcceptedRequestsScreen();
      case 3:
        return CompleteScreen();
      case 4:
        return TestRequestsScreen();
      default:
        return DashboardContent();
    }
  }

  void _showAddRequestDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController patientNameController = TextEditingController();
    final TextEditingController testTypeController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    String urgency = 'Normal';

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
                    "Create Test Request",
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
                        validator:
                            (value) =>
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
                        validator:
                            (value) => value!.isEmpty ? 'Enter location' : null,
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
                        validator:
                            (value) =>
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
                        items:
                            ['Normal', 'Urgent'].map((String value) {
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
                            // Get the test request provider
                            final testRequestProvider =
                                Provider.of<TestRequestProvider>(
                                  context,
                                  listen: false,
                                );

                            // Close dialog first
                            Navigator.pop(context);

                            // Create test request
                            final formLink = await testRequestProvider
                                .createTestRequest(
                                  patientName: patientNameController.text,
                                  location: locationController.text,
                                  bloodTestType: testTypeController.text,
                                  urgency: urgency,
                                  context: context,
                                );

                            // Show link share dialog if successful
                            if (formLink != null) {
                              await showDialog(
                                context: context,
                                builder:
                                    (context) => LinkShareDialog(
                                      formLink: formLink,
                                      patientName: patientNameController.text,
                                      testType: testTypeController.text,
                                    ),
                              );
                            }

                            // Clear controllers
                            patientNameController.clear();
                            locationController.clear();
                            testTypeController.clear();
                          }
                        },
                        text: 'Send Request',
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
}
