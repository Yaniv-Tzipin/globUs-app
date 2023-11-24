import 'package:flutter/material.dart';
import 'package:myfirstapp/globals.dart';

class ProfileWidget extends StatelessWidget{
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 40, 0),
            child: Stack(children: [
              buildImage(),
              Positioned(
                bottom: 0,
                right: 0,
                child:
                    buildIcon(color: const Color.fromARGB(255, 156, 204, 101)),
              ),
            ]),
          ),
        ],
      );
  }

    Widget buildIcon({required Color color}) {
    return buildCircle(
      color: Colors.white,
      all: 3.0,
      child: buildCircle(
          color: color,
          child: Icon(isEdit ? Icons.add_a_photo :Icons.edit, 
              color: Colors.white,
              size: 20),
          all: 8.0),
    );
  }

  Widget buildCircle(
      {required Widget child, required Color color, required double all}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(currentUser.profileImagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent, // why?
        child:
            Ink.image(
              image: image, 
              fit: BoxFit.cover, 
              width: 128, 
              height: 128,
              child: InkWell(onTap: onClicked),
              ),
      ),
    );
  }

}