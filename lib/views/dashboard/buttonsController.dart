import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/giftcards.dart';
import 'package:lilo/repositories/rapyd/giftcard2.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

class ButtonsController extends GetxController {
  //

  WalletRepository _walletRepository = Get.find();
  var subscriptionSource = "Bank".obs;

  var subscriptionInterval = 'month'.obs;

  var subscriptionalFrequency = '1'.obs;

  var product_name = ''.obs;

  var product_description = ''.obs;

  var receiver_currency = ''.obs;

  RxDouble amount = 100.0.obs;

  var receiverID = ''.obs;

  var selectedAccount = 0.obs;

  var country = 'NG'.obs;

  var currency = 'USD'.obs;

  var accountType = 'individual'.obs;
  var sender_entity = 'individual'.obs;

  RxList<dynamic> payoutOptions = <dynamic>[].obs;

  RxMap<String, dynamic> payoutRequirements = <String, dynamic>{}.obs;

  RxString displayState = 'newTransfer'.obs;

  var allgiftcards = <GiftCard2>[].obs;

  void addfunds() async {
    await _walletRepository.addWithdrawFundsToWallet(
        type: GetDetailsType.deposit, amount: "5000", currency: "USD");
  }

  removefunds() async {
    await _walletRepository.addWithdrawFundsToWallet(
        type: GetDetailsType.withdraw, amount: "2000", currency: "USD");
  }

  buyGiftCard(GiftCard2 gift) async {
    String gift_link =
        await _walletRepository.buyGiftCard(giftID: gift.brand_code);
    return gift_link;
  }

  familyRequest() async {
    await _walletRepository.makeFamilyRequest();
  }

  getGiftCards() async {
    allgiftcards.value = await _walletRepository.getAllGiftCards();
  }

  getPayoutOptions() async {
    print(
        'finding sources that satisfy: $subscriptionSource, $accountType, $country, $currency, ');
    var trasfersource;
    if (subscriptionSource.value == 'Card Transfer') trasfersource = 'Card';
    if (subscriptionSource.value == 'Cash') trasfersource = 'Cash';
    if (subscriptionSource.value == 'Wallet Transfer')
      trasfersource = 'rapyd_ewallet';
    if (subscriptionSource.value == 'Other eWallet') trasfersource = 'eWallet';
    if (subscriptionSource.value == 'Bank') trasfersource = 'Bank';

    var results = await _walletRepository.getAvailablePayoutMethods({
      'beneficiary_country': country.value,
      'beneficiary_entity_type': accountType.value,
      'payout_currency': currency.value,
      'sender_entity_type': sender_entity.value,
      'category': trasfersource,
      'limit': '100'
    });
    payoutOptions.value = results;
  }

  getRequirements(String payout_method_type, String sender_currency) async {
    var data = {
      'beneficiary_country': country.value,
      'beneficiary_entity_type': accountType.value,
      'payout_currency': currency.value,
      'sender_entity_type': sender_entity.value,
      'payout_amount': amount.value,
      'sender_country': 'AE', //should be inferred normally
      'sender_currency': 'USD',
    };

    var requirements = await _walletRepository.getPayoutMethodRequirements(
        data, payout_method_type);
    payoutRequirements.value = requirements;
  }

  testGiftCard() async {
    await _walletRepository.testGiftCard();
  }
}
