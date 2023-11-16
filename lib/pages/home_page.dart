// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/pages/profile_page.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationExample();
  }
}

  
   
class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

   //sign user out method, snapshot loosing data
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(   
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey[800],
        leading: BackButton(color: Colors.grey[800]),
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: signUserOut,
           icon: Icon(Icons.logout)
           ),
          ],
        ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: ProfilePage(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page 2'), //TO ADD MATCHES GRID PAGE
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: MainChatPage(), 
        ),
      ][currentPageIndex],
    );
  }
}

