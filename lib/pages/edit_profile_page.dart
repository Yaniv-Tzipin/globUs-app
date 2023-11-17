import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/profile_widget.dart';
import 'package:myfirstapp/components/text_field_with_title.dart';
import 'package:myfirstapp/globals.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  //todo export to createAppBar func
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey[800],
        leading: BackButton(color: Colors.grey[800]),
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
        ],
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
                imagePath: currentUser.profileImagePath,
                onClicked: () async {},
                isEdit: true),
            SizedBox(height: 20,),
            TextFieldWithTitleWidget(label: 'username', text: currentUser.username),
            SizedBox(height: 20,),
            TextFieldWithTitleWidget(label: 'About Me', text: currentUser.bio, maxLines: 5,)
          ]),
    );
  }
}
