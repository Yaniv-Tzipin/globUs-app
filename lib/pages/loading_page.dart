import "package:flutter/material.dart";
import "package:myfirstapp/pages/auth_page.dart";
import "package:myfirstapp/pages/continue_register.dart";
import "package:myfirstapp/pages/home_page.dart";
import "package:myfirstapp/services/auth_service.dart";



class MyLoadingPage extends StatefulWidget {
  const MyLoadingPage({super.key});

  @override
  State<MyLoadingPage> createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {

  late bool isNewUser; 

// update users' status (new or completed sign up proccess)
Future<void> getUserData() async {  
 isNewUser =  await AuthService().checkIfUserCompletedSigningUp(); 
 print('get user data');
}
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: FutureBuilder(
      future:  getUserData(),  
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
       {
        //show loading progress - *CONSIDER TO CHANGE TO ANOTHER PAGE*
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        // if the user is new -> continue register
        else if(isNewUser){ 
          print(isNewUser);
          return const ContinueRegister();     
        }

        // else -> homepage(snapshot alreay has data so it's possible)
        
        else if(!isNewUser){
          print('homepage');
           return HomePage(); 
        }

        //in a case of error *consider going to loginorregisterpage*
        return AuthPage(); //ContinueRegister();
           
       }),
    );
  }
} 