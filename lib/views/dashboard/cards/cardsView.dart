import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
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
    return Container(child: cardsCarousal());
  }

  cardsCarousal() {
    var cardsItems = cardsView();
    if (cardsItems == null)
      return Container(child: Center(child: Text("no cards ")));

    return GFCarousel(items: cardsItems);
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
          (card.ewallet_contact.first_name! +
              ' ' +
              card.ewallet_contact.last_name!),
          card.expiration_year);
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
        front: _cardFront(name, card_number, month, year), back: _cardBack());
  }

  _cardFront(String name, String card_number, String month, String year) {
    Widget frontCard = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                colors: [Color(0xfff953c6), Color(0xffb91d73)]));
    return frontCard;
  }

  _cardBack() {
    Widget backCard = Container(child: _cardbackdetails())
        .constrained(width: 320, height: 185)
        .clipRRect(all: 25)
        .ripple()
        .decorated(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xfff953c6), Color(0xffb91d73)]));

    return backCard;
  }

  _cardbackdetails() {
    return Column(children: [
      Expanded(child: Container(color: Colors.black)),
      Expanded(
          child: Row(
        children: [
          Expanded(flex: 3, child: Container(color: Colors.grey)),
          Expanded(
              child: Container(
            child: Text('234'),
          )),
        ],
      )),
      Expanded(
          child: Container(
        color: Colors.white,
      )),
    ]);
  }

  _nameCardType(String name, String type) {
    return Row(
      children: [
        Text(name),
        Expanded(child: Container()),
        Text('Shopping'),
      ],
    ).padding(left: 10, right: 10);
  }

  _cardNumber(String card_number) {
    return Text(card_number);
  }

  balance(String balance) {
    return Text('\$ $balance');
  }

  myear(String monthYear) {
    return Text(monthYear);
  }

  mlogo() {
    return SvgPicture.asset('images/mc_symbol.svg')
        .constrained(width: 50, height: 50);
  }

  lastRow(String month, String year) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [balance('8000'), myear('$month/$year'), mlogo()]);
  }
}
