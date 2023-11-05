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
  final myBioController = TextEditingController();

  //sign user up method
  void signUserUp() async{

    // check if passwords are matching
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
      'username': userNameController.text.trim(),
      // to add fields
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
              hintText: 'Username',
              obscureText: false,
              maximumLines: 1,
              prefixIcon: Icons.person,

            ),
          const SizedBox(height: 10),
           MyDatePicker(),   
          const SizedBox(height: 10),
          MyTextField(
          controller: myBioController,
           hintText: 'Tell about youself',
           maximumLines: 5,
            obscureText: false,
            prefixIcon: Icons.face,),
          const SizedBox(height: 10),
          MyButton(onTap: signUserUp,
           text: "Sign Up"),
           const SizedBox(height: 10),
           
        ],
        )
      ),
      )
    ),
    );
  }
}