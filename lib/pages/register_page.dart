// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_alert_dialog.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/components/square_title.dart';
import 'package:myfirstapp/pages/continue_register.dart';
import 'package:myfirstapp/services/auth_service.dart';
import 'package:myfirstapp/validations/register_page_validations.dart' as vld;
import 'package:myfirstapp/queries/completed_sign_in_queries.dart' as queries;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  // text editing controllers
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  continueRegister(bool withGoogle) async {
    String currentEmail;
    // saving the current email - depends whether googleButton is pressed or not
    if (withGoogle) {
      currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    } else {
      currentEmail = mailController.text;
    }

    if (vld.validateFormFilled(context, withGoogle, mailController.text,
        passwordController.text, confirmPasswordController.text)) {
      if (withGoogle) {
        await AuthService().signInWithGoogle();
      }
      // checking if the user has already signed up
      final bool completed = await queries.emailCompletedSignIn(currentEmail);
      // user has signed up
      if (completed) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            // ignore: prefer_const_constructors
            builder: (context) => MyAlertDialog(
                message:
                    "You already have an account connected to this email"));
      } else {
        // user has not signed up yet
        // check if passwords are matching
        if (passwordController.text != confirmPasswordController.text) {
          showDialog(
              context: context,
              builder: (context) =>
                  MyAlertDialog(message: "passwords don't match"));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContinueRegister(
                      userMail: mailController.text,
                      userPassword: passwordController.text,
                      userConfirmPassword: confirmPasswordController.text,
                      withGoogle: withGoogle)));
        }
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
                  Image.asset('lib/images/globUsLogo1.png', width: 200),

                  //welcome back, you've been missed
                  Text(
                    "Let's create an account for you!",
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

                  //confirm password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm password',
                    obscureText: true,
                    maximumLines: 1,
                    prefixIcon: Icons.repeat_on_rounded,
                  ),
                  SizedBox(height: 10),

                  //forgot password

                  SizedBox(height: 25),

                  //continue button

                  MyButton(
                      onTap: () => continueRegister(false), text: 'Continue'),

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
                          onTap: () => continueRegister(true),
                          imagePath: 'lib/images/google.png'),
                      SizedBox(width: 25),

                      // apple button
                      SquareTitle(
                          onTap: () {}, imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  SizedBox(height: 40),

                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 84, 119, 86),
                              fontSize: 14)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Log-in now',
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
