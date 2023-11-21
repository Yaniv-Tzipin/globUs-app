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
  final List<MyMatchCard> cards = [const MyMatchCard(cardRanking: 10, userEmail: 'yaniv8985@gmail.com')];


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
          cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) => cards[index],
          cardsCount: cards.length,
          numberOfCardsDisplayed: cards.length,))
        ]) ,)
    );
  }
}