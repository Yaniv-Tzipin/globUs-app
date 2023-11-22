import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/components/my_match_card.dart';
import 'package:myfirstapp/models/user.dart';

class MatchesService {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late int sharedTags;
  late double swipingScore;
  late int ageDiff;
  late int countryCoeff;
  late double rank; // will hold the rank of the current potential match
  late double distance;
  final int distancWeight;
  final int tagsWeight;
  final int originCountryWeight;
  final int ageWeight;
  final int swipeWeight;

  // will hold the emails of the potential matches
  late List<dynamic> potentialMatchesEmails = [];
  late List<dynamic> currentUserMatches = [];
  late List<dynamic> currentUserSwipedRight = [];
  late List<dynamic> currentUserSwipedLeft = [];
  late List<MyMatchCard> cards = [];

  // initiating a constructor with the formula default weights
  // in the future, relate to the option of customed weights
  MatchesService(
      {this.distancWeight = 50,
      this.tagsWeight = 30,
      this.originCountryWeight = 7,
      this.ageWeight = 10,
      this.swipeWeight = 3});

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
    // todo: change it to a distance method when we choose a suitable package
    distance = 0;
    rank = getFinalRank();
    // updating the potential matches cards list
    cards.add(MyMatchCard(cardRanking: rank, userEmail: potentialMatch.email));
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
    return (tagsWeight / 10) * sharedTags +
        (distancWeight - distance * (distancWeight / 20000)) +
        (ageWeight - ageDiff * (ageWeight / 81)) +
        countryCoeff * originCountryWeight +
        swipingScore;
  }

  //get potential matches
  void loadPotenitalMatches(
      AsyncSnapshot<dynamic> snapshot1, AsyncSnapshot<dynamic> snapshot2) {
    try {
      // retrieving the relevant data regarding current user
      currentUserMatches = snapshot2.data!.get('matches');
      currentUserSwipedRight = snapshot2.data!.get('swipedRight');
      currentUserSwipedLeft = snapshot2.data!.get('swipedLeft');
      // looping through all existing users and adding just
      // the potential matches to the list
      for (DocumentSnapshot doc in snapshot1.data!.docs) {
        String currentDocEmail = doc.get('email');
        if (currentDocEmail != currentUser.email &&
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

  List <MyMatchCard> getCards()
  {
    return cards;
  }
}
