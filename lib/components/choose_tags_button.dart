import "package:flutter/material.dart";
import "package:myfirstapp/components/my_colors.dart";
import 'package:myfirstapp/providers/my_tags_provider.dart';
import "package:provider/provider.dart";

class MyTagsButton extends StatelessWidget {
  const MyTagsButton({super.key});

  @override
  Widget build(BuildContext context) {
  final tagsCounter = Provider.of<MyTagsProvider>(context);

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 240,
          height: 55,
          decoration: BoxDecoration(
            color:Color.fromARGB(255, 245, 249, 244),
            borderRadius: BorderRadius.circular(8),  
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical:9.0),
            child: Row(
              children: [
                SizedBox(width: 10,),
                Icon(Icons.new_label,
                color: Color.fromARGB(255, 176, 175, 171),),
                Text('        Choose your tags',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 176, 175, 171)
                )),
                
              ],
            ),
          ),
        ),
        const SizedBox(width: 30,),
        Container(
          height: 55,
          width: 60,
           decoration: BoxDecoration(
            color:const Color.fromARGB(255, 245, 249, 244),
            borderRadius: BorderRadius.circular(8), 
           ),
          child: Column(
            children: [
              const SizedBox(height: 18,),
              Text('${tagsCounter.count}/10',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selectedTagColor
              ),),
            ],
          )
          ),
      ],
    ),
    );
  
}
}
