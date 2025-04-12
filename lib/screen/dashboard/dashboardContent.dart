import 'package:flutter/material.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/widget/starCards.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example stats and upcoming appointments
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row of cards for stats
          LayoutBuilder(
            builder: (context, constraints) {
              bool isNarrow = constraints.maxWidth < 600;
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 16,
                  // runSpacing: 16,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: [
                    StatCard(
                      title: 'Active Requests',
                      value: '120',
                      color: Colors.red.shade100,
                    ),
                    StatCard(
                      title: 'Pending Tests',
                      value: '35',
                      color: Colors.orange.shade100,
                    ),
                    StatCard(
                      title: 'Completed Tests',
                      value: '210',
                      color: Colors.green.shade100,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Upcoming surgeries or appointments
          Card(
            color: Colors.white,
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Upcoming Appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "uber",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Gilbert Sandoval',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Blood Test - 9:30 AM',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Sofia Velasquez',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Consultation - 10:15 AM',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Emma Johnson',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Surgery - 11:00 AM',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "uber",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
