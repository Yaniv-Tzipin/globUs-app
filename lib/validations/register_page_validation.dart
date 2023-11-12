import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_alert_dialog.dart';
import 'package:myfirstapp/validations/validate_field_is_filled.dart';

bool validateFormFilled(BuildContext context, String email,
String password, String confirmPassword) {
bool result = isFilled("email", context, email) &&
isFilled("password", context, password) &&
isFilled("confirm password", context, confirmPassword);
return result;
}