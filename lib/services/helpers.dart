import 'package:age_calculator/age_calculator.dart';

int  calcAge(DateTime birthDate){
  return AgeCalculator.age(birthDate).years;
}