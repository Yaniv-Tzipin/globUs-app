// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import "package:flutter/material.dart";

class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;
  final int maximumLines;
  final IconData prefixIcon;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.maximumLines, required this.prefixIcon
    });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  minLines: 1,
                  maxLines: maximumLines,
                  decoration: InputDecoration(
                    prefixIcon: Icon(prefixIcon),
                    prefixIconColor:  Color.fromARGB(255, 176, 175, 171),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(225,220,232,220)),
                    ),
                    fillColor: Color.fromARGB(255, 245, 249, 244),
                    filled: true,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Color.fromARGB(255, 176, 175, 171)),
                  ),
                ),
              );
  }
}
