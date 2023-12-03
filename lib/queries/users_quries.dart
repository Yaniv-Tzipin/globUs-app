import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/providers/my_tags_provider.dart';

class UserQueries {
  static List<String> usersTagsToString = [];

  static void updateUsersCollection(
      bool email, bool username, bool birthdate, bool bio) {}

// setters
  static Future<void> updateEmail(String email) async {
    await FirebaseFirestore.instance.collection('users').add({'email': email});
  }

  static Future<void> updateUsername(String username) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'username': username});
  }

  static Future<void> updateBirthdate(Timestamp birthdate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'birth_date': birthdate});
  }

  static Future<void> updateBio(String bio) async {
    await FirebaseFirestore.instance.collection('users').add({'bio': bio});
  }

  static Future<void> addNewUser(String email, String username,
      Timestamp birthdate, String bio, String country) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'email': email,
      'username': username,
      'birth_date': birthdate,
      'bio': bio,
      'tags': usersTagsToString,
      'country': country,
      'matches': [],
      'swipedRight': [],
      'swipedLeft': [],
      'status': 'Online'
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

  static Future<void> updateCurrentLocation(String lat, String long) async {
    String currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentEmail)
          .set({'latitude': lat, 'longitude': long}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> loadPreferences() async {
    String currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    Map<String, dynamic> preferences;
    try {
      preferences = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentEmail)
          .get()
          .then((snapshot) {
        return snapshot.data()!['preferences'];
      });
    } catch (e) {
      print(e);
      return {
        'Age': 0.0,
        'Location': 0.0,
        'Origin country': 0.0,
        'Other Party Swipe': 0.0,
        'Shared tags': 0.0
      };
    }
    return preferences;
  }

  static Future<void> updatePreferences(
      Map<String, dynamic> preferences) async {
    String currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentEmail)
          .set({'preferences': preferences}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addEndorsement(
      String endorsedEmail, String endoresementContent) async {
    String currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    String currentUsername = await getUsername(currentEmail);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(endorsedEmail)
          .set({
        'endorsements': FieldValue.arrayUnion([
          {
            'writerEmail': currentEmail,
            'writerUsername': currentUsername,
            'endorsementTime': Timestamp.now(),
            'endorsementContent': endoresementContent
          }
        ])
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  static Future<List<dynamic>> getEndorsements(String email) async {
    List<dynamic> endorsements;
    try {
      endorsements = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((snapshot) {
        return snapshot.data()!['endorsements'];
      });
    } catch (e) {
      return [];
    }
    return endorsements;
  }

  static Future<String> getUsername(String email) async {
    String currentUsername;
    try {
      currentUsername = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((snapshot) {
        return snapshot.data()!['username'];
      });
    } catch (e) {
      return e.toString();
    }
    return currentUsername;
  }
}
