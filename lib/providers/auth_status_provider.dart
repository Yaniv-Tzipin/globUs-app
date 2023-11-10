import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/services/auth_service.dart";

class AuthStateChanges extends ChangeNotifier{

  //UserCredential user = AuthService().signInWithGoogle();
  bool _userLoggedInWithGoogle = false;
  bool get userLoggedInWithGoogle => _userLoggedInWithGoogle;


// bool checkIfExistingUser(){
//  notifyListeners();
//  //return !user.additionalUserInfo!.isNewUser;
// }

// void setUserCredential(UserCredential recievedUser){
//   user = recievedUser;
//   _userLoggedInWithGoogle = true;
//   notifyListeners();
//   print('done');
// }


}