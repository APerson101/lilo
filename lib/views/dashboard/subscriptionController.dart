import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/giftcards.dart';
import 'package:lilo/models/payout.dart';
import 'package:lilo/models/subscriptionmodel.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:pretty_json/pretty_json.dart';

import '../payoutrequirementsform.dart';

enum displayOptions {
  loading,
  newSubscription,
  requirementsPage,
  payoutOptions
}

class SubscriptionController extends GetxController {
  var currentView = displayOptions.newSubscription.obs;
  WalletRepository _walletRepository = Get.find();

  var product_name = ''.obs;

  var product_description = ''.obs;

  var receiver_currency = 'USD'.obs;

  var amount = 0.0.obs;
  var subscriptionSource = "Bank".obs;
  var subscriptionalFrequency = '1'.obs;
  var subscriptionInterval = 'month'.obs;

  var receiverID = ''.obs;

  var selectedAccount = 0.obs;

  var country = 'NG'.obs;

  var currency = 'USD'.obs;
  var productcategory = ''.obs;
  var category = ''.obs;

  var accountType = 'individual'.obs;
  var sender_currency = "".obs;

  RxList<dynamic> payoutOptions = <dynamic>[].obs;

  RxMap<String, dynamic> payoutRequirements = <String, dynamic>{}.obs;
  RxMap<String, dynamic> senderRequirements = <String, dynamic>{}.obs;
  RxMap<String, dynamic> receiverRequirements = <String, dynamic>{}.obs;

  var allgiftcards = <GiftCard>[].obs;

  var payout_method_type = ''.obs;

  var title = ''.obs;

  createSubscription() async {
    currentView.value = displayOptions.loading;
    if (subscriptionSource.value == "Wallet Transfer") {
      receiverRequirements.value = {"ewallet": receiverID.value};
      senderRequirements.value = {};
      payout_method_type.value = "rapyd_ewallet";
    } else {}
    var subscriptionPayout = Payout(
        beneficiary: receiverRequirements,
        beneficiaryEntityType: accountType.value,
        ewallet: _walletRepository.trialUser!.ewallet!,
        payoutAmount: amount.value,
        beneficiaryCountry: country.value,
        payoutCurrency: receiver_currency.value,
        payoutMethodType: payout_method_type.value,
        sender: senderRequirements,
        senderCountry: _walletRepository.trialUser!.country,
        senderCurrency: sender_currency.value,
        senderEntityType: 'individual');

    var subscriptionMode = SubscriptionModel(
        payout_fields: subscriptionPayout,
        product_name: product_name.value,
        product_description: product_description.value,
        interval: subscriptionInterval.value,
        interval_count: int.parse(subscriptionalFrequency.value),
        group: productcategory.value);

    bool status = await _walletRepository.createSubscription(subscriptionMode);
    currentView.value = displayOptions.newSubscription;

    if (status) {
      print('stew');
    } else {
      print('e burst');
    }
  }

  getPayoutMethods() async {
    currentView.value = displayOptions.loading;
    print(
        'finding sources that satisfy: $subscriptionSource, $accountType, $country, $currency, ');
    var trasfersource = '';
    if (category.value == 'Card Transfer') trasfersource = 'Card';
    if (category.value == 'Cash') trasfersource = 'Cash';
    if (category.value == 'Wallet Transfer') trasfersource = 'rapyd_ewallet';
    if (category.value == 'Other eWallet') trasfersource = 'eWallet';
    if (category.value == 'Bank') trasfersource = 'Bank';
    var requirements = {
      'beneficiary_country': country.value,
      'beneficiary_entity_type': accountType.value,
      'payout_currency': currency.value,
      'sender_entity_type': 'individual',
      'category': trasfersource,
      'limit': '100'
    };
    var results =
        await _walletRepository.getAvailablePayoutMethods(requirements);
    payoutOptions.value = results;
  }

  getPayoutRequirements() async {
    currentView.value = displayOptions.loading;

    var data = {
      'beneficiary_country': country.value,
      'beneficiary_entity_type': accountType.value,
      'payout_currency': receiver_currency.value,
      'sender_entity_type': 'individual',
      'payout_amount': amount.value,
      'sender_country': _walletRepository.trialUser!.country,
      'sender_currency': sender_currency.value
    };
    printPrettyJson(data);

    var requirements = await _walletRepository.getPayoutMethodRequirements(
        data, payout_method_type.value);
    payoutRequirements.value = requirements;
    currentView.value = displayOptions.requirementsPage;
  }

  reset() {
    Get.back();
    currentView.value = displayOptions.newSubscription;
  }
}
