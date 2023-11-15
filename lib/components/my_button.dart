

import "package:flutter/material.dart";

class MyButton extends StatelessWidget{

  final Function()? onTap;
  final String text;

   const MyButton({super.key, required this.onTap, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 90, 118, 85),
          borderRadius: BorderRadius.circular(8)
          ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
          ),
        )
      ),
    );
  }
}