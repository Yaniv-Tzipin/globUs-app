import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/login_page.dart';
import 'package:myfirstapp/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget{
  const LoginOrRegisterPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginOrRegisterPageState();

  }

  class _LoginOrRegisterPageState extends State<LoginOrRegisterPage>{
    // initially show login page
    bool showLoginPage = true;

    // toggle between login and register page
    void togglePages(){
      setState(() {
        showLoginPage = !showLoginPage;
      });
    }

  Widget build(BuildContext context) {

    if(showLoginPage){
      return LoginPage(onTap: togglePages,
      );
    }
    else{
      return RegisterPage(onTap: togglePages
        );
    }
  }
}