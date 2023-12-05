import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/models/user.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/queries/users_quries.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

class MyMatchCard extends StatefulWidget implements Comparable {
  final double cardRanking;
  final String userEmail;

  const MyMatchCard(
      {super.key, required this.cardRanking, required this.userEmail});

  @override
  State<MyMatchCard> createState() => _MyMatchCardState();

  @override
  int compareTo(other) {
    return other.cardRanking.compareTo(cardRanking);
  }
}

class _MyMatchCardState extends State<MyMatchCard> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userEmail).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text(
                "Document does not exist for email: ${widget.userEmail}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            currentUser = UserProfile(data);
            return CardContent(currentUser: currentUser);
          }
          return Container();
        });
  }
}

class CardContent extends StatefulWidget {
  final UserProfile currentUser;
  const CardContent({super.key, required this.currentUser});

  @override
  State<CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  List<dynamic> potentialPartnerTags = currentUser.tags;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
//image
            ShadowOverlay(
              shadowWidth: 350,
              shadowHeight: 200,
              child: buildImage(),
            ),
//username + age
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                '${widget.currentUser.username}, ${widget.currentUser.age}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
//bio
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(alignment: Alignment.topLeft, child: aboutMe()),
            ),
//my tags
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: myTagsBuilder(potentialPartnerTags)),
            ),

            ///!!! to add my endoursments !!!\\\

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Endorsements',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: buildEndorsements(currentUser.email),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

//check what to do with the resolution
  Widget buildImage() {
    return SizedBox(
      width: 350,
      height: 350,
      child: Image.network(fit: BoxFit.cover, currentUser.profileImagePath),
    );
  }

  Widget aboutMe() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About me',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.currentUser.bio,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        )
      ],
    );
  }

  Widget myTagsBuilder(potentialPartnerTags) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My tags',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<DocumentSnapshot>(
                  future: users
                      .doc(FirebaseAuth.instance.currentUser?.email ?? "")
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      currentUser = UserProfile(data);
                      List<dynamic> currentUserTags = currentUser.tags;
                      return tagsCollection(
                          potentialPartnerTags, currentUserTags);
                    }
                    return Container();
                  })),
        ),
      ],
    );
  }

  Widget tagsCollection(
      List<dynamic> potentialPartnerTags, List<dynamic> currentUserTags) {
    List<Widget> ListOfTagsToDisplay = [];
    for (dynamic tag in potentialPartnerTags) {
      if (currentUserTags.contains(tag)) {
        ListOfTagsToDisplay.add(InputChip(
          label: Text(tag),
          isEnabled: false,
          selected: true,
          selectedColor: const Color.fromARGB(255, 233, 192, 148),
        ));
      } else {
        ListOfTagsToDisplay.add(InputChip(
          label: Text(tag),
          selected: false,
        ));
      }
    }
    return Wrap(
      spacing: 3,
      alignment: WrapAlignment.spaceEvenly,
      children: ListOfTagsToDisplay,
    );
  }

  Widget buildEndorsements(String endorsementWriterEmail) {
    return FutureBuilder(
        future: UserQueries.getEndorsements(endorsementWriterEmail),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
// saving the data
          List<dynamic> endorsements = snapshot.data;

          List<Widget> listOfEndorsements = endorsements
              .map<Widget>((endorsement) => buildEndorsementItem(endorsement))
              .toList();
          return Column(
            children: listOfEndorsements,
          );
        });
  }

  Widget buildEndorsementItem(Map<String, dynamic> endorsement) {
// will build the endorsement writer image
    UserImageIcon userImageIcon =
        UserImageIcon(userMail: endorsement['writerEmail'], size: 60);
// saving endorsement timeStamp
    var date = DateTime.fromMillisecondsSinceEpoch(
        endorsement['endorsementTime'].millisecondsSinceEpoch);
    var formattedDate = "${date.day}-${date.month}-${date.year}";

    return ListTile(
//endorsement writer image
        leading: userImageIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color:Color.fromARGB(255, 203, 228, 204), width: 0.3),
        ),
        tileColor: const Color.fromARGB(255, 203, 228, 204),
// show endorsement writer username
        title: Row(children: [
          Text(endorsement['writerUsername']),
          const SizedBox(width: 5),
// show endorsement timestamp
          Text(formattedDate)
        ]),
// show endorsement content
        subtitle: Text(endorsement['endorsementContent']));
  }
}
