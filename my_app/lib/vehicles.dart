import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:my_app/face.dart';
import 'package:my_app/idk.dart';
import 'package:my_app/manage_profile.dart';
import 'package:my_app/wallet2.dart';
import 'package:my_app/welcome.dart';
import 'dart:convert';
import 'inside_vehicle.dart';

class VehiclesScreen extends StatefulWidget {
  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  int _selectedTabIndex = 0; // 0 -> Two Wheelers, 1 -> Cars
  bool _isLoading = true;
  List<Map<String, dynamic>> twoWheelers = [];
  List<Map<String, dynamic>> cars = [];
  Position? _currentPosition;
  bool _locationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location permission on load
  }

Future<void> _fetchVehicles() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Constructing the URL with or without location data
    String url = 'https://60a5-2402-a00-405-e1a3-4900-1065-4a70-db1d.ngrok-free.app/fetch_ev';
    // if (_currentPosition != null) {
    //   url += '?type=scooter';
    // }

    // Add type filter based on selected tab
    String type = _selectedTabIndex == 0 ? '' : 'car';
    // url += _currentPosition != null ? '&type=$type' : '?type=$type';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> vehicles = data['data'];

      // Filter vehicles based on ev_type
      List<dynamic> carVehicles = vehicles.where((v) => v['ev_type'] == "car").toList();
      List<dynamic> bikeVehicles = vehicles.where((v) => v['ev_type'] != "car").toList();

      // Update the appropriate list based on the selected tab
      setState(() {
        // For two-wheelers tab
        twoWheelers = bikeVehicles
            .map(
              (v) => {
                "brand": v['brand_name'],
                "model": v['model'],
                "image": v['image'],
                "buttonText": v['status'] == 'available' ? "Book Now" : "Join Waitlist",
              },
            )
            .toList()
            .cast<Map<String, dynamic>>();

        // For cars tab
        cars = carVehicles
            .map(
              (v) => {
                "brand": v['brand_name'],
                "model": v['model'],
                "image": v['image'],
                "buttonText": v['availability'] == 'available' ? "Book Now" : "Join Waitlist",
              },
            )
            .toList()
            .cast<Map<String, dynamic>>();
      });
    } else {
      // Use default data if API fails
      _loadDefaultData();
    }
  } catch (e) {
    print('Error fetching vehicles: $e');
    // Use default data if API fails
    _loadDefaultData();
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  void _loadDefaultData() {
    // Fallback to hardcoded data if API fails
    if (_selectedTabIndex == 0) {
      twoWheelers = [
        {
          "brand": "Ather",
          "model": "450x Gen 3",
          "image": "https://picsum.photos/200",
          "buttonText": "Book Now",
        },
        {
          "brand": "TVS",
          "model": "i QUBE",
          "image": "https://picsum.photos/200",
          "buttonText": "Book Now",
        },
        {
          "brand": "Vida",
          "model": "V1 Pro",
          "image": "https://picsum.photos/200",
          "buttonText": "Book Now",
        },
        {
          "brand": "Ola Electric",
          "model": "S1",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
        {
          "brand": "Revolt",
          "model": "RV400",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
      ];
    } else {
      cars = [
        {
          "brand": "MG",
          "model": "ZS EV",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
        {
          "brand": "Tata",
          "model": "Nexon EV",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
        {
          "brand": "Tata",
          "model": "Tigor EV",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
        {
          "brand": "Hyundai",
          "model": "Kona EV",
          "image": "https://picsum.photos/200",
          "buttonText": "Join Waitlist",
        },
      ];
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          _locationPermissionDenied = true;
        });
        // Still fetch data even if location permission is denied
        _fetchVehicles();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationPermissionDenied = true;
      });
      // Still fetch data even if location permission is denied forever
      _fetchVehicles();
      return;
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationPermissionDenied = false;
      });

      // Fetch vehicles with location data
      _fetchVehicles();
    } catch (e) {
      print('Error getting location: $e');
      // Fetch data even if there's an error getting location
      _fetchVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("VEHICLES", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
    IconButton(
      icon: Icon(Icons.account_balance_wallet, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FaceVerificationScreen()),
        );
      },
    ),
    IconButton(
      icon: Icon(Icons.person, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageProfileScreen()),
        );
      },
    ),
  ],
      ),
      drawer: _buildDrawer(context),
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

          // Location Status Indicator (optional, can remove if not needed)
          if (_locationPermissionDenied)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Using default location. Enable location for nearby vehicles.",
                style: TextStyle(color: Colors.blue[700], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),

          // Vehicle List
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount:
                          _selectedTabIndex == 0
                              ? twoWheelers.length
                              : cars.length,
                      itemBuilder: (context, index) {
                        var vehicle =
                            _selectedTabIndex == 0
                                ? twoWheelers[index]
                                : cars[index];
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
          _fetchVehicles(); // Refetch when tab changes
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

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AtherScooterScreen(
                  brand: vehicle["brand"],
                  model: vehicle["model"],
                  image: vehicle["image"],
                  buttonText: vehicle["buttonText"],
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              /// Vehicle Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  vehicle["image"],
                  height: 80,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      width: 120,
                      color: Colors.grey[300],
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),

              /// Vehicle Details
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

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sidebar Drawer implementation similar to MainScreen
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // User Profile Section
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.network(
                'https://via.placeholder.com/100', // Replace with actual profile image
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              "Jay Shah",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              "9723557662",
              style: TextStyle(color: Colors.black54),
            ),
          ),

          // Drawer Items
          _buildDrawerItem(context, Icons.dashboard, "DASHBOARD", 0),
          _buildDrawerItem(context, Icons.person, "PROFILE", 1),
          _buildDrawerItem(context, Icons.subscriptions, "SUBSCRIPTIONS", 2),
          _buildDrawerItem(context, Icons.directions_car, "VEHICLES", 3),
          _buildDrawerItem(context, Icons.info, "ABOUT", 4),
          _buildDrawerItem(context, Icons.location_on, "CHANGE LOCATION", 5),

          Divider(),

          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("LOGOUT", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Implement Logout Logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (index != 3) { // If not vehicles (current screen)
          // Navigate to the corresponding screen
          // This is a simplified navigation - you'll need to adapt this based on your app structure
          switch (index) {
            case 0:
              // Navigate to Dashboard
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              // Navigate to Profile
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 2:
              // Navigate to Subscriptions
              Navigator.pushReplacementNamed(context, '/subscriptions');
              break;
            case 4:
              // Navigate to About
              Navigator.pushReplacementNamed(context, '/about');
              break;
            case 5:
              // Navigate to Change Location
              Navigator.pushReplacementNamed(context, '/location');
              break;
          }
        }
      },
    );
  }
} 