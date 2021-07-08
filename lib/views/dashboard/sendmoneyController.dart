import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/contact.dart';
import 'package:lilo/models/payout.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/buttonsController.dart';
import 'package:random_string/random_string.dart';

import '../payoutrequirementsform.dart';
import 'dashboardController.dart';

enum displayState {
  loading,
  dashboard,
  requirements,
  payoutOptions,
  payoutSuccess,
  burst
}

class SendMoneyController extends GetxController {
  ButtonsController buttonsController = Get.find();
  WalletRepository _walletRepository = Get.find();
  DashboardController _dashboardController = Get.find();
  var category = 'Bank'.obs;

  var benefitiaryType = 'contact'.obs;

  var enteredAmount = 10.0.obs;

  var currency = 'USD'.obs;

  var benefitiaryaccountType = 'individual'.obs;

  var country = 'NG'.obs;

  RxInt selectedContact = 0.obs;

  var eWalletReceiverId = ''.obs;
  var displayStatus = displayState.dashboard.obs;
  RxList<dynamic> payoutOptions = <dynamic>[].obs;
  var selectedpayoutMethod = ''.obs;
  var selectedAccount = 'USD'.obs;
  var selectedAccountIndex = 0.obs;
  RxMap<String, dynamic> payoutRequirements = <String, dynamic>{}.obs;
  RxMap<String, dynamic> SenderRequirementsMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> ReceiverRequirementsMap = <String, dynamic>{}.obs;

  var selectedSourceAccount = '-'.obs;

  RxMap<String, dynamic> formValues = <String, dynamic>{}.obs;

  List<Account> getAccounts() {
    //expecting list of strings
    var allACcounts = _dashboardController.allAccounts.value;

    return allACcounts;
  }

  @override
  void onInit() {
    // getsSavedContacts();

    super.onInit();
  }

  getsSavedContacts() async {
    //option 1:load with user
    allContacts.value = await _walletRepository.getSavedBenefitiaries();
  }

  RxList<Beneficiary> allContacts = <Beneficiary>[].obs;

  getPayoutMethods() async {
    displayStatus.value = displayState.loading;
    Get.to(() => PayoutForm());

    var trasfersource = '';
    if (category.value == 'Card Transfer') trasfersource = 'Card';
    if (category.value == 'Cash') trasfersource = 'Cash';
    if (category.value == 'Wallet Transfer') trasfersource = 'rapyd_ewallet';
    if (category.value == 'Other eWallet') trasfersource = 'eWallet';
    if (category.value == 'Bank') trasfersource = 'Bank';
    var requirements = {
      'beneficiary_country': country.value,
      'beneficiary_entity_type': benefitiaryaccountType.value,
      'payout_currency': currency.value,
      'sender_entity_type': 'individual',
      'category': trasfersource,
      'limit': '100'
    };
    var results =
        await _walletRepository.getAvailablePayoutMethods(requirements);
    payoutOptions.value = results;
    displayStatus.value = displayState.payoutOptions;
  }

  getPayoutRequirements() async {
    var data = {
      'beneficiary_country': country.value,
      'beneficiary_entity_type': benefitiaryaccountType.value,
      'payout_currency': currency.value,
      'sender_entity_type': 'individual',
      // 'payout_amount': enteredAmount.value,
      'payout_amount': 4,
      'sender_country': 'AE', //should be inferred normally
      'sender_currency': selectedAccount.value,
    };

    var requirements = await _walletRepository.getPayoutMethodRequirements(
        data, selectedpayoutMethod.value);
    payoutRequirements.value = requirements;
    displayStatus.value = displayState.requirements;
  }

  newTransfer() async {
    SenderRequirementsMap["msisdn"] = '5775558755418255';
    ReceiverRequirementsMap["msisdn"] = '962519185055';

    print(ReceiverRequirementsMap);
    print(SenderRequirementsMap);
    // var familyEwallet = "ewallet_19a111e66b575ea587abb947e021b6fd";
    // var personal = "ewallet_4c3ed1d16bae7b950e9ae1ec36c3c428";

    var body = {
      "payout_method_type": payoutRequirements['payout_method_type'],
      "beneficiary": ReceiverRequirementsMap,
      "beneficiary_entity_type": "individual",
      "payout_amount": enteredAmount.value,
      "payout_currency": currency.value,
      "sender": SenderRequirementsMap,
      "sender_country": "AE",
      "sender_currency": selectedAccount.value,
      "sender_entity_type": "individual",
      "ewallet": _walletRepository.activeWallet!.id, //from jaiz
    };
    displayStatus.value = displayState.loading;
    String status = await _walletRepository.PayOut(body);
    if (status == 'stew') displayStatus.value = displayState.payoutSuccess;
    if (status == 'burst') displayStatus.value = displayState.burst;
  }

