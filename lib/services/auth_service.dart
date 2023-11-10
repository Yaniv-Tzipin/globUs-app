import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfirstapp/pages/auth_page.dart';
import 'package:myfirstapp/providers/auth_status_provider.dart' as ASP;
import 'package:myfirstapp/providers/auth_status_provider.dart';

class AuthService{

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
  // AuthStateChanges().setUserCredential(user);
  AuthPage();

  //finally, lets sign in
  return user;
 
  }


  


}


