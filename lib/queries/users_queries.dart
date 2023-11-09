import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void updateUsersCollection(
    bool email, bool username, bool birthdate, bool bio) {}

// setters
Future <void> updateEmail(String email) async {
  await FirebaseFirestore.instance.collection('users').add({'email': email});
}

Future <void> updateUsername(String username) async {
  await FirebaseFirestore.instance
      .collection('users')
      .add({'username': username});
}

Future <void> updateBirthdate(Timestamp birthdate) async {
  await FirebaseFirestore.instance
      .collection('users')
      .add({'birth_date': birthdate});
}

Future <void> updateBio(String bio) async {
  await FirebaseFirestore.instance.collection('users').add({'bio': bio});
}

// Future addNewUser(
//     String email, String username, String birthdate, String bio) async {
//   await FirebaseFirestore.instance.collection('users').add({
//     'email': email,
//     'username': username,
//     'birth_date': birthdate,
//     'bio': bio
//   });
// }

Future <void> addNewUser(
    String email, String username, String birthdate, String bio) async {
  await FirebaseFirestore.instance.collection('users').doc(email).set({
    'email': email,
    'username': username,
    'birth_date': birthdate,
    'bio': bio
  });
}

// getters
Future<String> getEmail() async {
  try {
    String email = await FirebaseFirestore.instance
        .collection('users')
        .where('email',
            isEqualTo: FirebaseAuth.instance.currentUser?.email ?? "")
        .get()
        .toString();
    return email;
  } catch (e) {
    return e.toString();
  }
}
