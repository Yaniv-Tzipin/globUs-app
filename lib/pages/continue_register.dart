import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_date_picker.dart";
import "package:myfirstapp/components/my_textfield.dart";
import "package:myfirstapp/services/auth_service.dart";
import "package:myfirstapp/queries/completed_sign_in_queries.dart"
    as completedSignInQueries;
import "package:myfirstapp/queries/users_queries.dart" as usersQueries;

class ContinueRegister extends StatefulWidget {
  final String userMail;
  String? userPassword;
  String? userConfirmPassword;
  final bool withGoogle;
  ContinueRegister(
      {super.key,
      required this.userMail,
      this.userPassword,
      this.userConfirmPassword,
      required this.withGoogle});

  @override
  State<ContinueRegister> createState() => _ContinueRegisterState();
}

class _ContinueRegisterState extends State<ContinueRegister> {
  final usernameController = TextEditingController();
  final myBioController = TextEditingController();
  final birthdateController = TextEditingController();

  //sign user up
  void signUserUp() async {
    //sign user up method with google
    if (widget.withGoogle) {
      String email = FirebaseAuth.instance.currentUser?.email ?? "";
      // adding a new user to Users Collection
      await usersQueries.addNewUser(email, usernameController.text,
          birthdateController.text, myBioController.text);
      // Sign up is completed, so adding the current userMail to completed_sign_in collection
      await completedSignInQueries.addCompletedUser(email);
      Navigator.pop(context);

      //sign user up method with google
    } else {
      // check if passwords are matching
      if (widget.userPassword != widget.userConfirmPassword) {
        showErrorMessage("passwords don't match");
      } else {
        // show sign up circle
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });

        // try creating the user
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: widget.userMail, password: widget.userPassword ?? "");
          //pop the loading circle
          Navigator.pop(context);

          // adding a new user to Users Collection
          await usersQueries.addNewUser(
              widget.userMail,
              usernameController.text,
              birthdateController.text,
              myBioController.text);
          // Sign up is completed, so adding the current userMail to completed_sign_in collection
          await completedSignInQueries.addCompletedUser(widget.userMail);

          //go to home-page
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          //pop the loading circle
          Navigator.pop(context);

          showErrorMessage(e.code);
        }
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Color.fromARGB(255, 110, 138, 100),
              title: Center(
                  child: Text(message, style: TextStyle(color: Colors.white))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color.fromARGB(225, 220, 232, 220),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
              maximumLines: 1,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 10),
            MyDatePicker(dateController: birthdateController),
            const SizedBox(height: 10),
            MyTextField(
              controller: myBioController,
              hintText: 'Tell about youself',
              maximumLines: 5,
              obscureText: false,
              prefixIcon: Icons.face,
            ),
            const SizedBox(height: 10),
            MyButton(onTap: signUserUp, text: "Sign Up"),
            const SizedBox(height: 10),
          ],
        )),
      )),
    );
  }
}
