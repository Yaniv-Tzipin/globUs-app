import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/components/my_match_card.dart';
import 'package:myfirstapp/models/user.dart';
import 'package:myfirstapp/services/chat/chat_services.dart';

class MatchesService {
//get instance of auth, chat service and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  late int sharedTags;
  late double swipingScore;
  late int ageDiff;
  late int countryCoeff;
  late double rank; // will hold the rank of the current potential match
  late dynamic distance;
  num distancWeight;
  num tagsWeight;
  num originCountryWeight;
  num ageWeight;
  num swipeWeight;

  // will hold the emails of the potential matches
  late List<dynamic> potentialMatchesEmails;
  late List<dynamic> currentUserMatches;
  late List<dynamic> currentUserSwipedRight;
  late List<dynamic> currentUserSwipedLeft;
  late List<MyMatchCard> cards;

// initiating a constructor with the formula default weights
// in the future, relate to the option of customed weights
  MatchesService(
      {this.distancWeight = 50,
      this.tagsWeight = 30,
      this.originCountryWeight = 7,
      this.ageWeight = 10,
      this.swipeWeight = 3});

  void scalePreferences(Map<String, dynamic> userPreferences) {
// will hold the sum of all rangeSliders values
    num sum = 0;
    for (String key in userPreferences.keys) {
      sum += userPreferences[key];
    }

    // if sum == 0 don't do anything and use the default weights
    if (sum != 0) {
      // getting the customed preferences
      ageWeight = userPreferences['Age'] / sum * 100;
      distancWeight = userPreferences['Location'] / sum * 100;
      originCountryWeight = userPreferences['Origin country'] / sum * 100;
      swipeWeight = userPreferences['Other Party Swipe'] / sum * 100;
      tagsWeight = userPreferences['Shared tags'] / sum * 100;
    }
  }

  // a method that sets the user preferences if they exist
  void setCustomedWeights(AsyncSnapshot<dynamic> snapshot2) {
    try {
      Map<String, dynamic> userPreferences = snapshot2.data!.get('preferences');
      // scaling the preferences so that they will sum up to 100
      scalePreferences(userPreferences);
    } catch (e) {
      // if the user did not change the preferences we will reach here
      // and we will use the default values that we defined in the constructor
      print(e);
    }
  }

  void calcGrade(DocumentSnapshot document) {
// will hold the potential match fields
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    UserProfile potentialMatch = UserProfile(data);
    potentialMatch.originCountry == currentUser.originCountry
        ? countryCoeff = 1
        : countryCoeff = 0;
    swipingScore = scoreBasedOnSwiping(
        potentialMatch.swipedLeft, potentialMatch.swipedRight);
    sharedTags = sharedTagsAmount(potentialMatch.tags);
    ageDiff = getAgeDiff(potentialMatch.age);
    distance = calcDistance(potentialMatch.latitude, potentialMatch.longitude);
    rank = getFinalRank();

// updating the potential matches cards list
    cards.add(MyMatchCard(
        cardRanking: rank,
        userEmail: potentialMatch.email,
        distance: distance));
  }

  dynamic calcDistance(String potentialMatchLat, String potentialMatchLong) {
    double distanceInMeters;
    if (potentialMatchLat == "" ||
        potentialMatchLong == "" ||
        currentUser.latitude == "" ||
        currentUser.longitude == "") {
      return "";
    } else {
      try {
        distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
            double.parse(potentialMatchLat),
            double.parse(potentialMatchLong),
            double.parse(currentUser.latitude),
            double.parse(currentUser.longitude));
      } catch (e) {
        print(e);
        return "";
      }
      return distanceInMeters / 1000;
    }
  }

// A method that returns the number of shared tags between the current
// user and the current potential match
  int sharedTagsAmount(List<dynamic> potentialMatchtags) {
    int sharedTagsCounter = 0;
    for (String tag in currentUser.tags) {
      if (potentialMatchtags.contains(tag)) {
        sharedTagsCounter++;
      }
    }
    return sharedTagsCounter;
  }

// A method that returns the age difference between the current user and the
// current potential match
  int getAgeDiff(int potentialMatchAge) {
    return (potentialMatchAge - currentUser.age).abs();
  }

