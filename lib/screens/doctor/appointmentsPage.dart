import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/appointmentModel.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(fontFamily: "GoogleSans",fontSize: 18, color: Colors.white,),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('appointmentTime')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!.docs
              .map((doc) => Appointment.fromDocument(doc))
              .toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final formattedDate = appointment.appointmentTime.toString();

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        'Patient: ${appointment.patientName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "GoogleSans",
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Appointment Time: $formattedDate',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "GoogleSans",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Age: ${appointment.patientAge}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "GoogleSans",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Concern: ${appointment.patientIssue}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "GoogleSans",
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
