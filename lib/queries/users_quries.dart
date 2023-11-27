import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/globals.dart';

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

  static Future<void> addMatch(String currentEmail, String matchEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'matches': FieldValue.arrayUnion([matchEmail])
    }, SetOptions(merge: true));
  }

  static Future<void> addSwipedRight(
      String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedRight': FieldValue.arrayUnion([otherEmail])
    }, SetOptions(merge: true));
  }

  static Future<void> addSwipedLeft(
      String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedLeft': FieldValue.arrayUnion([otherEmail])
    }, SetOptions(merge: true));
  }

  static Future<void> deleteMatch(
      String currentEmail, String matchEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'matches': FieldValue.arrayRemove([matchEmail])
    }, SetOptions(merge: true));
  }

  static Future<void> deleteSwipedRight(
      String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedRight': FieldValue.arrayRemove([otherEmail])
    }, SetOptions(merge: true));
  }

  static Future<void> deleteSwipedLeft(
      String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedLeft': FieldValue.arrayRemove([otherEmail])
    }, SetOptions(merge: true));
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
  static Future<String> getEmail() async {
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

  static Future<List<dynamic>> getSwipedRight(String email) async {
    List<dynamic> swipedRight;
    try {
      swipedRight = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((snapshot) {
        return snapshot.data()!['swipedRight'];
      });
    } catch (e) {
      print(e);
      return [];
    }
    return swipedRight;
  }

  static Future<List<dynamic>> getSwipedLeft(String email) async {
    List<dynamic> swipedLeft;
    try {
      swipedLeft = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((snapshot) {
        return snapshot.data()!['swipedLeft'];
      });
    } catch (e) {
      print(e);
      return [];
    }
    return swipedLeft;
  }

  static Future<List<dynamic>> getMatches(String email) async {
    List<dynamic> matches;
    try {
      matches = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .then((snapshot) {
        return snapshot.data()!['matches'];
      });
    } catch (e) {
      print(e);
      return [];
    }
    return matches;
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
}
