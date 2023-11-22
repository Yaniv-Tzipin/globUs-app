import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:myfirstapp/components/my_match_card.dart';

class MatchingBoard extends StatefulWidget {
  const MatchingBoard({super.key});

  @override
  State<MatchingBoard> createState() => _MatchingBoardState();
}

class _MatchingBoardState extends State<MatchingBoard> {
  final CardSwiperController swiperController = CardSwiperController();
  final List<MyMatchCard> cards = [const MyMatchCard(cardRanking: 10, userEmail: 'nadaveyal1@gmail.com'),
  const MyMatchCard(cardRanking: 10, userEmail: 'yaniv8985@gmail.com')
  ];


  @override
  void dispose(){
    super.dispose();
    swiperController.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(children: [
          Flexible(child: 
          CardSwiper(
          controller: swiperController,
          onSwipe: _onSwipe,
          backCardOffset: const Offset(0, 0),
          allowedSwipeDirection: AllowedSwipeDirection.only(down: false, up: false, right: true, left: true),
          cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) => cards[index],
          cardsCount: cards.length,
          numberOfCardsDisplayed: cards.length,)),
           Padding(
             padding: const EdgeInsets.only(bottom:8.0),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              IconButton(onPressed:swipeCardLeft, icon: const Icon(Icons.cancel),
              iconSize: 60,
              color: const Color.fromARGB(255, 209, 201, 194),),
              const SizedBox(width: 70,),
              IconButton(onPressed: swipeCardRight, icon: const Icon(Icons.favorite_rounded),
              iconSize: 60,
              color: const Color.fromARGB(255, 240, 119, 105),)
             
                       ],),
           ),       
        ]) ,)
    );
  }

 
  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

 

//it should be Future<void>
void swipeCardLeft(){
  swiperController.swipeLeft();

}

//it should be Future<void>
void swipeCardRight(){
  swiperController.swipeRight();

}

}