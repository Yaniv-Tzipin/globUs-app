// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:myfirstapp/pages/chat_page.dart';
// import 'package:myfirstapp/services/chat/chat_services.dart';

// class MainChatPage extends StatefulWidget {
//   const MainChatPage({super.key});

//   @override
//   State<MainChatPage> createState() => _MainChatPageState();
// }

// class _MainChatPageState extends State<MainChatPage> {
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   List<String> allOtherUsernames = [];
//   List<String> filteredItems = [];
//   String _query = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             backgroundColor: const Color.fromARGB(255, 228, 236, 232),
//             toolbarHeight: 75,
//             title: Column(
//               children: [
//                 TextField(
//                   style: const TextStyle(color: Colors.black),
//                   onChanged: (value) {
//                     search(value);
//                   },
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search...',
//                     hintStyle: TextStyle(
//                       color: Colors.black,
//                     ),
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//         body: createBody());
//   }

// //build a list of users except for the current logged in user
// //!! IN THE FUTURE NEEDS TO BE CHANGED TO ONLY MATCHS !!

//   Widget buildUserList() {
// // initiating allOtherUsernames to an empty list
// // so that befor every new query this list will be cleaned
//     allOtherUsernames = [];
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text('error');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text('loading');
//           }
//           List<Widget> listOfChats = snapshot.data!.docs
//               .map<Widget>((doc) => buildUserListItem(doc))
//               .toList();
//           return ListView(children: listOfChats);
//         });
//   }

//   // build individual user list items
//   Widget buildUserListItem(DocumentSnapshot document) {
    // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // ScrollController scrollController = ScrollController();
    // UserImageIcon userImageIcon = UserImageIcon(userMail: data['email']);

    // // display all users except current one
    // if (FirebaseAuth.instance.currentUser?.email != data['email']) {
    //   allOtherUsernames.add(data['username']);
    //   // when filteredItems is empty, no query was called yet, so display
    //   // all other usernames. If filteredItems is not empty, there are results
    //   // for the search query so show just these results
    //   if (filteredItems.isEmpty || filteredItems.contains(data['username'])) {
    //     return ListTile(
    //         //receiver's profile image
    //         leading: userImageIcon,
    //         contentPadding:
    //             const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    //         shape: const RoundedRectangleBorder(
    //           side: BorderSide(color: Colors.white, width: 0.3),
    //         ),
    //         tileColor: const Color.fromARGB(255, 228, 236, 232),
    //         trailing: Padding(
    //           padding: const EdgeInsets.only(right: 8.0),
    //           child: SizedBox(
    //             width: 0,
    //             child: getUnreadCount(data['email'])),
    //         ),
    //         // show user's username
    //         title: Row(children: [
    //           Text(data['username']),
    //           const SizedBox(width: 5),
    //           statusIcon(data)
    //         ]),
    //         // show last message sent
    //         subtitle: getLastMessage(data['email']),
    //         // pass the clicked user's email to the chat page
    //         onTap: () => {
    //               Get.to(ChatPage(
    //                   receiverUserEmail: data['email'],
    //                   receiverUsername: data['username'],
    //                   scrollController: scrollController,
    //                   userImageIcon: userImageIcon))
    //             });
    //   } else {
    //     return Container();
    //   }
    // } else {
    //   return Container();
    // }
  // }

// //get last message in chatroom
//   Widget getLastMessage(String receiverMail) {
//     String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
//     return StreamBuilder(
//         stream: _chatService.getMessages(currentUserMail, receiverMail),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text('loading..');
//           }
//           try {
//             String message = snapshot.data!.docs.last.get('message');

// // the prefix of the text will be you or the sender's username
//             String prefix;
//             if (snapshot.data!.docs.last.get('senderEmail') ==
//                 currentUserMail) {
//               prefix = 'You:';
//             } else {
//               prefix = snapshot.data!.docs.last.get('senderUsername') + ':';
//             }

//             return Text(
//               '$prefix $message',
//               overflow: TextOverflow.ellipsis,
//             );
//           } catch (e) {
//             return const Text(
//               'Don\'t be shy, start a conversation😇',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             );
//           }
//         });
//   }

