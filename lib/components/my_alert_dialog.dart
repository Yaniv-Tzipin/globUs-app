import "package:flutter/material.dart";

class MyAlertDialog extends StatelessWidget {
final String message;

const MyAlertDialog({super.key, required this.message});

@override
Widget build(BuildContext context) {
return AlertDialog(
backgroundColor: Colors.pink[300],
title: Text("An error occurred"),
content: Text(message),
actions: [
MaterialButton(
onPressed: () {
Navigator.pop(context);
},
child: Text("OK"))
],
);
}
}