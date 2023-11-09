import "dart:ffi";

import "package:flutter/material.dart";
import "package:myfirstapp/components/my_colors.dart" as my_colors;

class MyTagsGrid extends StatefulWidget {
  final String tagsTheme;
  final Icon icon;
  
  final List<Widget> listOfTags;
  //final List<InputChip> listOfTags;
   const MyTagsGrid({super.key,
   required this.tagsTheme,
  required this.icon,
  required this.listOfTags
  });

  @override
  State<MyTagsGrid> createState() => _MyTagsGridState();
}

class _MyTagsGridState extends State<MyTagsGrid> {
  @override
  Widget build(BuildContext context) { 
    return Column(
      children: [
         Row(
           children: [
            const SizedBox(width: 20),
            widget.icon,
            const SizedBox(width: 10,),
             _titleContainer(widget.tagsTheme),
           ],
         ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: my_colors.toolBarColor),
            borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 3,
                  runSpacing: 3,
                  children: widget.listOfTags,
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }

  Widget _titleContainer(string ){
    return Text(widget.tagsTheme,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: my_colors.darkGrayFont
    ),
    );
  }
}



    // return  Container(
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [Icon(widget.icon.icon),
    //         Text(
    //         widget.tagsTheme,
    //         )
    //       ],),
          
    //     ],
    //   ),
    //   padding: EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Colors.white),
    //     borderRadius: BorderRadius.circular(16),
    //     color: Color.fromARGB(225,220,232,220)
    //   )
    //   );