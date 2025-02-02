import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login.dart';
import 'package:intl/intl.dart';
import './appointmentsPage.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';
  String? imageUrl;
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _getCurrentDate();
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
            imageUrl = userDoc.get('imageUrl');
          });
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat dateFormat = DateFormat("MM-dd-yyyy EEEE");
    setState(() {
      currentDate = dateFormat.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "GoogleSans",
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl!)
                        : AssetImage(
                        'assets/Images/avatar.png') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "GoogleSans",
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: "GoogleSans"),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/doctor-profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontFamily: "GoogleSans"),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(20.0), child:Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                          Icons.calendar_today, color: Colors.blue, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        currentDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "GoogleSans",
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 15),
              // Welcome Message
                Card(
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome, Dr. $userName!",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "GoogleSans",
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "You're managing your appointments and patient care.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "GoogleSans",
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/Images/dentist1.jpg',
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              Row(
                  children: [
                    // Appointments Section
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppointmentsPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Ensures content is centered
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white, size: 30),
                              const SizedBox(height: 15),
                              const Text(
                                'View Appointments',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "GoogleSans",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Spacer between containers
                    const SizedBox(width: 10),

                    // Patient Query Section
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.question_answer, color: Colors.white, size: 30),
                            const SizedBox(height: 15),
                            const Text(
                              'Patient Queries',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "GoogleSans",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),),
    );
  }
}
