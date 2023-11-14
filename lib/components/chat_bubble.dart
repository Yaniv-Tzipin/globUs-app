import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Map<String,dynamic> data;
  const ChatBubble({super.key, required this.message, required this.data});

  @override
  Widget build(BuildContext context) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    

    var color = (data['senderEmail'] == _firebaseAuth.currentUser!.email) 
  ? const Color.fromARGB(255, 203, 251, 209) : const Color.fromARGB(255, 233, 192, 148);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color
      ),
      child: Text(message,
      style: const TextStyle(fontSize: 16)),

    );
  }
}