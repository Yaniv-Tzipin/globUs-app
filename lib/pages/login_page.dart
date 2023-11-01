// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';


class LoginPage extends StatelessWidget{
   LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(){}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(225, 220, 232, 220),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
              SizedBox(height: 20),
              //logo
              Image.asset('lib/images/globUsLogo1.png',
              width: 300),

              //welcome back, you've been missed
              Text("Welcome back you've been missed!",
              style: TextStyle(
                color: Color.fromARGB(255, 84, 119, 86),
                fontSize: 16,

              ), 
            ),

              SizedBox(height: 25),
             
              //username textfields
              MyTextField(
                controller: usernameController,
                hintText: 'username',
                obscureText: false,
              ),
              SizedBox(height: 10),
        
              //password textfields
              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ), 
              SizedBox(height: 10),
              
              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot password?',
                      style: TextStyle(color: Color.fromARGB(255, 84, 119, 86),
                      fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
      
              //sign in button

              MyButton(onTap: signUserIn
              ),

              SizedBox(height: 50),

        
              //or continue with

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(children: [
                  Expanded(child: Divider(
                    thickness: 0.5,
                    color: Color.fromARGB(255, 84, 119, 86),)
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or Continue With',
                    style: TextStyle(color: Color.fromARGB(255, 86, 86, 84)),),
                  ),
                  Expanded(child: Divider(
                    thickness: 0.5,
                    color: Color.fromARGB(255, 84, 119, 86),) 
                  )
                ],
                ),
              ),

              SizedBox(height:20),
        
              // google + apple signin bottons 

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // google button
                SquareTitle(imagePath: 'lib/images/google.png'),
                SizedBox(width:25),

                // apple button
                SquareTitle(imagePath: 'lib/images/apple.png')
              ],
              ),

              SizedBox(height:60),
        
              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?',
                  style: TextStyle(
                    color:Color.fromARGB(255, 84, 119, 86),
                    fontSize: 14
                  )
                  ),
                  const SizedBox(width: 4),
                  Text('Register now',
                  style: TextStyle(
                    color: Color.fromARGB(255, 196, 147, 73),
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ],
              )
        
            ],
          ),
        ),
      )
       
    );
  } 
}