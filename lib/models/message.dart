
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderEmail;
  final String receiverEmail;
  final String senderUsername;
  final String receiverUsername;
  final String message;
  final Timestamp timestamp;


  Message({
    required this.senderEmail,
    required this.receiverEmail,
    required this.senderUsername,
    required this.receiverUsername,
    required this.message,
    required this.timestamp

  });


  Map<String, dynamic> toMap(){
    return{
      'senderEmail' : senderEmail,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timestamp
    };
  }


}