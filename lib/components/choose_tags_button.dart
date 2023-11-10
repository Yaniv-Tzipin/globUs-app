import "package:flutter/material.dart";
import "package:myfirstapp/components/my_colors.dart";
import "package:myfirstapp/providers/my_provider.dart";
import "package:provider/provider.dart";

class MyTagsButton extends StatelessWidget {
  const MyTagsButton({super.key});

  @override
  Widget build(BuildContext context) {
  final tagsCounter = Provider.of<MyProvider>(context);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:9.0),
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
        SizedBox(width: 30,),
        Container(
          height: 55,
          width: 60,
          child: Column(
            children: [
              SizedBox(height: 18,),
              Text(tagsCounter.count.toString()+'/10',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selectedTagColor
              ),),
            ],
          ),
           decoration: BoxDecoration(
            color:Color.fromARGB(255, 245, 249, 244),
            borderRadius: BorderRadius.circular(8), 
           )
          ),
      ],
    ),
    );
  
}
}


// Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: TextField(
//                   controller: controller,
//                   obscureText: obscureText,
//                   minLines: 1,
//                   maxLines: maximumLines,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(prefixIcon),
//                     prefixIconColor:  Color.fromARGB(255, 176, 175, 171),
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color.fromARGB(225,220,232,220)),
//                     ),
//                     fillColor: Color.fromARGB(255, 245, 249, 244),
//                     filled: true,
//                     hintText: hintText,
//                     hintStyle: TextStyle(color: Color.fromARGB(255, 176, 175, 171)),
//                   ),
//                 ),
//               );
//   }