import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/login_page.dart';
import 'package:myfirstapp/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget{
    LoginOrRegisterPage({super.key, required this.showLoginPage});

  // initially show login page
  bool showLoginPage = true;
  
  @override
  State<StatefulWidget> createState() => _LoginOrRegisterPageState();
  }

  class _LoginOrRegisterPageState extends State<LoginOrRegisterPage>{
    // initially show login page
  

    // toggle between login and register page
    void togglePages(){
      setState(() {
        widget.showLoginPage = !widget.showLoginPage;
      });
    }

  @override
  Widget build(BuildContext context) {

    if(widget.showLoginPage){
      return LoginPage(onTap: togglePages,
      );
    }
    else{
      return RegisterPage(onTap: togglePages
        );
    }
  }
}