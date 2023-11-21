import 'package:flutter/material.dart';

class MyMatchCard extends StatefulWidget {
  final double cardRanking;
  final String userEmail;
  const MyMatchCard({super.key, 
  required this.cardRanking, 
  required this.userEmail});

  @override
  State<MyMatchCard> createState() => _MyMatchCardState();
}

class _MyMatchCardState extends State<MyMatchCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}