import "dart:io";
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
import 'package:image_picker/image_picker.dart';

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
  PickedFile?
      _imageFile; // will hold the image the user chooses as profile picture
  final ImagePicker _picker = ImagePicker();

  Widget imageProfile() {
    // ignore: prefer_const_constructors
    return Center(
      // ignore: prefer_const_constructors
      child: Stack(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // will show the image inside circle
            // ignore: prefer_const_constructors
            CircleAvatar(
              radius: 80.0,
              // will hold the image path that will be changed dynamically
              backgroundImage: _imageFile == null
                  ? AssetImage('lib/images/defaultProfilePicture.png')
                      as ImageProvider
                  : FileImage(File(_imageFile!.path)),
            ),
            // ignore: prefer_const_constructors
            // Defining the position of the camera icon
            Positioned(
              bottom: 5.0,
              right: 65.0,
              // ignore: prefer_const_constructors
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (builder) => bottomSheet());
                },
                child: Icon(Icons.camera_alt, color: Colors.teal, size: 28.0),
              ),
            )
          ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose profile picture",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("camera")),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("gallery"))
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    // getting an image from camera or gallery - source parameter holds whether
    // we take it from camera or from gallery
    var pickedFile = await _picker.getImage(source: source);
    // saving the image
    setState(() {
      if (pickedFile == null) {
        _imageFile = null;
      } else {
        _imageFile = PickedFile(pickedFile.path);
      }
    });
  }

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
            imageProfile(),
            const SizedBox(height: 20),
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
