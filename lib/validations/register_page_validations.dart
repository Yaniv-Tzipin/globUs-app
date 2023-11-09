import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_alert_dialog.dart';
import 'package:myfirstapp/validations/validate_field_is_filled.dart';

bool validateFormFilled(BuildContext context, bool withGoogle, String email,
    String password, String confirmPassword) {
  // No need to check if fields are filled when pressing on Google icon
  if (withGoogle) {
    return true;
  }
  bool result = isFilled("email", context, email) &&
      isFilled("password", context, password) &&
      isFilled("confirm password", context, confirmPassword);
  return result;
}