//   Widget getUnreadCount(String receiverMail) {
//     String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
//     String uniqueChatRoomID;
//     // this will hold the number of messages the current user
//     // did not read in his chat with the current other user
//     int unread = 0;
//     return StreamBuilder(
//         stream: _chatService.getChatRooms(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text('loading..');
//           }
//           try {
//             // generating the current chatRoom id
//             uniqueChatRoomID =
//                 _chatService.getChatRoomId(currentUserMail, receiverMail);

//             // from all the docs (chatRoom ids) get just the one that equals
//             // to the current uniqueChatRoomID
//             var currentDoc = snapshot.data!.docs
//                 .singleWhere((element) => element.id == uniqueChatRoomID);

//             // getting the number of unread messages
//             try {
//               Map infoDict = currentDoc.data() as Map;
//               unread = infoDict['${currentUserMail}_unread'];
//             } catch (e) {
//               unread = 0;
//             }

//             return Text(
//               unread.toString(),
//               style: const TextStyle(
//                 color: Colors.blue,
//                 fontSize: 15.0,
//                 fontWeight: FontWeight.w800,
//               ),
//             );
//           } catch (e) {
//             return Container();
//           }
//         });
//   }

// // build an icon based on the user's status
//   Widget statusIcon(Map<String, dynamic> data) {
//     return StreamBuilder<DocumentSnapshot>(
//         stream:
//             FirebaseFirestore.instance.collection('users').doc().snapshots(),
//         builder: (context, snapshot) {
//           try {
//             if (snapshot.data != null) {
//               Color iconColor =
//                   (data['status'] == 'Online') ? Colors.green : Colors.grey;
//               return Icon(
//                 Icons.circle,
//                 color: iconColor,
//                 size: 12,
//               );
//             } else {
//               return const Icon(
//                 Icons.circle,
//                 color: Colors.grey,
//                 size: 12,
//               );
//             }
//           } catch (e) {
//             return const Icon(
//               Icons.circle,
//               color: Colors.grey,
//               size: 12,
//             );
//           }
//         });
//   }

// // this method adds the search functionality
// // when a user apply a search query he will be shown only the relevant results.
//   void search(String query) {
//     setState(
//       () {
//         _query = query;
// // filteredItems will hold just the users that match the query
//         filteredItems = allOtherUsernames
//             .where(
//               (item) => item.toLowerCase().startsWith(
//                     query.toLowerCase(),
//                   ),
//             )
//             .toList();
//       },
//     );
//   }

// // This method will determine what will be shown in the main_chat_page
//   Widget createBody() {
// // if the user did not search anything yet, show him all options
// // if the user searched something and there are results, show him the compatible options.
//     if (_query.isEmpty || _query.isNotEmpty && filteredItems.isNotEmpty) {
//       return buildUserList();
//     }
// // The user searched something but there are no results
//     else {
//       return const Center(
//           child: Text(
//         'No Results Found',
//         style: TextStyle(fontSize: 18),
//       ));
//     }
//   }
// }

// //this section is responsible for showing the profile images of the users
// class UserImageIcon extends StatefulWidget {
//   final String userMail;
//   const UserImageIcon({super.key, required this.userMail});

//   @override
//   State<UserImageIcon> createState() => _UserImageIconState();
// }

// class _UserImageIconState extends State<UserImageIcon> {
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//   final String ConstImageURL =
//       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcU50X1UOeDaphmUyD6T8ROKs-HjeirpOoapiWbC9cLAqewFy1gthrgUTB9E7nKjRwOVk&usqp=CAU';
//   late String usersImagePath;

//   Future<void> loadImage() async {
//     try {
//       usersImagePath = await _fireStore
//           .collection('users')
//           .doc(widget.userMail)
//           .get()
//           .then((snapshot) {
//         return snapshot.data()!['profile_image'].toString();
//       });
//       if (usersImagePath == '') {
//         usersImagePath = ConstImageURL;
//       }
//     } catch (e) {
//       usersImagePath = ConstImageURL;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: loadImage(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SizedBox(
//               width: 60,
//               height: 60,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//           return SizedBox(width: 60, height: 60, child: buildImage());
//         });
//   }

//   Widget buildImage() {
//     final image = NetworkImage(usersImagePath);

//     return ClipOval(
//       child: Material(
//         color: Colors.transparent, // why?
//         child: Ink.image(image: image, fit: BoxFit.cover, width: 0, height: 0),
//       ),
//     );
//   }
// }
