import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:myfirstapp/components/my_match_card.dart';
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
  late List<MyMatchCard> cards = [];

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
// will listen just to the current user
          return StreamBuilder(
              stream: _fireStore
                  .collection('users')
                  .doc(currentUser.email)
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                if (snapshot1.hasError || snapshot2.hasError) {
                  return const Text('error');
                }
                if (snapshot1.connectionState == ConnectionState.waiting ||
                    snapshot2.connectionState == ConnectionState.waiting) {
                  return const Text('loading...');
                }
// initializing cards to an empty list
                cards = [];
// updating cards list to containg potential matches
                _matchService.loadPotenitalMatches(snapshot1, snapshot2);
                cards = _matchService.getCards();
// sorting the cards by ranking
                cards.sort();

// for (MyMatchCard card in cards) {
// print(card.userEmail);
// print(card.cardRanking);
// }
                return Scaffold(
                    body: SafeArea(
                  child: Column(children: [
                    Flexible(
                        child: CardSwiper(
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
                            onPressed: swipeCardLeft,
                            icon: const Icon(Icons.cancel),
                            iconSize: 60,
                            color: const Color.fromARGB(255, 209, 201, 194),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          IconButton(
                            onPressed: swipeCardRight,
                            icon: const Icon(Icons.favorite_rounded),
                            iconSize: 60,
                            color: const Color.fromARGB(255, 240, 119, 105),
                          )
                        ],
                      ),
                    ),
                  ]),
                ));
              });
        });
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    (direction == CardSwiperDirection.left)
        ? swipeCardLeft()
        : swipeCardRight();
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

//it should be Future<void>
  Future<void> swipeCardLeft() async {
    swiperController.swipeLeft();
  }

//it should be Future<void>
  Future<void> swipeCardRight() async {
    swiperController.swipeRight();
  }
}
