import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/providers/my_tags_provider.dart';

class UserQueries{

static List<String> usersTagsToString = [];



static void updateUsersCollection(
bool email, bool username, bool birthdate, bool bio) {}

// setters
static Future <void> updateEmail(String email) async {
await FirebaseFirestore.instance.collection('users').add({'email': email});
}

static Future  <void> updateUsername(String username) async {
await FirebaseFirestore.instance
.collection('users')
.add({'username': username});
}

static Future  <void> updateBirthdate(Timestamp birthdate) async {
await FirebaseFirestore.instance
.collection('users')
.add({'birth_date': birthdate});
}

static Future  <void> updateBio(String bio) async {
await FirebaseFirestore.instance.collection('users').add({'bio': bio});
}

static Future  <void> addNewUser(
String email, String username, String birthdate, String bio, String country) async {
await FirebaseFirestore.instance.collection('users').doc(email).set({
'email': email,
'username': username,
'birth_date': birthdate,
'bio': bio,
'tags': usersTagsToString,
'country': country
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

}