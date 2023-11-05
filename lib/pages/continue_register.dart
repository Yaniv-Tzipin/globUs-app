import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_date_picker.dart";
import "package:myfirstapp/components/my_textfield.dart";

class ContinueRegister extends StatefulWidget {
  final String userMail;
  final String userPassword;
  final String userConfirmPassword;
  const ContinueRegister({super.key, 
  required this.userMail,
  required this.userPassword,
  required this.userConfirmPassword,
   });

  @override
  State<ContinueRegister> createState() => _ContinueRegisterState();
}

class _ContinueRegisterState extends State<ContinueRegister> {

  final userNameController = TextEditingController();

  //sign user up method
  void signUserUp() async{

    // check if password is confirmed

    if(widget.userPassword != widget.userConfirmPassword){
      showErrorMessage("passwords don't match");
    }
    else{

    // show sign up circle 
    showDialog(
      context: context,
       builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
       }
      );

    // try creating the user
    try{
    
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: widget.userMail,
      password: widget.userPassword
      );
    //pop the loading circle
    Navigator.pop(context);
    addUserDetails(widget.userMail.trim());

     //go to home-page
    Navigator.pop(context);

    } on FirebaseAuthException catch (e){

    //pop the loading circle
    Navigator.pop(context);
      
    showErrorMessage(e.code);
    
    }
  }
  }

  Future addUserDetails(String email) async{
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'user_name': userNameController.text.trim()
    }
    );
  }


  void showErrorMessage(String message){
    showDialog(context: context,
     builder: (context)
     {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 110, 138, 100),
        title: Center(
          child: Text(message,
          style: TextStyle(color: Colors.white)
          )
        )
      );

     }
     );
  }
 
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: Color.fromARGB(225, 220, 232, 220),
      body: 
      SafeArea(child: 
      Center(child: 
      SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        MyTextField(
              controller: userNameController,
              hintText: 'User Name',
              obscureText: false,
            ),
          const SizedBox(height: 10),
           MyDatePicker(),   
          const SizedBox(height: 10),
          MyButton(onTap: signUserUp,
           text: "Sign Up"),
        ],
        )
      ),
      )
    ),
    );
  }
}