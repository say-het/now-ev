import 'package:flutter/material.dart';
import 'package:my_app/vehicles.dart';

class BookedRides extends StatelessWidget {
  final Map<String, String> userDetails = {
    "Name": "John Doe",
    "Email": "johndoe@example.com",
    "Phone": "+91 9876543210",
    "Subscription": "Premium Plan",
    "Next Billing Date": "April 15, 2025",
    "Current Vehicle": "Tesla Model 3",
    "Booking Status": "Active",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "USER DASHBOARD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.directions_car, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VehiclesScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 User Profile Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green[700],
                    radius: 40,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userDetails["Name"]!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userDetails["Email"]!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 🔹 User Details List
            Expanded(
              child: ListView.builder(
                itemCount: userDetails.length - 1, // Skipping Name & Email (already shown above)
                itemBuilder: (context, index) {
                  String key = userDetails.keys.elementAt(index + 2); // Start from index 2
                  return _buildDetailCard(key, userDetails[key]!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Single Detail Card (Similar to Vehicles List)
  Widget _buildDetailCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
