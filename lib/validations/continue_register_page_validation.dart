import 'package:flutter/material.dart';
import 'package:myfirstapp/validations/validate_field_is_filled.dart';

bool validateFormFilled(
BuildContext context, String username, String birthdate, String bio, String originCountry) {
bool result = isFilled("username", context, username) &&
isFilled("birthdate", context, birthdate) &&
isFilled("bio", context, bio) && isFilled("country", context, originCountry);
return result;
}