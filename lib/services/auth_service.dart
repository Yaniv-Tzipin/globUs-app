import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  bool isNewUser = await checkIfUserCompletedSigningUp();

 // finally, lets sign in
   return user;
}

// return if user's mail is in the 'completed sign up' table in Firebase
  Future<bool> checkIfUserCompletedSigningUp() async{

    // get users' mail 
    String? userMail =  FirebaseAuth.instance.currentUser?.email;

    //Firebase query
    try {
    DocumentSnapshot<Map<String, dynamic>>  doc = await FirebaseFirestore.instance
        .collection('completed_sign_in')
        .doc(userMail)
        .get();

    //!doc.exists == user is new and hasn't completed sign-up proccess    
    return  !doc.exists;
    } catch (e) {
    print(e.toString());
    return false;
  }
    
}




}


