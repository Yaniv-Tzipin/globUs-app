import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget{
  final String imagePath;
  final Function()? onTap;
  const SquareTitle({super.key, required this.imagePath, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(225,220,232,220)
        ),
        child: Image.asset(imagePath,
        height: 40,
        ),
      ),
    );
  }
}


