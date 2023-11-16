// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';
import 'package:myfirstapp/pages/forgot_pw_page.dart';
import 'package:myfirstapp/services/auth_service.dart';


class LoginPage extends StatefulWidget{
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  // text editing controllers
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUserIn() async{

    // show log in circle 
    showDialog(
      context: context,
       builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
       }
      );
    // try sign in, snapshot gets data
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mailController.text,
      password: passwordController.text
      );
    //pop the loading circle
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    
    } on FirebaseAuthException catch (e){

    //pop the loading circle
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
      
      //WRONG EMAIL OR PASSWORD
      if(e.code == 'INVALID_LOGIN_CREDENTIALS'){
        //show error to user
        wrongUsernameOrPasswordMessage();

      //ANOTHER ERROR
      } 
      else{
        //show error to user
        otherError();
      
      }   
    }
  }

  void wrongUsernameOrPasswordMessage(){
    showDialog(context: context,
     builder: (context)
     {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 110, 138, 100),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(),
            child: Text('Incorrect Email or password Please try again!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,
            fontSize: 18),
            ),
          )
        )
      );

     }
     );
  }

  void otherError(){
    showDialog(context: context,
     builder: (context)
     {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 110, 138, 100),
        title: Center(
          child: Text('an error occured, please try again',
          style: TextStyle(color: Colors.white)
          )
        )
      );

     }
     );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(225, 220, 232, 220),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  controller: mailController,
                  hintText: 'Email',
                  obscureText: false,
                  maximumLines: 1,
                  prefixIcon: Icons.mail,
                ),
                SizedBox(height: 10),
                  
                //password textfields
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                  maximumLines: 1,
                  prefixIcon: Icons.lock,
                ), 
                SizedBox(height: 10),
                
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return ForgotPasswordPage();
                          }
                          )
                        );

                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Color.fromARGB(255, 84, 119, 86),
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          
                SizedBox(height: 25),
                
                //sign in button
          
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign In',
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
                  SquareTitle(onTap: () => {AuthService().signInWithGoogle()},
                  imagePath: 'lib/images/google.png'),
                  SizedBox(width:25),
          
                  // apple button
                  SquareTitle(
                    onTap: (){},
                    imagePath: 'lib/images/apple.png')
                ],
                ),
          
                SizedBox(height:10),
                  
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
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Register now',
                      style: TextStyle(
                        color: Color.fromARGB(255, 196, 147, 73),
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    )
                  ],
                )
                  
              ],
            ),
          ),
        ),
      )
       
    );
  } 
}