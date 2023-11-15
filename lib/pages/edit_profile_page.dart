import 'package:flutter/material.dart';
import 'package:myfirstapp/components/profile_widget.dart';
import 'package:myfirstapp/globals.dart';

class EditProfilePage extends StatefulWidget{
  @override
  _EditProfilePageState createState() => _EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: BouncingScrollPhysics(),
        children:[ 
          ProfileWidget(
          imagePath: currentUser.profileImagePath,
          onClicked: () async {},
          isEdit: true
        ),
        ]
      ),
    );
  }

}