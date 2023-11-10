// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/login_or_register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  //sign user out method
  void signUserOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginOrRegisterPage()));
    // Removing the prefernces because the user logged out
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("loggedIn");  
    pref.remove("email");   
  }

  @override
  Widget build(BuildContext context
  ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {signUserOut(context);}, icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: Text('LOGGED IN',
              style: TextStyle(fontSize: 20))),
    );
  }
}
