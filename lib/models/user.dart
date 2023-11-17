import 'package:myfirstapp/services/helpers.dart';

class UserProfile{
  late String username;
  late int age;
  late String originCountry; //CONSIDER ADDING LOCATION SERVICES
  late String bio;
  late String profileImagePath;

  UserProfile(Map<String, dynamic> userData){
    username = userData['username'];
    //!!! to talk with Noa about this 
    age = calcAge(DateTime.fromMillisecondsSinceEpoch(userData['birth_date'].millisecondsSinceEpoch));
    originCountry = userData['country'];
    bio = userData['bio'];
    profileImagePath = userData['profile_image'] ?? "";
   
  }
}


//what about tags?
