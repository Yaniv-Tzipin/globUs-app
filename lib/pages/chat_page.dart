import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/chat_bubble.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUsername;
  final ScrollController scrollController;
  final UserImageIcon userImageIcon;
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUsername,
      required this.scrollController,
      required this.userImageIcon});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send if there's something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserEmail, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentUserMail = _firebaseAuth.currentUser?.email ?? "";
    // the user opened the chat so updating the unread messages num to zero
    _chatService.updateUnreadMessagesCount(
        currentUserMail, widget.receiverUserEmail, 0);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _chatService.totalUnreadMessagesCount();
              Navigator.pop(context);
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: widget.userImageIcon,
          )
        ],
        title: Text(widget.receiverUsername),
        backgroundColor: const Color.fromARGB(255, 181, 213, 182),
        elevation: 0,
      ),
      body: Column(children: [
        // messages
        Expanded(child: _buildMessagesList()),
        // user input
        _buildMessageInput(),
      ]),
    );
  }

// build message list
  Widget _buildMessagesList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserEmail, _firebaseAuth.currentUser!.email),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          // Scroll to the bottom of the list tile
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.scrollController.jumpTo(
              widget.scrollController.position.maxScrollExtent,
            );
          });
          return ListView(
            controller: widget.scrollController,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

// build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser!.email)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment:
                (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                mainAxisAlignment:
                    (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  Text(TimeOfDay.now().format(context)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    data['senderUsername'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ChatBubble(message: data['message'], data: data)
            ]),
      ),
    );
  }

// build message input
  Widget _buildMessageInput() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 215, 234, 216),
      ),
      child: Row(
        children: [
          // text field
          Expanded(
              child: MyTextField(
            controller: _messageController,
            hintText: 'Enter your message',
            obscureText: false,
            maximumLines: 7,
            prefixIcon: Icons.message,
          )),

          // send button
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon:
                  const Icon(Icons.arrow_upward, size: 40, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
