
import "package:flutter/material.dart";
import "package:myfirstapp/services/auth_service.dart";


//this provider will provide user's data and notify listeners//
//Importent: users' data quries won't be implemented here, BUT
//the outcome of the query will be stored here//

class UserDataProvider extends ChangeNotifier{

  // efault val
  bool _isNewUser = false;

  // get user's status: new or completed register
  bool get isNewUser => _isNewUser;

// set users' status
Future<void> getUserStatus() async{
  notifyListeners();
  _isNewUser = await AuthService().checkIfUserCompletedSigningUp(); 
  
}

}

