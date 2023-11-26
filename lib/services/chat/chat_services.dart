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
          .set({'${currentUserEmail}_unread': 0, '${receiverEmail}_unread': 0},
              SetOptions(merge: true));
    }

    //update some fields field
    await _fireStore.collection('chat_rooms').doc(uniqueChatRoomID).set({
      'lastMessageTimeStamp': timestamp,
      'firstEmail': currentUserEmail,
      'firstUsername': currentUsername,
      'secondEmail': receiverEmail,
      'secondUsername': receiverUsername
    }, SetOptions(merge: true));

    // updating unread messages info
    await updateUnreadMessagesCount(currentUserEmail, receiverEmail, 1);
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
  Stream<QuerySnapshot> getChatRooms() {
    return _fireStore
        .collection('chat_rooms')
        .snapshots(includeMetadataChanges: true);
  }

  // Get all ChatRomms ordered by timestamo
  Stream<QuerySnapshot> getChatRoomsByTimestamp() {
    String currentUserEmail = _firebaseAuth.currentUser?.email ?? "";
    return _fireStore
        .collection('chat_rooms')
        .orderBy('lastMessageTimeStamp', descending: true)
        .snapshots();
  }

  // a method that updates the number of unread messages into firebase
  // if the user sent a message, add param will be equal to one.
  // Otherwise it will be zero.
  Future<void> updateUnreadMessagesCount(
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
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  // construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
  String getChatRoomId(String currentUserEmail, String receiverEmail) {
    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> emails = [currentUserEmail, receiverEmail];
    // sorting the mails ensures uniqueness
    emails.sort();
    // the chat room unique id is a sorted combination of sender's and receiver's Emails
    return emails.join("_");
  }

  //this method shows how many unread messages the user have
  Widget totalUnreadMessagesCount() {
    String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
    return StreamBuilder(
        stream: getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          try {
            int currentUnread = 0;
            int totalUnread = 0;
            // from all the docs (chatRoom ids) get just those that
            // contain the current username. These are the chats he is part of
            var currentDocs = snapshot.data!.docs
                .where((element) => element.id.contains(currentUserMail));
            for (var doc in currentDocs.toSet()) {
              // getting the number of unread messages
              try {
                Map infoDict = doc.data() as Map;
                currentUnread = infoDict['${currentUserMail}_unread'];
                totalUnread += currentUnread;
              } catch (e) {
                currentUnread = 0;
              }
            }
            return Text(
              totalUnread.toString(),
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
              ),
            );
          } catch (e) {
            return Text('');
          }
        });
  }

  Future<void> createANewChatRoom(String uniqueChatRoomID, String firstEmail, String firstUsername, String secondEmail, String secondUsername) async {
    Map<String, dynamic> data = {
      'firstEmail': firstEmail,
      'firstUsername': firstUsername,
      'secondEmail': secondEmail,
      'secondUsername': secondUsername,
      'lastMessageTimeStamp': Timestamp.now()

    };
    await _fireStore.collection('chat_rooms').doc(uniqueChatRoomID).set(data);
  }
}
