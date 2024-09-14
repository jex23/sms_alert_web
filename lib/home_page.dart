import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'color_codes_page.dart';
import 'sms_reports_page.dart';
import 'generate_reports_page.dart';
import 'user_home_page.dart'; // Separate file for the 'Home' section
import 'login_page.dart'; // Ensure you import the LoginPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<Map<String, dynamic>?> _userInfoFuture;
  PageController pageController = PageController();
  SideMenuController sideMenuController = SideMenuController();

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _getUserInfo();

    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  Future<Map<String, dynamic>?> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  void _refreshData() {
    setState(() {
      _userInfoFuture = _getUserInfo();
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();
      // Navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Handle any errors that might occur during sign-out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Side Menu
          SideMenu(
            controller: sideMenuController,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: FutureBuilder<Map<String, dynamic>?>(
              future: _userInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading user info.'));
                } else if (snapshot.data == null) {
                  return Center(child: Text('No user data found.'));
                } else {
                  var userData = snapshot.data!;
                  String profileImageUrl = userData['profile_image_url'] ?? '';

                  return Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            profileImageUrl.isNotEmpty
                                ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(profileImageUrl),
                            )
                                : CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person, size: 50),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${userData['first_name'] ?? 'User'} ${userData['last_name'] ?? ''}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(
                    '© 2024 SMS Web App',
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Home',
                onTap: (index, _) {
                  sideMenuController.changePage(0);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                title: 'Color Codes',
                onTap: (index, _) {
                  sideMenuController.changePage(1);
                },
                icon: const Icon(Icons.palette),
              ),
              SideMenuItem(
                title: 'SMS Reports',
                onTap: (index, _) {
                  sideMenuController.changePage(2);
                },
                icon: const Icon(Icons.message),
              ),
              SideMenuItem(
                title: 'Generate Reports',
                onTap: (index, _) {
                  sideMenuController.changePage(3);
                },
                icon: const Icon(Icons.report),
              ),
              SideMenuItem(
                title: 'Logout',
                onTap: (index, _) {
                  _showLogoutDialog();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                UserHomePage(), // 'Home' section
                ColorCodesPage(), // 'Color Codes' section
                SMSReportsPage(), // 'SMS Reports' section
                GenerateReportsPage(), // 'Generate Reports' section
              ],
            ),
          ),
        ],
      ),
    );
  }
}
