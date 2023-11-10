import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfirstapp/pages/continue_register.dart';
import 'package:myfirstapp/pages/home_page.dart';
import 'package:myfirstapp/providers/user_data_provider.dart';

class AuthService {

//sign-in with google
signInWithGoogle() async {

  // begin interactive sign in process
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  // obtain auth details from request
  final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  // create a new credential for user
  final credential = GoogleAuthProvider.credential(
    accessToken: gAuth.accessToken,
    idToken: gAuth.idToken
  );

  UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

  bool isNewUser = user.additionalUserInfo!.isNewUser;


  //bypassing the stream !!!This check is not suficient when restarting the app,
  //need to access the data base
  if(isNewUser){
    //setting our user manegment Provider
    UserDataProvider().setUserStatus();

    //continue registering
    Get.to(const ContinueRegister());
    }
}

  //finally, lets sign in
  //return user;


  Future<bool> checkIfUserCompletedSigningUp() async{
    // use 
    //FirebaseAuth.instance.currentUser!.email;

    //need to check if the user completed signing up and if not:
    //Get.to(const ContinueRegister());

 return true;  
    
}

 
  }


