import 'package:myfirstapp/services/helpers.dart';

class UserProfile{
  late String firstName;
  late String lastName;
  late int age;
  late String originCountry;
  late String bio;
  late String profileImagePath;

  UserProfile(Map<String, dynamic> userData){
    firstName = userData['first_name'];
    lastName = userData['last_name'];
    age = calcAge(DateTime.fromMillisecondsSinceEpoch(userData['birth_date'].millisecondsSinceEpoch));
    originCountry = userData['country'];
    bio = userData['bio'];
    profileImagePath =userData['profile_image'];
  }
}


//what about tags?
//country?