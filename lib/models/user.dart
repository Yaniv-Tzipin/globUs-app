import 'package:myfirstapp/services/helpers.dart';

class UserProfile{
late String email;
late String username;
late int age;
late String originCountry; //CONSIDER ADDING LOCATION SERVICES
late String bio;
late String profileImagePath;
late List<dynamic> tags;
late List<dynamic> matches;
late List<dynamic> swipedRight;
late List<dynamic> swipedLeft;
late String latitude;
late String longitude;



UserProfile(Map<String, dynamic> userData){
email = userData['email'];
username = userData['username'];
//!!! to talk with Noa about this
age = calcAge(DateTime.fromMillisecondsSinceEpoch(userData['birth_date'].millisecondsSinceEpoch));
originCountry = userData['country'];
bio = userData['bio'];
profileImagePath = userData['profile_image'] ?? "";
tags = userData['tags'];
matches = userData['matches'] ?? [];
swipedRight = userData['swipedRight'] ?? [];
swipedLeft = userData['swipedLeft'] ?? [];
latitude = userData['latitude'] ?? "";
longitude = userData['longitude'] ?? "";

}


}