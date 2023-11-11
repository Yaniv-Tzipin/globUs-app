
import "package:flutter/material.dart";
import "package:get/route_manager.dart"; 
import "package:myfirstapp/components/choose_tags_button.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_date_picker.dart";
import "package:myfirstapp/components/my_textfield.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";
import "package:myfirstapp/pages/login_or_register_page.dart";


class ContinueRegister extends StatefulWidget {
  //final String userMail;
  // final String userPassword;
  // final String userConfirmPassword;
  const ContinueRegister({super.key, 
  // required this.userMail,
  // required this.userPassword,
  // required this.userConfirmPassword,
   });

  @override
  State<ContinueRegister> createState() => _ContinueRegisterState();
}

class _ContinueRegisterState extends State<ContinueRegister> {

  final userNameController = TextEditingController();
  final myBioController = TextEditingController();
  

  //navigate to tags page
  void chooseTags() async{
   Get.to(const MyTags());
  }

  void goToLogInPage() async{
    Get.to(const LoginOrRegisterPage());
  }

  //sign user up method
  void signUserUp() async{ // !!!!NEED TO CONSULT WITH NADAV/NOA
  //   // check if passwords are matching
  //   if(widget.userPassword != widget.userConfirmPassword){
  //     showErrorMessage("passwords don't match");
  //   }
  //   else{
  //   // show sign up circle 
  //   showDialog(
  //     context: context,
  //      builder: (context){
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //      }
  //     );

  //   // try creating the user
  //   try{
    
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     email: widget.userMail,
  //     password: widget.userPassword
  //     );
  //   //pop the loading circle
  //   Navigator.pop(context);

  //   addUserDetails(widget.userMail.trim());

  //    //go to home-page
  //   Navigator.pop(context);

  //   } on FirebaseAuthException catch (e){

  //   //pop the loading circle
  //   Navigator.pop(context);
      
  //   showErrorMessage(e.code);
    
  //   }
  // }
  // }

  // Future addUserDetails(String email) async{
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'email': email,
  //     'username': userNameController.text.trim(),
  //     // to add fields
  //   }
  //   );
  // }


  // void showErrorMessage(String message){
  //   showDialog(context: context,
  //    builder: (context)
  //    {
  //     return AlertDialog(
  //       backgroundColor: Color.fromARGB(255, 110, 138, 100),
  //       title: Center(
  //         child: Text(message,
  //         style: TextStyle(color: Colors.white)
  //         )
  //       )
  //     );

  //    }
  //    );
  // }
  }
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.arrow_back),
        onPressed: goToLogInPage,),
        elevation: 0,
        
      ),
      backgroundColor: const Color.fromARGB(225, 220, 232, 220),
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
           const MyDatePicker(),   
          const SizedBox(height: 10),
          MyTextField(
          controller: myBioController,
           hintText: 'Tell about youself',
           maximumLines: 5,
            obscureText: false,
            prefixIcon: Icons.face,),
          const SizedBox(height: 10),
          //MyButton(onTap: chooseTags,
           //text: "Choose Your Tags"),
           GestureDetector(onTap: chooseTags,child: const MyTagsButton(),),
           const SizedBox(height: 10),
          MyButton(onTap: signUserUp,
           text: "Ready to Go"),
           
           
           
        ],
        )
      ),
      )
    ),
    );
  }
}