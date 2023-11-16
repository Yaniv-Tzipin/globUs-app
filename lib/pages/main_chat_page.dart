import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/chat_bubble.dart';
import 'package:myfirstapp/pages/chat_page.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All my matches'),
        ),
        body: buildUserList());
  }

  //build a list of users except for the current logged in user
  //!! IN THE FUTURE NEEDS TO BE CHANGED TO ONLY MATCHS !!

  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => buildUserListItem(doc))
                  .toList());
        });
  }

//get last message in chatroom
  Widget getLastMessage(String receiverMail) {
    String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
    return StreamBuilder(
        stream: _chatService.getMessages(currentUserMail, receiverMail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          try {
            String message = snapshot.data!.docs.last.get('message');

            // the prefix of the text will be you or the sender's username
            String prefix;
            if (snapshot.data!.docs.last.get('senderEmail') ==
                currentUserMail) {
              prefix = 'You:';
            } else {
              prefix = snapshot.data!.docs.last.get('senderUsername') + ':';
            }

            return Text(
              '$prefix $message',
              overflow: TextOverflow.ellipsis,
            );
          } catch (e) {
            return const Text('Don\'t be shy, start a conversation 😇', style: TextStyle(fontWeight: FontWeight.bold),);
          }
        });
  }

// build individual user list items
  Widget buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    ScrollController scrollController = ScrollController();
    UserImageIcon userImageIcon = UserImageIcon(userMail: data['email']);
  

    // dsisplay all users except current one
    if (FirebaseAuth.instance.currentUser?.email != data['email']) {
      return ListTile(
          //receiver's profile image
          leading: userImageIcon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 0.3),
          ),
          tileColor: const Color.fromARGB(255, 228, 236, 232),
          // show user's username
          title: Text(data['username']),
          // show last message sent
          subtitle: getLastMessage(data['email']),
          // pass the clicked user's email to the chat page
          onTap: () => {
                Get.to(ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUsername: data['username'],
                  scrollController: scrollController,
                  userImageIcon: userImageIcon
                ))
              });
    } else {
      return Container();
    }
  }
}

//this section is responsible for showing the profile images of the users:
class UserImageIcon extends StatefulWidget {
  final String userMail;
  const UserImageIcon({super.key, required this.userMail});

  @override
  State<UserImageIcon> createState() => _UserImageIconState();
}

class _UserImageIconState extends State<UserImageIcon> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String ConstImageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcU50X1UOeDaphmUyD6T8ROKs-HjeirpOoapiWbC9cLAqewFy1gthrgUTB9E7nKjRwOVk&usqp=CAU';
  late String usersImagePath;

  Future<void> loadImage() async {
    try {
      usersImagePath = await _fireStore
          .collection('users')
          .doc(widget.userMail)
          .get()
          .then((snapshot) {
        return snapshot.data()!['profile_image'].toString();
      });
      if (usersImagePath == '') {
        usersImagePath = ConstImageURL;
      }
    } catch (e) {
      usersImagePath = ConstImageURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 60,
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SizedBox(width: 60, height: 60, child: buildImage());
        });
  }

  Widget buildImage() {
    final image = NetworkImage(usersImagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent, // why?
        child: Ink.image(image: image, fit: BoxFit.cover, width: 0, height: 0),
      ),
    );
  }
}
