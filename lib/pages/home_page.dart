// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/pages/matching_board.dart';
import 'package:myfirstapp/pages/profile_page.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationExample();
  }
} 
   
class NavigationExample extends StatefulWidget{
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> with WidgetsBindingObserver {
  int currentPageIndex = 0;
  String pageTitle = "";
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  final userMail = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void setStatus(String status) async{
     await _fireStore.collection('users').doc(userMail).update({
      'status': status
    },);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      setStatus('Online');
    }
    else{
      setStatus('Offline');
    }
  }

  //sign user out method, snapshot loosing data
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(fontSize: 20,
        fontWeight: FontWeight.bold, color: Color.fromARGB(255, 139, 189, 139)),),
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey[800],
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
            //change the title of the tool bar according to the page
            if(currentPageIndex == 0){
              pageTitle = '';
            }
            if(currentPageIndex == 1){
              pageTitle = 'Find some travel partners';
            }
            if(currentPageIndex == 2){
              pageTitle = 'All my matches';
            }
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
                    _chatService.totalUnreadMessagesCount(
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
          child: const MatchingBoard(), //TO ADD MATCHES GRID PAGE
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