  sendMoney() {
    //get details
    print('sender $SenderRequirementsMap');
    print('receiver $ReceiverRequirementsMap');
    if (contactSelected.value) {
      //transfer to contact
      _transferToContact();
      return;
    }
    if (category.value == "Wallet Transfer")
      _walletRepository.transferToWallet(
          amount: enteredAmount.value.toString(),
          currency: 'USD',
          destination_ewallet: eWalletReceiverId.value);
    else
      return;
    // _walletRepository.repeatTransaction(transactionId: _receiverId.value);
  }

  _transferToContact() async {
    // if selected payout method is wallet then do that
    String selectedTransferMethod = allContacts[selectedContact.value]
        .payout_fields![contactTransferOption.value]
        .id!;
    if (selectedTransferMethod == 'rapyd_ewallet') {
      String destination_ewallet = allContacts[selectedContact.value].ewallet!;
      print(
          'going to transfer through wallet trnsfer, even though wallet payout is available');
      _walletRepository.transferToWallet(
          amount: enteredAmount.value.toString(),
          currency: currency.value,
          destination_ewallet: destination_ewallet);
    } else {
      //continue with payout
    }
    Map<String, dynamic> payout_specific_required_fields =
        allContacts[selectedContact.value]
            .payout_fields![contactTransferOption.value]
            .required_fields!;
    //add to requirements whatever is missing
    Beneficiary selectedReceiver = allContacts[selectedContact.value];

    var data = {
      'beneficiary_country': selectedReceiver.country!,
      'beneficiary_entity_type': selectedReceiver.beneficiary_entity_type,
      'payout_currency':
          selectedReceiver.payout_fields![contactTransferOption.value].currency,
      'sender_entity_type': 'individual',
      'payout_amount': enteredAmount.value,
      // 'payout_amount': 4,
      'sender_country':
          _walletRepository.trialUser!.country, //should be inferred normally
      'sender_currency': selectedAccount.value,
    };

    var requirements = await _walletRepository.getPayoutMethodRequirements(
        data, selectedpayoutMethod.value);
    payoutRequirements.value = requirements;

    //get sender and beneficiary fields and create payout object
    List<dynamic> senderRequirements =
        payoutRequirements["sender_required_fields"];
    List<String> senderNames = [];
    senderRequirements.forEach((element) {
      senderNames.add(element["name"]);
    });
    List<dynamic> receiverRequirements =
        payoutRequirements["beneficiary_required_fields"];

    List<String> receiverNames = [];
    receiverRequirements.forEach((element) {
      receiverNames.add(element["name"]);
    });

    //mapping
    var receiver = {};
    receiverNames.forEach((element) {
      receiver[element] = selectedReceiver.toMap()[element];
    });

    Map<String, dynamic> sender = {};
    senderNames.forEach((element) {
      sender[element] = _walletRepository.trialUser!.toMap()[element];
    });

    Payout payout = Payout(
        beneficiary: {"beneficiary": receiver},
        beneficiaryEntityType: selectedReceiver.beneficiary_entity_type!,
        ewallet: _walletRepository.activeWallet!.id!,
        payoutAmount: enteredAmount.value,
        payoutCurrency: selectedReceiver
            .payout_fields![contactTransferOption.value].currency!,
        payoutMethodType:
            selectedReceiver.payout_fields![contactTransferOption.value].id!,
        sender: sender,
        senderCountry: _walletRepository.trialUser!.country,
        senderCurrency: selectedAccount.value,
        senderEntityType: 'individual');

    await _walletRepository.payoutToContact(payout);
  }

  RxInt contactTransferOption = 0.obs;
  //
  RxBool contactSelected = false.obs;

  newContact() async {
    Faker f = Faker();
    var fakeData = {
      'last_name': f.person.lastName(),
      'phone_number': '+1${randomNumeric(10)}',
      'first_name': f.person.firstName(),
      'email': f.internet.email(),
      'date_of_birth': '1/1/2002',
      'city': "abuja",
      'address': "zone 7",
      'state': "Abuja",
      'postcode': "4534",
      'phone_country_code': "+234",
      'nationality': "GH",
    };

    // Beneficiary newContact = Beneficiary.fromMap(formValues.value);
    Beneficiary newContact = Beneficiary.createContact(fakeData);
    //save
    await _walletRepository.saveContact(newContact);
  }

  deleteContact(Beneficiary tobedeleted) async {
    await _walletRepository.deleteContact(tobedeleted);
  }
}
