// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/pages/login_or_register_page.dart';
import 'package:myfirstapp/components/my_colors.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/pages/matching_page.dart';
import 'package:myfirstapp/pages/preferences_page.dart';
import 'package:myfirstapp/pages/profile_page.dart';
import 'package:myfirstapp/queries/users_quries.dart';
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

class _NavigationExampleState extends State<NavigationExample>
    with WidgetsBindingObserver {
  int currentPageIndex = 0;
  String pageTitle = "";
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  final userMail = FirebaseAuth.instance.currentUser?.email;
  String lat = "";
  String long = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void setStatus(String status) async {
    await _fireStore.collection('users').doc(userMail).update(
      {'status': status},
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('Online');
    } else {
      setStatus('Offline');
    }
  }

  //sign user out method, snapshot loosing data
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Get.to(LoginOrRegisterPage(showLoginPage: true));
  }

  Future<Position?> getCurentLocation() async {
    // checking whether location services are enabled on the device
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled");
      return null;
    }
    // checking if the user allows the app to access the device's location.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied, we cannot request permissions");
      return null;
    }

    // if we were granted permissions
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurentLocation(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // if we reached here, we have data
          // updating the current location of the user
          if (snapshot.data != null) {
            lat = snapshot.data.latitude.toString();
            long = snapshot.data.longitude.toString();
          }
          UserQueries.updateCurrentLocation(lat, long);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                pageTitle,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
              automaticallyImplyLeading: false,
              foregroundColor: Colors.grey[800],
              toolbarHeight: 40,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Row(
                  children: [
                    // sliders icon to change preferences
                    GestureDetector(
                        child: FaIcon(FontAwesomeIcons.sliders, size: 20),
                        onTap: () {
                          Get.to(const PreferencesPage());
                        }),
                    SizedBox(width: 10),
                    IconButton(
                        onPressed: signUserOut, icon: Icon(Icons.logout)),
                  ],
                )
              ],
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                  //change the title of the tool bar according to the page
                  if (currentPageIndex == 0) {
                    pageTitle = '';
                  }
                  if (currentPageIndex == 1) {
                    pageTitle = 'Find some travel partners';
                  }
                  if (currentPageIndex == 2) {
                    pageTitle = 'All my matches';
                  }
                });
              },
              indicatorColor: selectedTagColor,
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
                        child: _chatService.totalUnreadMessagesCount(),
                      ),
                    )
                  ],
                ),
              ],
            ),
            body: <Widget>[
              Container(
                color: const Color.fromARGB(255, 203, 228, 204),
                alignment: Alignment.center,
                child: ProfilePage(),
              ),
              Container(
                color: const Color.fromARGB(255, 203, 228, 204),
                alignment: Alignment.center,
                child: MatchingBoard(), //TO ADD MATCHES GRID PAGE
              ),
              Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: MainChatPage(),
              ),
            ][currentPageIndex],
          );
        });
  }
}
