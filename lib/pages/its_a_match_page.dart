import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/pages/chat_page.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';

class ItsAMatchPage extends StatefulWidget {
  final String currentUserEmail;
  final String cardsOwnerEmail;
  const ItsAMatchPage(
      {super.key,
      required this.currentUserEmail,
      required this.cardsOwnerEmail});

  @override
  State<ItsAMatchPage> createState() => _ItsAMatchPageState();
}

class _ItsAMatchPageState extends State<ItsAMatchPage> {
  @override
  Widget build(BuildContext context) {
    return ItsAMatchWidget(
        currentUserEmail: widget.currentUserEmail,
        cardsOwnerEmail: widget.cardsOwnerEmail);
  }
}

class ItsAMatchWidget extends StatefulWidget {
  final String currentUserEmail;
  final String cardsOwnerEmail;

  const ItsAMatchWidget({
    super.key,
    required this.currentUserEmail,
    required this.cardsOwnerEmail,
  });

  @override
  State<ItsAMatchWidget> createState() => _ItsAMatchWidgetState();
}

class _ItsAMatchWidgetState extends State<ItsAMatchWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //first profile pic
            UserImageIcon(userMail: widget.currentUserEmail, size: 100,),
            const SizedBox(width: 50),
            UserImageIcon(userMail: widget.cardsOwnerEmail, size: 100,)
            //second profile pic
          ],
        ),
        Image.asset(
          'lib/images/itsamatch.png',
          width: 300,
          height: 300,
        ),

        // keep swiping button
        MyButton(onTap: () => Navigator.pop(context), text: 'Continue Swiping'),
        const SizedBox(height: 15,),
        const Text(
          'A new chat room is open! Now you can chat with your match 💬',
          style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 244, 170, 74)),
            textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
