import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/pages/continue_register.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import "package:myfirstapp/pages/home_page.dart";
import "package:myfirstapp/pages/login_page.dart";
import "package:myfirstapp/pages/register_page.dart";

import "package:myfirstapp/queries/completed_sign_in_queries.dart";

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});
  

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: StreamBuilder<User?>(
  //       stream: FirebaseAuth.instance.authStateChanges(), 
  //       builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
  //         // user logged in
  //         if(snapshot.hasData){
  
  //           return HomePage();
  //         }
  //         // user not logged in
  //         else{
  //           return const LoginOrRegisterPage();
  //         }
  //       }
        
  //       ),
  //   );
  // }


  @override
  Widget build(context) {
    return FutureBuilder<bool>(
      future: emailCompletedSignIn(""),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool completedSigningIn = snapshot.data ?? false;
          if (completedSigningIn)
          {
            return HomePage();
          }
          else
          {
            return LoginOrRegisterPage();
          }
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}