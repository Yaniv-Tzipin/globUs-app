import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/pages/continue_register.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import "package:myfirstapp/pages/home_page.dart";
import "package:myfirstapp/providers/auth_status_provider.dart";
import "package:myfirstapp/services/auth_service.dart";
import "package:provider/provider.dart";

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isExistingUser = false;

  @override
  Widget build(BuildContext context) {
     //final authStatusProvider = Provider.of<AuthStateChanges>(context);
     //final loggedInWithGoogle = authStatusProvider.userLoggedInWithGoogle;
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // user logged in
          if(snapshot.hasData){
            //if(authStatusProvider.checkIfExistingUser()){
            return HomePage();
            // }
            // else{
            //   return ContinueRegister(userMail: "", userPassword: "", userConfirmPassword: "");
            // }
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