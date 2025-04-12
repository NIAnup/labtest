import 'package:flutter/material.dart';

class AcceptedRequestsScreen extends StatefulWidget {
  @override
  _AcceptedRequestsScreenState createState() => _AcceptedRequestsScreenState();
}

class _AcceptedRequestsScreenState extends State<AcceptedRequestsScreen> {
  List<Map<String, dynamic>> acceptedRequests = [
    {
      'name': 'John Doe',
      'phone': '123-456-7890',
      'email': 'johndoe@example.com',
      'profilePic':
          'https://media.istockphoto.com/id/1392528328/photo/portrait-of-smiling-handsome-man-in-white-t-shirt-standing-with-crossed-arms.jpg?s=612x612&w=0&k=20&c=6vUtfKvHhNsK9kdNWb7EJlksBDhBBok1bNjNRULsAYs=',
      'status': 'Accepted'
    },
    {
      'name': 'Jane Smith',
      'phone': '987-654-3210',
      'email': 'janesmith@example.com',
      'profilePic':
          'https://media.istockphoto.com/id/1392528328/photo/portrait-of-smiling-handsome-man-in-white-t-shirt-standing-with-crossed-arms.jpg?s=612x612&w=0&k=20&c=6vUtfKvHhNsK9kdNWb7EJlksBDhBBok1bNjNRULsAYs=',
      'status': 'Accepted'
    },
  ];

  void showDetailsDialog(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Request Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(request['profilePic']),
                ),
                const SizedBox(height: 10),
                Text("Name: ${request['name']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "uber")),
                Text("Phone: ${request['phone']}",
                    style: const TextStyle(fontFamily: "uber")),
                Text("Email: ${request['email']}",
                    style: const TextStyle(fontFamily: "uber")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(fontFamily: "uber")),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(int index) {
    TextEditingController cancelReasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Request"),
          content: TextField(
            controller: cancelReasonController,
            decoration:
                const InputDecoration(labelText: "Reason for cancellation"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(fontFamily: "uber")),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  acceptedRequests.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Confirm Delete",
                  style: TextStyle(fontFamily: "uber")),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            // ✅ Correct placement
            child: ListView.builder(
              itemCount: acceptedRequests.length,
              itemBuilder: (context, index) {
                var request = acceptedRequests[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blue.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(request['profilePic']),
                          radius: screenWidth < 600 ? 30 : 40,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "uber")),
                              Text(request['phone'],
                                  style: const TextStyle(fontFamily: "uber")),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () => showDetailsDialog(request),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDeleteDialog(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
