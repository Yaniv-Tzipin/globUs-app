import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfirstapp/components/my_colors.dart';
import 'package:myfirstapp/components/my_tags_grid.dart';
import 'package:myfirstapp/components/profile_widget.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/models/user.dart';
import 'package:myfirstapp/pages/choose_tags_page.dart';
import 'package:myfirstapp/pages/edit_profile_page.dart';
import 'package:myfirstapp/providers/my_tags_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _EvaluateProfilePageState createState() => _EvaluateProfilePageState();
}

class _EvaluateProfilePageState extends State<ProfilePage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userEmail).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist for email: ${userEmail}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          currentUser = UserProfile(data);
          return ValidProfilePage();
        }

        return const Text("loading...");
      },
    );
  }
}

class ValidProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ValidProfilePageState();
  }
}

class _ValidProfilePageState extends State<ValidProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),

        // !!!!need to make sure that we stay in the safe zone!!!!

        children: [
          Row(
            children: [
              ProfileWidget(
                imagePath: currentUser.profileImagePath,
                onClicked: () {
                  // EditProfilePage();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              buildUserBasicData()
            ],
          ),
          SizedBox(height: 30),
          buildAbout(currentUser.bio),
          SizedBox(height: 30),
          
          buildMyTags()
        ],
      ),
    );
  }

  Widget buildMyTags() {
    List<InputChip> myTags = currentUser.tags
        .map((x) => InputChip(label: Text(x),selected: true, selectedColor: selectedTagColor,labelStyle: const TextStyle(color: Colors.black),elevation: 0,))
        .toList();

   return
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("My Tags",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        AbsorbPointer(
            child: MyTagsGrid(
                icon: const Icon(Icons.check_rounded), listOfTags: myTags)),
      ]),
    );
  }

  Widget buildAbout(String bio) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("About me",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            Text(bio, style: const TextStyle(fontSize: 17, height: 1.4)),
          ],
        ),
      );

  Widget buildUserBasicData() => Flexible(
    child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                overflow:TextOverflow.fade,
                "${currentUser.username}, ${currentUser.age}",
                style: const TextStyle(fontSize: 23),
              ),
            ),
            Text(
              overflow:TextOverflow.fade,
              currentUser.originCountry,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            )
          ],
        ),
  );
}
