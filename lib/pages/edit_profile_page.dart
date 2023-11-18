import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/profile_widget.dart';
import 'package:myfirstapp/components/text_field_with_title.dart';
import 'package:myfirstapp/globals.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void updateDB() async {
    Map<String, TextEditingController> controllers = {
      "bio": bioController
    };
    for (MapEntry<String, TextEditingController> entry in controllers.entries) {
      TextEditingController controller = entry.value;
      if (controller.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .update({entry.key: controller.text});
      }
    }
    //todo: once Save is pressed, reload profile page automatically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // todo: export to createAppBar() func
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey[800],
        leading: BackButton(color: Colors.grey[800]),
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
                imagePath: currentUser.profileImagePath,
                onClicked: () async {},
                isEdit: true),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithTitleWidget(
              label: 'About Me',
              text: currentUser.bio,
              maxLines: 5,
              controller: bioController,
            ),
            const SizedBox(height: 30),
            MyButton(onTap: updateDB, text: 'Save'),
          ]),
    );
  }
}
