import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_widget/styled_widget.dart';

import 'cardsController.dart';

class CardsView extends StatelessWidget {
  CardsView({Key? key}) : super(key: key);
  // CardsController controller = Get.find();
  CardsController controller = Get.put(CardsController());

  @override
  Widget build(BuildContext context) {
    return ObxValue((Rx<CardState> data) {
      if (data.value == CardState.Loading)
        return Container(child: Center(child: CircularProgressIndicator()));
      if (data.value == CardState.failure)
        return Container(child: Center(child: Text('burst')));
      if (data.value == CardState.success) return yourCards();
      return Container(child: Center(child: Text("error")));
    }, controller.cardstate);
  }

  yourCards() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Cards',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  wordSpacing: 1),
            )).padding(left: 35),

        // Expanded(child:
        cardsCarousal()
        // ),
      ],
    ).decorated(
        color: Get.theme.backgroundColor,
        borderRadius: BorderRadius.circular(20));
  }

  cardsCarousal() {
    var cardsItems = cardsView();
    if (cardsItems == null)
      return Container(child: Center(child: Text("no cards ")));

    return GFCarousel(
      items: cardsItems,
      viewportFraction: 1.0,
      height: 185,
      aspectRatio: 1.8,
    );
  }

  cardsView() {
    var allCards = controller.allCards;
    List<Widget> cardsWidget = [];
    Widget currentcard;
    if (allCards.isEmpty) {
      return null;
    }

    for (var card in allCards) {
      currentcard = cardView(
          card.card_number,
          card.cvv,
          card.expiration_month,
          card.expiration_year,
          (card.ewallet_contact.first_name! +
              ' ' +
              card.ewallet_contact.last_name!));
      cardsWidget.add(currentcard);
    }
    return cardsWidget;
  }

  createNewCard() {
    controller.issueNewCard();
  }

  Widget cardView(
      String card_number, String cvv, String month, String year, String name) {
    return FlipCard(
        front: _cardFront(name, card_number, month, year),
        back: _cardBack(cvv));
  }

  _cardFront(String name, String card_number, String month, String year) {
    Widget frontCard = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _nameCardType(name, ""),
          _cardNumber(card_number),
          lastRow(month, year)
        ],
      ),
    )
        .constrained(width: 320, height: 185)
        .clipRRect(all: 25)
        .ripple()
        .decorated(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff32a5cf), Color(0xff00d4ff)]));
    return frontCard;
  }

  _cardBack(String cvv) {
    Widget backCard = Container(child: _cardbackdetails(cvv))
        .constrained(width: 320, height: 185)
        .clipRRect(all: 25)
        .ripple()
        .decorated(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff32a5cf), Color(0xff00d4ff)]));

    return backCard;
  }

  _cardbackdetails(String cvv) {
    return Center(
      child: Expanded(
          child: Container(
        child: Text('CVV: $cvv',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  wordSpacing: 2.3),
            )),
      )),
    );
  }

  _nameCardType(String name, String type) {
    return Row(
      children: [
        Text(name,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.4,
                  wordSpacing: 2.3),
            ))
      ],
    ).padding(top: 20, left: 20);
  }

  _cardNumber(String card_number) {
    String firstset = card_number.substring(0, 4);
    String secondset = card_number.substring(4, 8);
    String thirdset = card_number.substring(8, 12);
    String lastset = card_number.substring(12, 16);
    String newString =
        firstset + " " + secondset + " " + thirdset + " " + lastset;

    return Row(
      children: [
        Text(newString,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.5,
                    wordSpacing: 23)))
      ],
    ).padding(left: 20, right: 20);
  }

  myear(String monthYear) {
    return Text(monthYear,
        style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 2.5,
                wordSpacing: 6)));
  }

  mlogo() {
    return SvgPicture.asset('images/mc_symbol.svg')
        .constrained(width: 50, height: 50);
  }

  lastRow(String month, String year) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [myear('Exp: $month/$year'), mlogo()])
        .padding(bottom: 10, left: 20, right: 20);
  }
}
