import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/pages/chat_page.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  List<String> allOtherUsernames = [];
  List<String> filteredItems = [];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 75,
            title: Column(
              children: [
                const Text('All my matches'),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    search(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
        body: createBody());
  }

  //build a list of users except for the current logged in user
  //!! IN THE FUTURE NEEDS TO BE CHANGED TO ONLY MATCHS !!

  Widget buildUserList() {
    // initiating allOtherUsernames to an empty list
    // so that befor every new query this list will be cleaned
    allOtherUsernames = [];
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

// build individual user list items
  Widget buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // dsisplay all users except current one
    if (FirebaseAuth.instance.currentUser?.email != data['email']) {
      // updating the list of all the other usernames
      allOtherUsernames.add(data['username']);
      // when filteredItems is empty, no query was called yet, so display
      // all other usernames. If filteredItems is not empty, there are results
      // for the search query so show just these results
      if (filteredItems.isEmpty || filteredItems.contains(data['username'])) {
        return ListTile(
            title: Text(data['username']), // show user's username
            // pass the clicked user's email to the chat page
            onTap: () => {
                  Get.to(ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUsername: data['username'],
                  ))
                });
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  // this method adds the search functionality
  // when a user apply a search query he will be shown only the relevant results.
  void search(String query) {
    setState(
      () {
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
  Widget createBody() {
    // if the user did not search anything yet, show him all options
    // if the user searched something and there are results, show him the compatible options.
    if (_query.isEmpty || _query.isNotEmpty && filteredItems.isNotEmpty) {
      return buildUserList();
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
