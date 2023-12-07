import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_match_card.dart';
import 'package:myfirstapp/pages/its_a_match_page.dart';
import 'package:myfirstapp/services/matches_service.dart';
import 'package:myfirstapp/globals.dart';

class MatchingBoard extends StatefulWidget {
  const MatchingBoard({super.key});

  @override
  State<MatchingBoard> createState() => _MatchingBoardState();
}

class _MatchingBoardState extends State<MatchingBoard> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final MatchesService _matchService = MatchesService();
  final CardSwiperController swiperController = CardSwiperController();
  final String currUser = FirebaseAuth.instance.currentUser?.email ?? "";

  late List<MyMatchCard> cards;

  @override
  void dispose() {
    super.dispose();
    swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
// will listen to all users collection
        stream: _fireStore.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot1) {
          if(snapshot1.hasError){
            return const Text('error');
          }
          if(snapshot1.connectionState == ConnectionState.waiting){
            return const Text('loading...');
          }
// will listen just to the current user
          return StreamBuilder(
              stream: _fireStore
                  .collection('users')
                  .doc(currUser)
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                if (snapshot2.hasError) {
                  return const Text('error');
                }
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return const Text('loading...');
                }
// updating cards list to containg potential matches
                _matchService.loadPotenitalMatches(snapshot1, snapshot2);
                cards = _matchService.getCards();
// sorting the cards by ranking
                cards.sort();

                if (cards.isEmpty) {
                  return  const Text('Come back soon to find some new matches 👻',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,);
                  
                } 
                else {
                  if(cards.length > 1){
                    cards = cards.sublist(0,2);
                  }
                  return Scaffold(
                    backgroundColor: const Color.fromARGB(255, 203, 228, 204),
                      body: SafeArea(
                    child: Column(children: [
                      Flexible(
                          child: CardSwiper(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(24.0),
                        isLoop: false,
                        controller: swiperController,
                        onSwipe: _onSwipe,
                        backCardOffset: const Offset(0, 0),
                        allowedSwipeDirection: AllowedSwipeDirection.only(
                            down: false, up: false, right: true, left: true),
                        cardBuilder: (context,
                                index,
                                horizontalThresholdPercentage,
                                verticalThresholdPercentage) =>
                            cards[index],
                        cardsCount: cards.length,
                        numberOfCardsDisplayed: cards.length,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: swipeCardLeftWithBotton,
                              icon: const Icon(Icons.cancel),
                              iconSize: 60,
                              color: const Color.fromARGB(255, 209, 201, 194),
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            IconButton(
                              onPressed: swipeCardRightWithBotton,
                              icon: const Icon(Icons.favorite_rounded),
                              iconSize: 60,
                              color: const Color.fromARGB(255, 240, 119, 105),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ));
                }
              });
        });
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    String cardsOwnerEmail = cards[previousIndex].userEmail;
    (direction == CardSwiperDirection.right)
        ? swipeCardRightWithoutBotton(cardsOwnerEmail)
        : swipeCardLeftWithoutBotton(cardsOwnerEmail);

    return true;
  }

// will trigger _onSwipe method
  void swipeCardLeftWithBotton() async {
    swiperController.swipeLeft();
  }

// will trigger _onSwipe method
  void swipeCardRightWithBotton() async {
    swiperController.swipeRight();
  }

  Future<void> swipeCardLeftWithoutBotton(String cardsOwnerEmail) async {
    _matchService.addSwipedLeft(currentUser.email, cardsOwnerEmail);
  }

  Future<void> swipeCardRightWithoutBotton(String cardsOwnerEmail) async {
//if it's a match the chat service creates a chat room
    bool isAMatch =
        await _matchService.checkIfAMatch(currentUser.email, cardsOwnerEmail);
    if (isAMatch) {
      //upsate the matches list in DB
      Get.to(ItsAMatchPage(currentUserEmail: currentUser.email, cardsOwnerEmail: cardsOwnerEmail,));
      await _matchService.addMatch(currentUser.email, cardsOwnerEmail);
      await _matchService.addMatch(cardsOwnerEmail, currentUser.email);
      await _matchService.deleteSwipedRight(cardsOwnerEmail, currentUser.email);
      

      //dothings - to create a pop up page
    } else {
      //add to current user's swiped right list in DB
      await _matchService.addSwipedRight(currentUser.email, cardsOwnerEmail);
    }
  }
}
