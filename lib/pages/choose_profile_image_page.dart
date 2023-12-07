import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfirstapp/pages/edit_profile_page.dart';
import "package:path/path.dart" as Path;
import 'package:myfirstapp/components/my_colors.dart' as my_colors;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key, isEditProfilePage = false});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  PickedFile?
      _imageFile; // will hold the image the user chooses as profile picture
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String userMail = FirebaseAuth.instance.currentUser!.email ?? "";
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // leading: BackButton(color: Colors.grey[800], onPressed: () => Get.to(EditProfilePage())),
        elevation: 0,
        toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: my_colors.toolBarColor,
      ),
      body: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
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
    uploadImage();
    // Navigator.pop(context);
    Get.to(EditProfilePage());
  }

  Future<void> uploadImage() async {
    const String defaultProfileImage =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    final String chosenPath = _imageFile?.path ?? defaultProfileImage;
    final File file = File(chosenPath);
    final String fileName = Path.basename(chosenPath);
    final String path = '${userMail}/${fileName}';

//try upload the pic to the storage in FireBase
    try {
      if (chosenPath == defaultProfileImage) {
        _fireStore
            .collection('users')
            .doc(userMail)
            .set({'profile_image': chosenPath}, SetOptions(merge: true));
      } else {
        final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file);

        //get valid url path
        String myURL = await ref.getDownloadURL();
        //upload to the user's fields in FireStore the image path (that is in the storage)
        await _fireStore
            .collection('users')
            .doc(userMail)
            .set({'profile_image': myURL}, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }
}
