import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/models/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  // Send Message

  Future<void> sendMessage(String receiverEmail, String message) async {
    // get current user info
    final String currentUserEmail = _firebaseAuth.currentUser?.email ?? "";
    final String currentUsername = await _fireStore
        .collection('users')
        .doc(currentUserEmail)
        .get()
        .then((snapshot) {
      return snapshot.data()!['username'].toString();
    });
    final String receiverUsername = await _fireStore
        .collection('users')
        .doc(receiverEmail)
        .get()
        .then((snapshot) {
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

    // getting the unique chatRoomId
    String uniqueChatRoomID = getChatRoomId(currentUserEmail, receiverEmail);

    // add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(uniqueChatRoomID)
        .collection('messages')
        .add(newMessage.toMap());

    var res =
        await _fireStore.collection('chat_rooms').doc(uniqueChatRoomID).get();
    // checking if the doc fields regarding unread messages don't exist
    // if so we add them 
    if (res.data() == null) {
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(uniqueChatRoomID)
          .set({'${currentUserEmail}_unread': 0, '${receiverEmail}_unread': 0});
    }
    
    // updating unread messages info
    updateUnreadMessagesCount(currentUserEmail, receiverEmail, 1);
  }

// Get Messages
  Stream<QuerySnapshot> getMessages(String userEmail, otherUserEmail) {
    String uniqueChatRoomID = getChatRoomId(userEmail, otherUserEmail);

    return _fireStore
        .collection('chat_rooms')
        .doc(uniqueChatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get ChatRooms
  Stream<QuerySnapshot> getChatRooms(String userEmail, otherUserEmail) {
    return _fireStore.collection('chat_rooms').snapshots();
  }

  // a method that updates the number of unread messages into firebase 
  // if the user sent a message, add param will be equal to one. 
  // Otherwise it will be zero.
  void updateUnreadMessagesCount(
      String currentUserEmail, String receiverEmail, int add) async {
    try {
      String uniqueChatRoomID = getChatRoomId(currentUserEmail, receiverEmail);
      // getting the relevant doc
      var res =
          await _fireStore.collection('chat_rooms').doc(uniqueChatRoomID).get();
      if (res.data() != null) {
        var item = res.data()!;
        // extracting the relevant information
        int recieverUnread = item['${receiverEmail}_unread'];
        // updating the relevant information - the user that sends the message
        // is up to date and does not have unread messages
        // the reciever has a new unread message

        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(uniqueChatRoomID)
            .set({
          '${currentUserEmail}_unread': 0,
          '${receiverEmail}_unread': recieverUnread + add
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
  String getChatRoomId(String currentUserEmail, String receiverEmail)
  {
    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> emails = [currentUserEmail, receiverEmail];
    // sorting the mails ensures uniqueness
    emails.sort();
    // the chat room unique id is a sorted combination of sender's and receiver's Emails
    return emails.join("_");
  }
}
