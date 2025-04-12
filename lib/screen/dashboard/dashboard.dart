import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:labtest/main.dart';
import 'package:labtest/provider/navigatorprodiver.dart';
import 'package:labtest/screen/active_screen/active_screen.dart';
import 'package:labtest/screen/dashboard/Topappbar.dart';
import 'package:labtest/screen/dashboard/dashboardContent.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/Navitem.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/widget/starCards.dart';
import 'package:provider/provider.dart';

class BloodLabHomePage extends StatelessWidget {
  const BloodLabHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NavigatorProvider>(context);
    return Myscaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 900;

          if (isWideScreen) {
            return Row(
              children: [
                SizedBox(
                  width: 250,
                  child: Material(
                    color: Colors.blue.shade500,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          'Blood Lab',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'uber',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        NavItem(
                          icon: Iconsax.home_1,
                          label: 'Dashboard',
                          onTap: () {
                            provider.currentIndex = 0;
                          },
                        ),
                        NavItem(
                          icon: Iconsax.user_search,
                          label: 'Pending Requests',
                          onTap: () {
                            provider.currentIndex = 1;
                          },
                        ),
                        NavItem(
                          icon: Iconsax.verify,
                          label: 'Active Requests',
                          onTap: () {},
                        ),
                        NavItem(
                          icon: Iconsax.tick_circle,
                          label: 'Completed Tests',
                          onTap: () {},
                        ),
                        NavItem(
                          icon: Iconsax.user_tick,
                          label: 'Flavo History',
                          onTap: () {},
                        ),
                        NavItem(
                          icon: Icons.settings,
                          label: 'Settings',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                // Main Content Area
                Flexible(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const TopBar(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Custombutton(
                              text: "Add New Request",
                              onTap: () => _showAddRequestDialog(context)),
                        ), // Custom widget for top bar

                        if (provider.currentIndex == 0)
                          const DashboardContent()
                        else if (provider.currentIndex == 1)
                          Flexible(flex: 1, child: AcceptedRequestsScreen()),
                      ]),
                ),
              ],
            );
          } else {
            // Mobile/Tablet: Use a drawer for navigation
            return Scaffold(
              appBar: AppBar(
                  title: const Text(
                'Blood Lab',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'uber',
                ),
              )),
              drawer: Drawer(
                backgroundColor: Colors.blue.shade500,
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade500,
                      ),
                      child: const Center(
                        child: Text(
                          'Blood Lab',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'uber',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    NavItem(
                      icon: Iconsax.home_1,
                      label: 'Dashboard',
                      onTap: () {
                        provider.currentIndex = 0;
                      },
                    ),
                    NavItem(
                      icon: Iconsax.user_search,
                      label: 'Pending Requests',
                      onTap: () {
                        provider.currentIndex = 1;
                      },
                    ),
                    NavItem(
                      icon: Iconsax.verify,
                      label: 'Active Requests',
                      onTap: () {},
                    ),
                    NavItem(
                      icon: Iconsax.tick_circle,
                      label: 'Completed Tests',
                      onTap: () {},
                    ),
                    NavItem(
                      icon: Iconsax.user_tick,
                      label: 'Flavo History',
                      onTap: () {},
                    ),
                    NavItem(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const TopBar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Custombutton(
                        text: "Add New Request",
                        onTap: () => _showAddRequestDialog(context)),
                  ),

                  if (provider.currentIndex == 0)
                    const DashboardContent()
                  else if (provider.currentIndex == 1)
                    Flexible(child: AcceptedRequestsScreen()),
                  // NotificationListener(child: ))
                ],
              ),
            );
          }
        },
      ),
    );
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
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add Collection Request",
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontSize: 15,
                  )),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Iconsax.close_square,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ],
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: 300,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Customtextfield(
                  controller: patientNameController,
                  // decoration: const InputDecoration(labelText: "Patient Name"),
                  hintText: "Patient Name",
                  validator: (value) =>
                      value!.isEmpty ? 'Enter patient name' : null,
                ),
                const SizedBox(height: 16),
                Customtextfield(
                  controller: testTypeController,
                  // decoration: const InputDecoration(labelText: "Test Type"),
                  hintText: "Test Type",
                  validator: (value) =>
                      value!.isEmpty ? 'Enter test type' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                  ),

                  // decoration: const InputDecoration(labelText: "Urgency"),

                  value: urgency,
                  hint: const Text(
                    "Urgency",
                    style: TextStyle(color: Colors.grey, fontFamily: 'uber'),
                  ),
                  items: ['Normal', 'Urgent'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontFamily: 'uber', fontWeight: FontWeight.bold),
                        ));
                  }).toList(),
                  onChanged: (newValue) {
                    urgency = newValue!;
                  },

                  focusColor: Colors.white,
                ),
                const SizedBox(height: 16),
                Customtextfield(
                  controller: locationController,
                  // decoration: const InputDecoration(labelText: "Location"),
                  hintText: "Location",
                  validator: (value) =>
                      value!.isEmpty ? 'Enter location' : null,
                ),
                const SizedBox(height: 16),
                Custombutton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission (e.g., save to database)
                      Navigator.pop(context);
                    }
                  },
                  text: 'Add Request',
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
