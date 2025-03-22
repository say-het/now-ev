import 'package:flutter/material.dart';
import 'package:my_app/booked_rides.dart';
import 'package:my_app/end.dart';
import 'package:my_app/forgot_password.dart';
import 'package:my_app/launch.dart';
import 'package:my_app/login_signup.dart';
import 'package:my_app/manage_profile.dart';
import 'package:my_app/p.dart';
import 'package:my_app/phone_auth.dart';
import 'package:my_app/select_city.dart';
import 'package:my_app/splash_screen.dart';
import 'package:my_app/vehicles.dart';
import 'package:my_app/wallet2.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VehiclesScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate
  final List<Widget> _screens = [
    DashboardScreen(),
    ProfileScreen(),
    SubscriptionsScreen(),
    VehiclesScreen(),
    AboutScreen(),
    ChangeLocationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close Drawer after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(_getAppBarTitle(_selectedIndex)), // Dynamic title
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: _screens[_selectedIndex], // Display the selected screen
    );
  }

  // Function to get the AppBar title based on selected index
  String _getAppBarTitle(int index) {
    List<String> titles = [
      "Dashboard",
      "Profile",
      "Subscriptions",
      "Vehicles",
      "About Swytchd",
      "Change Location"
    ];
    return titles[index];
  }

  // Sidebar Drawer
  Widget _buildDrawer() {
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
          _buildDrawerItem(Icons.dashboard, "DASHBOARD", 0),
          _buildDrawerItem(Icons.person, "PROFILE", 1),
          _buildDrawerItem(Icons.subscriptions, "SUBSCRIPTIONS", 2),
          _buildDrawerItem(Icons.directions_car, "VEHICLES", 3),
          _buildDrawerItem(Icons.info, "ABOUT SWYTCHD", 4),
          _buildDrawerItem(Icons.location_on, "CHANGE LOCATION", 5),

          Divider(),

          // Logout Button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("LOGOUT", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Implement Logout Logic
            },
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () => _onItemTapped(index),
    );
  }
}

// Placeholder Screens with Real UI
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text("Welcome to the Dashboard",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text("Jay Shah"),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.black),
            title: Text("jay.s7@ahduni.edu.in"),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.black),
            title: Text("9723557662"),
          ),
        ],
      ),
    );
  }
}

class SubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Your Subscriptions will appear here.",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// class VehiclesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.directions_car, size: 100, color: Colors.green),
//           SizedBox(height: 20),
//           Text("Manage Your Vehicles",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Swytchd",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            "Swytchd is a platform that provides hassle-free vehicle "
            "subscriptions, allowing you to switch cars as per your needs.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ChangeLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 100, color: Colors.red),
          SizedBox(height: 20),
          Text("Update Your Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
