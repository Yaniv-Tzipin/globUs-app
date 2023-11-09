import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_alert_dialog.dart';

bool isFilled(String fieldName, BuildContext context, String fieldVal) {
  if (fieldVal == "") {
    showDialog(
        context: context,
        builder: (context) =>
            MyAlertDialog(message: "$fieldName field cannot be empty"));
    return false;
  }
  return true;
} 