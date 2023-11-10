import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import "package:myfirstapp/pages/home_page.dart";
import 'package:myfirstapp/services/auth_service.dart';


class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // user logged in
          if(snapshot.hasData){
            //!!!need to add check if user is signed-in:
            AuthService().checkIfUserCompletedSigningUp();//maybe use what Nadav said with disk memory
            return HomePage();
          }
          // user not logged in
          else{
            return const LoginOrRegisterPage();
          }
        }
        
        ),
    );
  }
}