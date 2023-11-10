import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/components/my_alert_dialog.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_date_picker.dart";
import "package:myfirstapp/components/my_textfield.dart";
import "package:myfirstapp/pages/home_page.dart";
import "package:myfirstapp/queries/completed_sign_in_queries.dart" as queries;
import "package:myfirstapp/queries/users_queries.dart" as usersQueries;
import 'package:myfirstapp/validations/continue_register_page_validations.dart'
    as cvld;
import "package:shared_preferences/shared_preferences.dart";

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
    String currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (cvld.validateFormFilled(context, usernameController.text,
        birthdateController.text, myBioController.text)) {
        // updating preferences
        pref.setBool("loggedIn", true);
      //sign user up method with google
      if (widget.withGoogle) {
        // adding a new user to Users Collection
        await usersQueries.addNewUser(currentEmail, usernameController.text,
            birthdateController.text, myBioController.text);
        // Sign up is completed, so adding the current userMail to completed_sign_in collection
        await queries.addCompletedUser(currentEmail);
        // updating preferences
        pref.setString("email", currentEmail);

        // going to home page after the users signs up
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }

      //sign user up method without google
      else {
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
          await queries.addCompletedUser(widget.userMail);
          // updating preferences
          pref.setString("email", widget.userMail);

          // going to home page after the users signs up
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } on FirebaseAuthException catch (e) {
          //pop the loading circle
          Navigator.pop(context);

          showDialog(
              context: context,
              builder: (context) =>
                  MyAlertDialog(message: "An error occurred"));
        }
      }
    }
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
