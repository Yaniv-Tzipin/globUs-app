// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_alert_dialog.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';
import 'package:myfirstapp/pages/continue_register.dart';
import 'package:myfirstapp/pages/forgot_pw_page.dart';
import 'package:myfirstapp/pages/home_page.dart';
import 'package:myfirstapp/queries/completed_sign_in_queries.dart' as queries;
import 'package:myfirstapp/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final userMail = FirebaseAuth.instance.currentUser?.email ?? "";

  void continueSigningWithGoogle() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    await AuthService().signInWithGoogle();
    // checking if the current email has already signed up
    final completed = queries.emailCompletedSignIn(email);
    // User has not signed up yet
    if (!await completed) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ContinueRegister(userMail: userMail, withGoogle: true)));
    }
    // user has signed up
    else {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void signUserIn() async {
    // show log in circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // try signing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailController.text, password: passwordController.text);
      //pop the loading circle
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      //WRONG EMAIL OR PASSWORD
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        //show error to user
        showDialog(
            context: context,
            builder: (context) =>
                MyAlertDialog(message:  'Incorrect Email or password Please try again!'));

        //ANOTHER ERROR
      } else {
        //show error to user
               showDialog(
            context: context,
            builder: (context) =>
                MyAlertDialog(message: 'an error occured, please try again'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(225, 220, 232, 220),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  //logo
                  Image.asset('lib/images/globUsLogo1.png', width: 300),

                  //welcome back, you've been missed
                  Text(
                    "Welcome back you've been missed!",
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
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage();
                            }));
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 84, 119, 86),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
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
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 84, 119, 86),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or Continue With',
                            style: TextStyle(
                                color: Color.fromARGB(255, 86, 86, 84)),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 84, 119, 86),
                        ))
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // google + apple signin bottons

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTitle(
                          onTap: () => continueSigningWithGoogle(),
                          imagePath: 'lib/images/google.png'),
                      SizedBox(width: 25),

                      // apple button
                      SquareTitle(
                          onTap: () {}, imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  SizedBox(height: 60),

                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 84, 119, 86),
                              fontSize: 14)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                              color: Color.fromARGB(255, 196, 147, 73),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
