import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/home_page.dart';
import 'package:myfirstapp/pages/login_or_register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:myfirstapp/queries/completed_sign_in_queries.dart' as queries;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // getting user's log in state - depends whether he pressed on logging out or not
  bool loggedIn = prefs.getBool("loggedIn") ?? false;
  // getting user's email 
  String email = prefs.getString("email") ?? "";
  // checking if the user completed signing in the past
  bool completed = await queries.emailCompletedSignIn(email);
  // if the user completed signing in and didn't log out - go straight to homePage
  // otherwise, get him to LoginOrRegisterPage
  runApp(MyApp(loggedIn: loggedIn && completed));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    // The user didn't log out the last time he used the app so go straight to homePage
    if (loggedIn) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    // The user logged out or is not registered so go to LoginOrRegisterPage
    } else {
      // ignore: prefer_const_constructors
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginOrRegisterPage(),
      );
    }
  }
}
