import 'package:flutter/material.dart';

// Top bar with user info, date, etc.

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getGreeting()}, Dr. Anup Singh',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "uber",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Today: Mar 19, 2025',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "uber",
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 20),
          Icon(Icons.notifications, color: Colors.red.shade700),
          const SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: Colors.red.shade200,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
