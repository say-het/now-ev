import 'package:flutter/material.dart';

class VehiclesScreen extends StatefulWidget {
  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  int _selectedTabIndex = 0; // 0 -> Two Wheelers, 1 -> Cars

  final List<Map<String, dynamic>> twoWheelers = [
    {
      "brand": "Ather",
      "model": "450x Gen 3",
      "image": "https://picsum.photos/200", // Replace with actual image
      "buttonText": "Book Now"
    },
    {
      "brand": "TVS",
      "model": "i QUBE",
      "image": "https://picsum.photos/200",
      "buttonText": "Book Now"
    },
    {
      "brand": "Vida",
      "model": "V1 Pro",
      "image": "https://picsum.photos/200",
      "buttonText": "Book Now"
    },
    {
      "brand": "Ola Electric",
      "model": "S1",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
    {
      "brand": "Revolt",
      "model": "RV400",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
  ];

  final List<Map<String, dynamic>> cars = [
    {
      "brand": "MG",
      "model": "ZS EV",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
    {
      "brand": "Tata",
      "model": "Nexon EV",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
    {
      "brand": "Tata",
      "model": "Tigor EV",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
    {
      "brand": "Hyundai",
      "model": "Kona EV",
      "image": "https://picsum.photos/200",
      "buttonText": "Join Waitlist"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "VEHICLES",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Navigate to Profile
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton("TWO WHEELERS", 0),
                _buildTabButton("CARS", 1),
              ],
            ),
          ),
          Divider(color: Colors.black, thickness: 1),

          // Vehicle List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _selectedTabIndex == 0 ? twoWheelers.length : cars.length,
              itemBuilder: (context, index) {
                var vehicle = _selectedTabIndex == 0 ? twoWheelers[index] : cars[index];
                return _buildVehicleCard(vehicle);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to build Tab Buttons
  Widget _buildTabButton(String text, int index) {
    bool isActive = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.green : Colors.black,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 3,
              width: 60,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

  // Function to build a vehicle card
  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Vehicle Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                vehicle["image"],
                height: 80,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),

            // Vehicle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle["brand"],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    vehicle["model"],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Join Waitlist or Book Now Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Handle booking or waitlist action
                    },
                    icon: Icon(Icons.flash_on, color: Colors.white, size: 18),
                    label: Text(
                      vehicle["buttonText"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
