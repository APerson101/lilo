import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lilo/views/dashboard/cards/cardsController.dart';
import 'package:styled_widget/styled_widget.dart';

class CardsView extends StatelessWidget {
  CardsView({Key? key}) : super(key: key);
  final CardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 1, child: topStack()),
          Expanded(flex: 2, child: bottomStack()),
        ],
      ),
    );
  }

  Widget topStack() {
    return Container(
      color: Colors.red,
      child: topView(),
    );
  }

  Widget bottomStack() {
    return Container(color: Colors.amber);
  }

  Widget topView() {
    return Row(
      children: [
        Expanded(flex: 2, child: cardsCarousal()),
        Expanded(flex: 1, child: actions()),
      ],
    );
  }

  cardsCarousal() {
    var cardsItems = cardsView();
    if (cardsItems == null)
      return Container(child: Center(child: Text("no cards yet")));

    return GFCarousel(
      items: cardsItems,
      onPageChanged: (value) => controller.currentView.value = value,
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
      currentcard = Container(
        child: Column(
          children: [
            Expanded(child: Text(card.card_number)),
            Expanded(child: Text(card.cvv)),
            Expanded(child: Text(card.expiration_month)),
            Expanded(child: Text(card.expiration_year)),
          ],
        ),
      );
      cardsWidget.add(currentcard);
    }
    return cardsWidget;
  }

  Widget actions() {
    return Container(color: Colors.pink, child: _actionButons());
  }

  Widget _actionButons() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () => confirmStatusChange(),
              child: controller.currentCardStatus()
                  ? Text('block')
                  : Text('activate')),
          ElevatedButton(
              onPressed: () => confirmNewCard(), child: Text('new Card')),
          ElevatedButton(
              onPressed: () => changePin(), child: Text('change pin')),
        ],
      ),
    );
  }

  showAlert(
      String title, String textConfirm, Function onConfirm, Widget content) {
    Get.defaultDialog(
        title: title,
        content: content,
        onConfirm: () => onConfirm(),
        onCancel: () => Get.back(),
        textConfirm: textConfirm);
  }

  confirmStatusChange() {
    String title = '';
    String text = '';
    bool currentStatus = controller.currentCardStatus();

    if (currentStatus) {
      title = 'are you sure you want deactivate card?';
      text = 'deactivate';
    } else {
      title = "are you sure you want to activate the card?";
      text = 'activate';
    }
    Widget content = Text(title);
    Function action = controller.cardActivationStatusChange;

    showAlert("confirm action", text, action, content);
  }

  changePin() {
    String text = 'change pin';

    Widget content = Column(
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: 'enter current Pin'),
          onChanged: (value) => controller.currentPin.value = value,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: 'enter new Pin'),
          onChanged: (value) => controller.newPin.value = value,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: 'confirm new Pin'),
          onChanged: (value) => controller.newPinConfirm.value = value,
        )
      ],
    );
    Function action = controller.changePin;

    showAlert("confirm Pin", text, action, content);
  }

  confirmNewCard() {
    String title = 'create new card';
    String text = 'other currencies are currently unavailable';

//enter currency
    Widget content = TextFormField(
      decoration: InputDecoration(hintText: 'enter debit account'),
    );
    Function action = controller.issueNewCard;

    showAlert(title, text, action, content);
  }
}
