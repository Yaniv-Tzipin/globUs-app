import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/pages/chat_page.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';
import 'package:myfirstapp/services/matches_service.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;   
  // will hold all usernames except for the username of the current user
  List<String> allOtherUsernames = [];
  // will hold the emails except for the email of the current user
  List<String> allOtherEmails = [];
  // will hold all the usernames the current user does not have a chat with
  List<String> usersWithoutChat = [];
  // will hold just the usernames that match the search query
  List<String> filteredItems = [];
  // will hold the search query
  String _query = '';
  // will be used in the future builder
  var _future;

  // A method that returns all the emails and usernames
  // not including the username and email of the current user
  Future<void> getAllOtherUsersAndEmails() async {
    allOtherUsernames = [];
    allOtherEmails = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element['email'] != _firebaseAuth.currentUser?.email) {
                // updating the lists
                allOtherUsernames.add(element['username']);
                allOtherEmails.add(element['email']);
              }
            }));
  }

// will be called in initState
  Future<dynamic> sendData() async {
    String currentEmail = _firebaseAuth.currentUser?.email ?? "";
    // these are the future methods we will call in the future builder
    final data1 = await _chatService.getUsername(currentEmail);
    final data2 = await getAllOtherUsersAndEmails();
    return [data1, data2];
  }

  // we use initState because we don't want the FutureBuilder ro refire every time
  @override
  initState() {
    _future = sendData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading');
              }
              if (snapshot.hasData) {
                // copying allOtherUsernames list
                usersWithoutChat = List.from(allOtherUsernames);
                return Scaffold(
                    appBar: AppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 228, 236, 232),
                        toolbarHeight: 75,
                        title: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                search(value);
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )),
                    // snapshot.data![0] holds the current username
                    body: createBody(snapshot.data![0]));
              } else {
                return Container();
              }
            }));
  }

  Widget buildUserList(String currentUsername) {
    return StreamBuilder<QuerySnapshot>(
      // this stream listens to the users collection
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot1) {
        return StreamBuilder(
          // this stream listens to the users chat_rooms collection
          stream: _chatService.getChatRoomsOrderedByTimeStamp(),
          builder: (context, snapshot2) {
            if (snapshot1.hasError || snapshot2.hasError) {
              return const Text('error');
            }
            if (snapshot1.connectionState == ConnectionState.waiting ||
                snapshot2.connectionState == ConnectionState.waiting) {
              return const Text('loading...');
            }
            String currentEmail =
                FirebaseAuth.instance.currentUser?.email ?? "";
            // first of all we will use snapshot2 which listens to the chat_rooms collection
            // we will take just the rooms the current user is part of
            List<Widget> listOfChats = snapshot2.data!.docs
                .where((element) => element.id.contains(currentEmail))
                .map<Widget>(
                    (doc) => buildUserListItemWithChat(doc, currentUsername))
                .toList();
            // now we will take snapshot1 which listens to the users collection
            // and we will build the items containing the other users with
            // whom the current user didn't talk yet
            List<Widget> listOfChats2 = snapshot1.data!.docs
                .map<Widget>((doc) => buildUserListItemWithoutChat(doc))
                .toList();

            return ListView(children: listOfChats + listOfChats2);
          },
        );
      },
    );
  }

// build individual user list items
  Widget buildUserListItemWithoutChat(DocumentSnapshot document) {
    // will hold the other user's fields
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // check if the current document represents a user that did not
    // talk with the current user
    if (usersWithoutChat.contains(data['username'])) {
        return buildListItem(data, 'email', 'username');
    } else {
      return Container();
    }
  }

