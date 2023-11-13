
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/pages/chat_page.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('All my matches'),
      ),
      body: buildUserList()
    );
  }


  //build a list of users except for the current logged in user 
  //!! IN THE FUTURE NEEDS TO BE CHANGED TO ONLY MATCHS !!

  Widget buildUserList(){
    return StreamBuilder<QuerySnapshot>
    (stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot){
      if(snapshot.hasError){
        return const Text('error');
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text('loading');
      }
      return ListView(
        children: snapshot.data!.docs.map<Widget>((doc) => buildUserListItem(doc)).toList()
      );
    });

  }

// build individual user list items
  Widget buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;

    // dsisplay all users except current one
    if(FirebaseAuth.instance.currentUser?.email != data['email']){
      return ListTile(
        title: Text(data['username']), // show user's username

        // pass the clicked user's email to the chat page

        onTap: ()=> {Get.to(ChatPage(receiverUserEmail: data['email'],
        receiverUsername: data['username'],

        ))}
          
      );
    }
    else{
      return Container();
    }
  }
}