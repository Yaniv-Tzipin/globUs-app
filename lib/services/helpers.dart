import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int  calcAge(DateTime birthDate){
  return AgeCalculator.age(birthDate).years;
}

Timestamp parseStringToTimestamp(String birthDate){
  return Timestamp.fromMillisecondsSinceEpoch(DateTime.parse(birthDate).millisecondsSinceEpoch);
}