// build individual user list items. We will use this method just for users
// who already talked with the current user
  Widget buildUserListItemWithChat(
      DocumentSnapshot document, String currentUsername) {
    try {
      // will hold the chatrooms fields
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      // checking if the current user equals to the firstUsername field
      // or to the secondUsername field
      String prefix = 'first';
      if (data['firstUsername'] == currentUsername) {
        prefix = 'second';
      }
      // this user already talked with the current user, so we remove him
      // from the usersWithoutChat list
      usersWithoutChat
          .removeWhere((element) => element == data['${prefix}Username']);
      
      // this method will build the list item
      return buildListItem(data, '${prefix}Email', '${prefix}Username');
    } catch (e) {
      print(e);
      return Container();
    }
  }

  Widget buildListItem(Map<String, dynamic> data, String emailFieldName, 
  String usernameFieldName)
  {
      ScrollController scrollController = ScrollController();
      // will build the user's image
      UserImageIcon userImageIcon =
          UserImageIcon(userMail: data[emailFieldName]);
      // when filteredItems is empty, no query was called yet, so display
      // all other usernames. If filteredItems is not empty, there are results
      // for the search query so show just these results
      if (filteredItems.isEmpty ||
          filteredItems.contains(data[usernameFieldName])) {
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
            title: Row(children: [
              Text(data[usernameFieldName]),
              const SizedBox(width: 5),
              // add status icon
              statusIcon(data)
            ]),
            // show last message sent
            subtitle: getLastMessage(data[emailFieldName]),
            // pass the clicked user's email and username to the chat page
            onTap: () => {
                  Get.to(ChatPage(
                      receiverUserEmail: data[emailFieldName],
                      receiverUsername: data[usernameFieldName],
                      scrollController: scrollController,
                      userImageIcon: userImageIcon))
                });
      } else {
        return Container();
      }
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

            return Row(
              children: [
                Text(
                  '$prefix $message',
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 10),
                // adding the number of unread messages
                getUnreadCount(receiverMail)
              ],
            );
          } catch (e) {
            print(e);
            return const Text(
              'Don\'t be shy, start a conversation 😇',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          }
        });
  }

  Widget getUnreadCount(String receiverMail) {
    String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
    String uniqueChatRoomID;
    // this will hold the number of messages the current user
    // did not read in his chat with the current other user
    int unread = 0;
    return StreamBuilder(
        stream: _chatService.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          try {
            // generating the current chatRoom id
            uniqueChatRoomID =
                _chatService.getChatRoomId(currentUserMail, receiverMail);

            // from all the docs (chatRoom ids) get just the one that equals
            // to the current uniqueChatRoomID
            var currentDoc = snapshot.data!.docs
                .singleWhere((element) => element.id == uniqueChatRoomID);

            // getting the number of unread messages
            try {
              Map infoDict = currentDoc.data() as Map;
              unread = infoDict['${currentUserMail}_unread'];
            } catch (e) {
              unread = 0;
            }

            return Text(
              unread.toString(),
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
              ),
            );
          } catch (e) {
            return Container();
          }
        });
  }

// build an icon based on the user's status
  Widget statusIcon(Map<String, dynamic> data) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc().snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.data != null) {
              Color iconColor =
                  (data['status'] == 'Online') ? Colors.green : Colors.grey;
              return Icon(
                Icons.circle,
                color: iconColor,
                size: 12,
              );
            } else {
              return const Icon(
                Icons.circle,
                color: Colors.grey,
                size: 12,
              );
            }
          } catch (e) {
            return const Icon(
              Icons.circle,
              color: Colors.grey,
              size: 12,
            );
          }
        });
  }

  // this method adds the search functionality
  // when a user apply a search query he will be shown only the relevant results.
  void search(String query) {
    setState(
      () {
        print(allOtherUsernames);
        _query = query;
        // filteredItems will hold just the users that match the query
        filteredItems = allOtherUsernames
            .where(
              (item) => item.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  // This method will determine what will be shown in the main_chat_page
  Widget createBody(String currentUsername) {
    // if the user did not search anything yet, show him all options
    // if the user searched something and there are results
    // show him just the compatible options.
    if (_query.isEmpty || _query.isNotEmpty && filteredItems.isNotEmpty) {
      return buildUserList(currentUsername);
    }
    // The user searched something but there are no results
    else {
      return const Center(
          child: Text(
        'No Results Found',
        style: TextStyle(fontSize: 18),
      ));
    }
  }
}

//this section is responsible for showing the profile images of the users
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
