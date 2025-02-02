import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tooth_tales/screens/user/patientProfile.dart';
import '../login.dart';
import '../footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';
  ScrollController _scrollController = ScrollController(); // Added ScrollController

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('userName');
          });
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Homepage',
          style: TextStyle(fontFamily: 'GoogleSans'),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              }).catchError((e) {
                print('Error signing out: $e');
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName.isNotEmpty ? 'Hello, $userName!' : 'Hello!',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'GoogleSans'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Do oral examinations and consult our best dentists.',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'GoogleSans'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Articles', style: TextStyle(fontFamily: 'GoogleSans')),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/articles');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile', style: TextStyle(fontFamily: 'GoogleSans')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout', style: TextStyle(fontFamily: 'GoogleSans')),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                  );
                }).catchError((e) {
                  print('Error signing out: $e');
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.isNotEmpty ? 'Hello, $userName!' : 'Hello!',
                          style: TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'GoogleSans'),
                        ),
                        Text(
                          'Do oral examinations and consult our best dentists.',
                          style: TextStyle(fontSize: 18, color: Colors.white70, fontFamily: 'GoogleSans'),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                        );
                      }).catchError((e) {
                        print('Error signing out: $e');
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, // Attach ScrollController here
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      buildFeatureTile(context, Icons.calendar_today, "Book an Appointment", '/doctor'),
                      buildFeatureTile(context, Icons.list_alt, "My Appointments", '/schedule'),
                      buildFeatureTile(context, Icons.health_and_safety, "Oral Examination", '/oralexamination'),
                      SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: () {
                          // Add the functionality for the button here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                        ),
                        child: Text(
                          'Ask Questions',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'GoogleSans'),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterScreen(),
    );
  }

  Widget buildFeatureTile(BuildContext context, IconData icon, String title, String route) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Container(
          width: 380,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlue,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'GoogleSans'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
