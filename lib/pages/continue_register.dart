import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/route_manager.dart";
import "package:image_picker/image_picker.dart";
import "package:myfirstapp/components/choose_tags_button.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_country_picker.dart";
import "package:myfirstapp/components/my_date_picker.dart";
import "package:myfirstapp/components/my_textfield.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";
import "package:myfirstapp/pages/home_page.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";
import 'package:myfirstapp/queries/users_quries.dart';
import 'package:myfirstapp/queries/completed_sign_in_queries.dart' as queries;
import 'package:myfirstapp/validations/continue_register_page_validation.dart'as CRPV;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import "package:path/path.dart" as Path;

class ContinueRegister extends StatefulWidget {
  const ContinueRegister({
    super.key,
  });

  @override
  State<ContinueRegister> createState() => _ContinueRegisterState();
}

class _ContinueRegisterState extends State<ContinueRegister> {
  final userNameController = TextEditingController();
  final myBioController = TextEditingController();
  final String userMail = FirebaseAuth.instance.currentUser!.email ?? "";
  final birthDateController = TextEditingController();
  final countryController = TextEditingController();
  PickedFile?
      _imageFile; // will hold the image the user chooses as profile picture
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
// will show the image inside circle
        CircleAvatar(
          radius: 80.0,
// will hold the image path that will be changed dynamically
          backgroundImage: _imageFile == null
              ? const AssetImage('lib/images/defaultProfilePicture.png')
                  as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
// Defining the position of the camera icon
        Positioned(
          bottom: 5.0,
          right: 65.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (builder) => bottomSheet());
            },
            child: const Icon(Icons.camera_alt, color: Colors.teal, size: 28.0),
          ),
        )
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile picture",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("camera")),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("gallery"))
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

Future<void> uploadImage() async{
if(_imageFile == null){
  return;
}
final File file = File(_imageFile!.path);
final String fileName = Path.basename(_imageFile!.path);
final String path = '${userMail}/${fileName}';

//try upload the pic to the storage in FireBase
try{
  final ref =  firebase_storage.FirebaseStorage.instance.ref().child(path);
  await ref.putFile(file);

  //get valid url path
  String myURL = await ref.getDownloadURL();
  //upload to the user's fields in FireStore the image path (that is in the storage)
  await _fireStore.collection('users').doc(userMail).set({
    'profile_image' :  myURL}, SetOptions(merge: true)
  );

} catch(e){
  print(e);
}
}


  //navigate to tags page
  void chooseTags() async {
    Get.to(const MyTags());
  }

  void goToRegisterPage() async {
    Get.to(LoginOrRegisterPage(
      showLoginPage: false,
    ));
  }

  //sign user up method
  Future<void> signUserUp() async {

    //check if user filled all the neccesary fields
    if (CRPV.validateFormFilled(context, userNameController.text,
        birthDateController.text, myBioController.text,
        countryController.text)) {
      showDialog(context: context, builder: (context){
        return const Center(
          child: CircularProgressIndicator()
        );
      });
      
      //add user's data to FireStore(except image URL which will happen seperately)
      await UserQueries.addNewUser(userMail, userNameController.text.trim(),
          birthDateController.text, myBioController.text, countryController.text);
      //set user's status to completed register
      await queries.addCompletedUser(userMail);
      //upload user's chosen image to firestore storage
      await uploadImage();
      Navigator.pop(context);
      //finally, navigate to homepage
      Get.to(HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goToRegisterPage,
        ),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(225, 220, 232, 220),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              controller: userNameController,
              hintText: 'Username',
              obscureText: false,
              maximumLines: 1,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 10),
            MyDatePicker(dateController: birthDateController),
            const SizedBox(height: 10),
            MyTextField(
              controller: myBioController,
              hintText: 'Tell about youself',
              maximumLines: 5,
              obscureText: false,
              prefixIcon: Icons.face,
            ),
            const SizedBox(height: 10),
            //MyButton(onTap: chooseTags,
            //text: "Choose Your Tags"),
            GestureDetector(
              onTap: chooseTags,
              child: const MyTagsButton(),
            ),
            const SizedBox(height: 10),
            MyCountryPicker(pickedCountry: countryController),
            const SizedBox(height: 20),
            MyButton(onTap: signUserUp, text: "Ready to Go"),
          ],
        )),
      )),
    );
  }
}
