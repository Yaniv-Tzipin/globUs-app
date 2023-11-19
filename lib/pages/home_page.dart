// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/pages/profile_page.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';

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
  int totalUnread = 0;

  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //sign user out method, snapshot loosing data
  void signUserOut() {
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
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
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
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          Stack(
            children: [
              NavigationDestination(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              Positioned(
                right: 30,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: 
                    totalUnreadMessagesCount(
                  ),
                ),
              )
            ],
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
  //this method shows how many unread messages the user have
  Widget totalUnreadMessagesCount() {
    String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
    int currentUnread = 0;
    totalUnread = 0;
    return StreamBuilder(
        stream: _chatService.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          try {
            // from all the docs (chatRoom ids) get just those that
            // contain the current username. These are the chats he is part of
            var currentDocs = snapshot.data!.docs
                .where((element) => element.id.contains(currentUserMail));
            for (var doc in currentDocs.toSet()) {
              // getting the number of unread messages
              try {
                Map infoDict = doc.data() as Map;
                currentUnread = infoDict['${currentUserMail}_unread'];
                // if (currentUnread > 0)
                // {
                //   print(doc.id);
                //   print(currentUnread);
                // }
                totalUnread += currentUnread;
              } catch (e) {
                currentUnread = 0;
              }
            }
            return Text(
              totalUnread.toString(),
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
              ),
            );
          } catch (e) {
            return Text('');
          }
        });
  }
}
