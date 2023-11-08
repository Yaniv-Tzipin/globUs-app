import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userEmail).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist for email: ${userEmail}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ProfileData(data);
        }

        return Text("loading...");
      },
    );
  }
}

class ProfileData extends StatelessWidget {
  Map<String, dynamic> userData = <String, dynamic>{};

  ProfileData(Map<String, dynamic> data) {
    userData = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: Text("PROFILE first name: ${userData['first_name']}")),
    );
  }
}
