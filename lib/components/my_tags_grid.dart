import "dart:ffi";

import "package:flutter/material.dart";

class MyTagsGrid extends StatefulWidget {
  final String tagsTheme;
  final Icon icon;
  
  final List<Widget> listOfTags;
  //final List<InputChip> listOfTags;
   MyTagsGrid({super.key,
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
              border: Border.all(),
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