// A method that checks if the current user and the current potential match
// have already swiped each other and gives a suitable score
  double scoreBasedOnSwiping(List<dynamic> potentialMatchSwipedLeft,
      List<dynamic> potentialMatchSwipedRight) {
// the potential match swiped the current user left

// todo: check if the matches list will contain emails/usernames/something else...
    if (potentialMatchSwipedLeft.contains(currentUser.email)) {
      return 0;
    }
// the potential match swiped the current user right
    if (potentialMatchSwipedRight.contains(currentUser.email)) {
      return swipeWeight.toDouble();
    }
// the potential match has not swiped the current user yet
    return (swipeWeight / 2).toDouble();
  }

  double getFinalRank() {
    num distanceInfluence = distance == ""
        ? 0
        : ((distancWeight - distance * (distancWeight / 20000)));
    return (tagsWeight / 10) * sharedTags +
        distanceInfluence +
        (ageWeight - ageDiff * (ageWeight / 81)) +
        countryCoeff * originCountryWeight +
        swipingScore;
  }

//get potential matches
  void loadPotenitalMatches(
      AsyncSnapshot<dynamic> snapshot1, AsyncSnapshot<dynamic> snapshot2) {
    try {
      // setting user customed weights if they exist
      // otherwise using the default weights
      setCustomedWeights(snapshot2);
      cards = [];
      potentialMatchesEmails = [];
      currentUserMatches = [];
      currentUserSwipedRight = [];
      currentUserSwipedLeft = [];
// retrieving the relevant data regarding current user
      currentUserMatches = snapshot2.data!.get('matches');
      currentUserSwipedRight = snapshot2.data!.get('swipedRight');
      currentUserSwipedLeft = snapshot2.data!.get('swipedLeft');
// looping through all existing users and adding just
// the potential matches to the list
      for (DocumentSnapshot doc in snapshot1.data!.docs) {
        String currentDocEmail = doc.get('email');
        if (currentDocEmail != _firebaseAuth.currentUser?.email &&
            !currentUserMatches.contains(currentDocEmail) &&
            !currentUserSwipedRight.contains(currentDocEmail) &&
            !currentUserSwipedLeft.contains(currentDocEmail)) {
          potentialMatchesEmails.add(currentDocEmail);
          calcGrade(doc);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  List<MyMatchCard> getCards() {
    return cards;
  }

  Future<bool> checkIfAMatch(
      String currentUserEmail, String cardsOwnerEmail) async {
    // check if both users swiped right and if so - open a chat room

    try {
      var cardsOwnerRightSwipes = await _fireStore
          .collection('users')
          .doc(cardsOwnerEmail)
          .get()
          .then((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data['swipedRight'];
      });
      if (cardsOwnerRightSwipes.contains(currentUserEmail)) {
        String secondUsername = await _fireStore
            .collection('users')
            .doc(cardsOwnerEmail)
            .get()
            .then((snapshot) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return data['username'];
        });
        //create a chat room
        String chatRoomId =
            _chatService.getChatRoomId(currentUserEmail, cardsOwnerEmail);
        await _chatService.createANewChatRoom(
            chatRoomId,
            cardsOwnerEmail,
            secondUsername,
            currentUserEmail,
            _firebaseAuth.currentUser?.email ?? "");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> addMatch(String currentEmail, String cardsOwnerEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'matches': FieldValue.arrayUnion([cardsOwnerEmail])
    }, SetOptions(merge: true));
  }

  Future<void> deleteSwipedRight(
      String currentEmail, String cardsOwnerEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedRight': FieldValue.arrayRemove([cardsOwnerEmail])
    }, SetOptions(merge: true));
  }

  Future<void> addSwipedRight(String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedRight': FieldValue.arrayUnion([otherEmail])
    }, SetOptions(merge: true));
  }

  Future<void> addSwipedLeft(String currentEmail, String otherEmail) async {
    await FirebaseFirestore.instance.collection('users').doc(currentEmail).set({
      'swipedLeft': FieldValue.arrayUnion([otherEmail])
    }, SetOptions(merge: true));
  }
}
