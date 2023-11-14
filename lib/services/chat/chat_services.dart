import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/models/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Send Message

  Future<void> sendMessage(String receiverEmail, String message) async{
    // get current user info
    final String currentUserEmail = _firebaseAuth.currentUser?.email ?? "";
    final String currentUsername = await _fireStore.collection('users').doc(currentUserEmail).get().then((snapshot){
        return snapshot.data()!['username'].toString();
    });
    final String receiverUsername = await _fireStore.collection('users').doc(receiverEmail).get().then((snapshot){
        return snapshot.data()!['username'].toString();
    });
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp, 
        senderUsername: currentUsername, 
        receiverUsername: receiverUsername);

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)

    List<String> emails = [currentUserEmail,receiverEmail];

    // sorting the mails ensures uniqueness
    emails.sort();

    // the chat room unique id is a sorted combination of sender's and receiver's Emails
    String uniqueChatRoomID = emails.join("_");


    // add new message to database
    await _fireStore
    .collection('chat_rooms')
    .doc(uniqueChatRoomID)
    .collection('messages')
    .add(newMessage.toMap());

  }


// Get Messages
Stream<QuerySnapshot> getMessages(String userEmail, otherUserEmail){
  //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
  List<String> emails = [userEmail,otherUserEmail];
  emails.sort();
  String uniqueChatRoomID = emails.join("_");


  return _fireStore
  .collection('chat_rooms')
  .doc(uniqueChatRoomID)
  .collection('messages')
  .orderBy('timestamp', descending: false)
  .snapshots();
}

}
