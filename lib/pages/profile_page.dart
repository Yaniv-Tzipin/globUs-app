import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfirstapp/models/user.dart';

// todo - export to User class

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userEmail).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist for email: ${userEmail}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ProfileData(userProfile: UserProfile(data),);
        }

        return Text("loading...");
      },
    );
  }
}

class ProfileData extends StatelessWidget {
  late UserProfile userProfile;

  ProfileData({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    var imagePath =
        'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80';

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: imagePath,
            onClicked: () async {},
            firstName: userProfile.firstName,
            age: userProfile.age, 
            country: userProfile.originCountry,
          )
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final String firstName;
  final int age;
  final String country;

  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      required this.firstName,
      required this.age,
      required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 40, 0),
          child: Stack(children: [
            buildImage(),
            Positioned(
              child: buildIcon(color: const Color.fromARGB(255, 156, 204, 101)),
              bottom: 0,
              right: 4,
            ),
          ]),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${firstName}, ${age}",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              "${country}",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ],
    );
  }

  Widget buildIcon({required Color color}) {
    return buildCircle(
      color: Colors.white,
      all: 3.0,
      child: buildCircle(
          color: color,
          child: Icon(Icons.edit, color: Colors.white, size: 20),
          all: 8.0),
    );
  }

  Widget buildCircle(
      {required Widget child, required Color color, required double all}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent, // why?
        child:
            Ink.image(image: image, fit: BoxFit.cover, width: 128, height: 128),
      ),
    );
  }
}
