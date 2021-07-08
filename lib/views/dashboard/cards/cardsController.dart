import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/cards/card.dart';

enum CardState { Loading, success, failure }

class CardsController extends GetxController {
  WalletRepository _walletRepository = Get.find();

  var currentPin = ''.obs;

  var newPin = ''.obs;

  var newPinConfirm = ''.obs;
  @override
  void onInit() {
    super.onInit();

    loadAllCards();
  }

  var cardstate = CardState.Loading.obs;
  var allCards = <WalletCard>[].obs;
  var currentView = 0.obs;

  issueNewCard() async {
    cardstate.value = CardState.Loading;
    WalletCard newCard = await _walletRepository.createCard('MX');
    allCards.add(newCard);
    cardstate.value = CardState.success;
  }

  loadAllCards() async {
    cardstate.value = CardState.Loading;
    List cards = await _walletRepository.loadCards();
    if (cards.isEmpty)
      allCards.value = [];
    else {
      List<WalletCard> _cards = List.castFrom(cards);
      allCards.value = _cards;
    }
    cardstate.value = CardState.success;
  }

  currentCardStatus() {
    if (allCards.length > 0)
      return allCards[currentView.value].status == "ACT";
    else
      return false;
  }

  cardActivationStatusChange() async {
    print('card has been somethinged');
    if (allCards[currentView.value].status == "ACT") {
      await _walletRepository.updateCard(allCards[currentView.value], "BLO");
    } else
      await _walletRepository.updateCard(allCards[currentView.value], "ACT");
  }

  setPin() async {
    await _walletRepository.changeCardPin(
        allCards[currentView.value], newPin.value);
  }

  changePin() async {
    String activePin = _walletRepository
        .trialUser!.card_pin![allCards[currentView.value].card_id];
    if (currentPin.value == activePin) {
      if (newPin.value == newPinConfirm.value) {
        await _walletRepository.changeCardPin(
            allCards[currentView.value], newPin.value);
      }
    }
  }
}
