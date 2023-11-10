
import "package:flutter/material.dart";

class UserDataProvider extends ChangeNotifier{
  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;


void setUserStatus(){
  _isNewUser = true;
  notifyListeners();
}


}

