import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfirstapp/models/user.dart';


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
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist for email: ${userEmail}");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ProfileData(
            userProfile: UserProfile(data),
          );
        }

        return const Text("loading...");
      },
    );
  }
}

class ProfileData extends StatelessWidget {
  late UserProfile userProfile;

  ProfileData({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              ProfileWidget(
                imagePath: userProfile.profileImagePath,
                onClicked: () async {},
                firstName: userProfile.firstName,
                age: userProfile.age,
                country: userProfile.originCountry,
              ),
              UserBasicDataWidget(
                firstName: userProfile.firstName,
                age: userProfile.age,
                country: userProfile.originCountry,
              )
            ],
          )
        ],
      ),
    );
  }
}

class UserBasicDataWidget extends StatelessWidget {
  final String firstName;
  final int age;
  final String country;

  const UserBasicDataWidget(
      {Key? key,
      required this.firstName,
      required this.age,
      required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "$firstName, $age",
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Text(
          "${country}",
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        )
      ],
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
              bottom: 0,
              right: 0,
              child: buildIcon(color: const Color.fromARGB(255, 156, 204, 101)),
            ),
          ]),
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
          child: const Icon(Icons.edit, color: Colors.white, size: 20),
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
