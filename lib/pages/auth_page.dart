import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import "package:myfirstapp/pages/home_page.dart";

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // user logged in
          if(snapshot.hasData){
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