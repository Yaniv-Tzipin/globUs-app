import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/pages/continue_register.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import "package:myfirstapp/pages/home_page.dart";
import 'package:myfirstapp/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Stream<User?> authStream = FirebaseAuth.instance.authStateChanges();
  late bool isNewUser;
// update users' status (new or completed sign up proccess)
  Future<void> getUserData() async {
    isNewUser = await AuthService().checkIfUserCompletedSigningUp();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authStream,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot1) {
          return Center(
              child: FutureBuilder(
                  future: getUserData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return  LoginOrRegisterPage(showLoginPage: true,);
                    } else {
                      if (snapshot1.hasData) {
                        if (isNewUser) {
                          return const ContinueRegister();
                        } else {
                          return HomePage();
                        }
                      } else {
                        return  LoginOrRegisterPage(showLoginPage: true,);
                      }
                    }
                  }));
        });
  }
}
