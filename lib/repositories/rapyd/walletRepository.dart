import 'dart:async';

// import 'package:dio/dio.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lilo/models/contact.dart';
import 'package:lilo/models/familyrequest.dart';
import 'package:lilo/models/giftcards.dart';
import 'package:lilo/models/otherTransfer.dart';
import 'package:lilo/models/payout.dart';
import 'package:lilo/models/subscription.dart';
import 'package:lilo/models/subscriptionmodel.dart';
import 'package:lilo/models/user.dart';
import 'package:lilo/models/userTrial.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/models/wallettransfer.dart';
import 'package:lilo/views/cards/card.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:random_string/random_string.dart';

// import 'package:universal_io/io.dart';

import 'APIHandler.dart';
import 'giftcard2.dart';

enum GetDetailsType { withdraw, deposit }
enum TransactionAction { Accept, Decline, Cancel }

class WalletRepository extends APIHandler {
  FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Wallet? activeWallet;

  UserModel? user;
  String tempId = "ewallet_4c3ed1d16bae7b950e9ae1ec36c3c428";
  String userID = '';
  List<Transaction> pendingtransactions = [];

  WalletRepository() {
    _firebaseFunctions.useFunctionsEmulator(origin: 'http://localhost:5001');
    _firebaseAuth.useEmulator('http://localhost:9099');
  }

  acceptDeclineCancelMoney(
      {required TransactionAction type, required String transferID}) async {
//         {
// >    status: {
// >      error_code: '',
// >      status: 'SUCCESS',
// >      message: '',
// >      response_code: '',
// >      operation_id: '7d81a033-b0aa-49cb-8f79-7ea7b2c00f13'
// >    },
// >    data: {
// >      id: '20144fc6-dc82-11eb-b38b-02240218ee6d',
// >      status: 'CLO',
// >      amount: 1,
// >      currency_code: 'USD',
// >      destination_phone_number: '+12656350127',
// >      destination_ewallet_id: 'ewallet_f4deab2955cd1565555cdddb626a3377',
// >      destination_transaction_id: 'wt_cce1c7d069ff5ee593e2b99d88991b0a',
// >      source_ewallet_id: 'ewallet_7a1d44cb48e2bf8c3ae48c65d8d55dbb',
// >      source_transaction_id: 'wt_9847c4e155a360651f167081c1bf7cff',
// >      transfer_response_at: 1625381382,
// >      created_at: 1625373700,
// >      metadata: { merchant_defined: true },
// >      response_metadata: {}
// >    }
// >  }
    String transactionType = describeEnum(type);
    print({'id': transferID, 'status': transactionType});
    var moneyStatus = await callFunction(
        body: {'id': transferID, 'status': transactionType.toLowerCase()},
        function: "acceptDeclineCancelMoney");
    prettyJson(moneyStatus);
  }

  activateCard(String cardID) async {
    var body = {"card": cardID};
    var response =
        await postRequest(path: '/v1/issuing/cards/activate', body: body);
    printThis(response);
  }

  addWithdrawFundsToWallet(
      {required GetDetailsType type,
      required String amount,
      required String currency}) async {
    String? ID = activeWallet!.id;
    String _type = describeEnum(type);

    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'ewallet': ID
    };
    body.addAll({
      'metadata': {
        "category": "add_funds",
        "sender_name": this.trialUser!.first_name,
        "amount": amount,
        'currency': currency,
      }
    });

    var responseData =
        await callFunction(body: body, function: 'addWithdraw', params: _type);

    Map<String, dynamic> jsonResult = responseData;
    Map<String, dynamic> jsonResultData = jsonResult['data'];

    printPrettyJson(jsonResultData);
    // await viewWallet();
    // await viewAccountBalance();
  }

  buyGiftCard({required String giftID}) async {
    var body = {"brand_code": giftID};
    var response = await callFunction(body: body, function: 'buyGiftCard');
    print(response);
    return response;
  }

  cancelPayout(OtherTransfer current) async {
    var status =
        await callFunction(body: {"id": current.id}, function: "cancelPayout");
    print(status);
  }

  cardfund(String amount, String id, String curr) async {
    var body = {
      'card_id': id,
      'amount': amount,
      'currency': curr,
    };
    await postRequest(path: 'v1/issuing/cards/refund', body: body);
  }

  cardTransactions(String card_id) async {
    var response =
        await getRequest(path: '/v1/issuing/cards/$card_id/transactions');
    printThis(response);
  }

  createCard(String country) async {
    String id = activeWallet!.contact.id!;
    var body = {
      "country": 'MX',
      "ewallet_contact": id,
    };
    var response = await callFunction(body: body, function: 'createCard');
    var card = response["data"];
    printThis(response);
    return WalletCard.fromMap(card);
  }

  createFamily(List<Map<String, dynamic>> wallet,
      List<Map<String, dynamic>> allEntries) async {
    var res = await callFunction(
        body: {'useCreate': wallet, 'usesave': allEntries},
        function: 'createFamily');
    print('result from createfamily is $res');
    return res;
  }

  createSubPlan(String product, Map<String, dynamic> stuffs) async {
    //day week month year
    var body = {
      "amount": stuffs["amount"],
      "currency": stuffs["payout_currency"],
      "interval": stuffs['interval'], //day, month, year, week
      "interval_count": stuffs['interval_count'], //i,2,3,4//etc
      "product": product
    };
    HttpsCallable caller = _firebaseFunctions.httpsCallable('createSubPlan');
    var result = await caller.call({'body': body});
    // print(result.data["data"]["id"]);
    return result.data["data"]["id"];
  }

  createsubProduct(Map<String, dynamic> stuffs) async {
    var body = {
      "name": stuffs["product_name"],
      "type": "services",
      "active": true,
      "statement_descriptor": stuffs["product_description"]
    };
    HttpsCallable caller = _firebaseFunctions.httpsCallable('createsubProduct');
    var result = await caller.call({'body': body});
    // print(result.data["data"]["id"]);
    return result.data["data"]["id"];
  }

  createSubscription(SubscriptionModel subdata) async {
    var body = subdata.toMap();
    body.addAll({"userID": this.userID});

    var result = await callFunction(body: body, function: "createSubscription");

    return result;
  }

  createUser(Wallet data) async {
    var responseData =
        await callFunction(body: data.toMap(), function: 'createUser');
    return responseData;
  }

  createUser1(Map<String, dynamic> create, Map<String, dynamic> save) async {
    var responseData = await callFunction(
        body: {"create": create, "save": save}, function: 'createUser1');
    return responseData;
  }

  createPayout() {
    //creates payout Object
    //if type is ewallet payout, set the benefitiary and sender
    //continue with the rest.
    //i
  }

  createWalletPayout(Map<String, dynamic> stuffs) {
    String eWallet_disbursment = 'rapyd_ewallet';

    var body = {
      "payout_method_type": eWallet_disbursment, //from jaiz
      "beneficiary": {"ewallet": stuffs['benefitiaryeWalletID']},
      "beneficiary_entity_type": "individual", //inferred
      'payout_amount': stuffs["amount"],
      'payout_currency': stuffs["payout_currency"],
      "sender": {},
      "sender_country": "AE", //inferred
      "sender_currency": stuffs["sender_currency"],
      "sender_entity_type": "individual", //inferred
      "ewallet": activeWallet!.id //from jaiz
    };
    return body;
  }

  detailsofAddRemoveFunds(
      {required String id, required GetDetailsType type}) async {
    //type can either be deposit or withdraw
    String detailsType = describeEnum(type);
    var response = await getRequest(path: '/v1/account/$detailsType/$id');
    printThis(response);
  }

  getAllGiftCards() async {
    // List<GiftCard> allGiftCards = [];
    List<GiftCard2> allGiftCards = [];
    // var result = await callFunction(function: "getAllGiftCards");
    var result = await callFunction(function: "getgiftCrd2");

    printPrettyJson(result);
    // print(result["products"]);

    // for (var item in result["products"]) {
    //   allGiftCards.add(GiftCard.fromMap(item));
    // }

    for (var item in result["brands"]) {
      allGiftCards.add(GiftCard2.fromMap(item));
    }

    return allGiftCards;
  }

  getAvailablePayoutMethods(Map<String, String> requirements) async {
    var params = requirements;
    HttpsCallable caller = _firebaseFunctions.httpsCallable('PayoutOptions');
    var result =
        await caller.call({'params': params, 'type': 'get_payout_options'});
    return result.data;
  }

  getFamilyRequests() async {
    if (user!.userType == "personal") return;
    var response = await callFunction(
        body: {"userID": this.userID}, function: "getFamilyRequests");
    List<FamRequest> requests = <FamRequest>[];

    for (var request in response.data) {
      requests.add(FamRequest.fromMap(request));
    }
    return requests;
  }

  getPayoutMethodRequirements(
      Map<String, dynamic> parameters, String payout_type) async {
    //workflow: i want to send money to someone somewhere, i start by entering location or payment category?
    //i guess i can figure out that UI stuff later today when i am done In Sha ALlah
//everything has to match unless we get errors

    var params = parameters;

    //getting requirements
    HttpsCallable caller = _firebaseFunctions.httpsCallable('PayoutOptions');
    var result = await caller.call({
      'params': params,
      'type': 'get_requirements',
      'payout_method_type': payout_type
    });
    print(result.data);

    return result.data;
  }

  getPendingPayouts() async {
    //   var pendingPayouts = await callFunction(
    //       body: {'eWalletID': tempId}, function: 'getPendingPayouts');
    //   print('PENDING PAYOUTS');
    //   print(pendingPayouts);
    //   return pendingPayouts;
  }

  Future<List<Beneficiary>> getSavedBenefitiaries() async {
    List documents = await callFunction(
        body: {"userID": this.userID}, function: 'getContacts');
    List<Beneficiary> allContacts = <Beneficiary>[];

    documents.forEach((element) {
      allContacts.add(Beneficiary.loadFromDB(element));
    });
    print(allContacts);
    return allContacts;
  }

  getSubsciptions() {}

  issueBankAccountToWallet(String country, String currency) async {
    var body = {
      'country': country,
      'currency': currency,
      'ewallet': this.activeWallet!.id
    };
    var response = await postRequest(path: '/v1/issuing/bankaccounts');
    printThis(response);
  }

//personalised issued card....still don't understand the use case of having multiple contacts in one card
//simulate blocking a card by third party...used mauybe with family again
//display issued card, let's see what their image looks like
//simiulate card adjustment, something in retail to refund you back the money
  loadCards() async {
    print('loading cards');
    print(this.activeWallet.toString());
    String contact = this.activeWallet!.contact.id!;
    var response =
        await callFunction(params: {'contact': contact}, function: 'loadCards');
    List response_data = response;
    if (response_data.isEmpty) return [];
    List<WalletCard> allCards = [];

    for (var card in response_data) {
      allCards.add(WalletCard.fromMap(card));
    }
    return allCards;
  }

  // remoteAuthorization can't be done cos i need to contact their customer support
  //so therefore i need to implement this manually
  // //maybe for the family thing again, if you want to limit the card spending amout
  loadProviders(String countryCode) async {
    var responseData = await callFunction(
        body: {'country': countryCode}, function: 'loadProviders');
    // print(responseData);
    List<String> providers = [];
    for (var item in responseData) {
      providers.add(item['type']);
      print(item['type']);
    }
    return providers;
  }

  loadSubscriptions() async {
    var response = await callFunction(
        body: {'userID': this.userID}, function: 'getAllSubscriptions');
    // printPrettyJson(response);
    List<Subscription> allsubs = [];
    for (var sub in response) {
      allsubs.add(Subscription.fromMap(sub));
    }
    return allsubs;
  }

  cancelSubsription(Subscription tobecanceled) async {
    var response = await callFunction(
        body: {'userID': this.userID, "subscriptionID": tobecanceled.id},
        function: 'cancelSubscription');
    printPrettyJson(response);
    return response;
  }

  updateSubscriptionGroup(String subscriptionID, String newGroup) async {
    var response = await callFunction(body: {
      'userID': this.userID,
      "subscriptionID": subscriptionID,
      "newGroup": newGroup
    }, function: 'updateSubscriptionGroup');
    printPrettyJson(response);
    return response;
  }

  updateSubscriptionDescription(String newDesc, String subscriptionID) async {
    var response = await callFunction(body: {
      'userID': this.userID,
      "subscriptionID": subscriptionID,
      "newDesc": newDesc
    }, function: 'updateSubscriptionDescription');
    printPrettyJson(response);
    return response;
  }

  createsubscriptionGroup(String newGroup) async {
    var response = await callFunction(
        body: {'userID': this.userID, "newGroup": newGroup},
        function: 'createsubscriptionGroup');
    printPrettyJson(response);
    return response;
  }

  removesubscriptionGroup(String oldGroup) async {
    var response = await callFunction(
        body: {'userID': this.userID, "oldGroup": oldGroup},
        function: 'removesubscriptionGroup');
    printPrettyJson(response);
    return response;
  }

  //identity of wallet ownver must be verified
  loadUser() async {
    print('loading user with id ${userID}');
    var response =
        await callFunction(body: {"userID": userID}, function: 'loadUser');
    this.trialUser = UserModel2.fromMap(response);
    print(user);

    return trialUser;
    // // this.user = UserModel.fromMap(response);
    // print(user);
    // return user;
  }

  UserModel2? trialUser;

  loadWallet(String userID) async {
    this.userID = userID;
    await loadUser();
    // print(user!.eWalletId);
    // var responseData = await callFunction(
    //     body: {"eWalletID": user!.eWalletId}, function: 'loadWallet');

    var responseData = await callFunction(
        body: {"eWalletID": trialUser!.ewallet}, function: 'loadWallet');

    var wallet = responseData;
    this.activeWallet = Wallet.fromMap(wallet);
    print(activeWallet.toString());
  }

  makeFamilyRequest() async {
    var requestAmount = "amount";
    // var timestamp = "timestamp";
    var requesterName = "name";
    var requestType = "type";
    var currency = "currency";
    var body = {
      "requesterWalletId": this.trialUser!.ewallet,
      "requesterUserId": this.userID,
      "familyID": this.trialUser!.familyID,
      "amount": "90",
      "name": this.trialUser!.first_name + " " + this.trialUser!.last_name,
      // this.activeWallet!.first_name + " " + this.activeWallet!.last_name,
      requestType: "Utility",
      currency: "USD",
    };

    var response = await callFunction(body: body, function: "FamilyRequest");

    // var response = await familyRequest(body: body);

    print(response);
  }
//identity verify method..forgot where i wanted to use this one.

//to do payout, i need to first know which payout methods are valid in which country
//i dont think i can start by incorporating all countries.
  makeProviderPayment(String id, String amount, String account_number) async {
    var familyEwallet = "ewallet_19a111e66b575ea587abb947e021b6fd";

    var response = await callFunction(body: {
      'account_number': account_number,
      'currency': 'USD',
      'eWalletID': tempId,
      'amount': amount,
      'id': id
    }, function: 'payProvider');
    return response;
  }

  //payout to cash, bank transfer
//Payout - Transfer money to external beneficiaries. Payouts can be made to cards, bank transfers, cash and local ewallets.
//store sender and benefitiary informations
//benefitiary tokenization to ask them to fill form themselves
//payout subscription. eg salary
//Plan - Payout - Defines the individual payout in a payout subscription. See Plan Object - Disburse.

//   putfundsOnHold() async {
//     //this can be used for companies to drop money but not usable until....something i guess, or tranfer money weekly to kids
//   }

//   setRemoveWalletAccountLimit() async {
//     //can be used to regulate minors account
//     //
//   }

  PayOut(Map<String, dynamic> body) async {
    String payout_type = 'mx_willys_cash';
    String USD2USD = 'ng_jaizbank_bank';
    String eWallet_disbursment = 'rapyd_ewallet';

    Map<String, dynamic> benefitiaryObject = {
      'catagory': eWallet_disbursment,
      'country': 'NG',
      'currency': 'USD',
      'entity_type': 'individual',
      'identification_type': 'DriverLicense',
      'identification_value': 'DFG5rt754',
      'ewallet': 'ewallet_6bb2effbaf857ffa24c51522171b6fe0',
      'confirmation_required': 'false'
    };

    var senderObject = {
      'country': 'AE',
      'currency': 'USD',
      'entity_type': 'individual',
      'identification_type': 'Driver License',
      'identification_value': 'DS4545',
      'name': 'Abdulhadi',
      'surname': 'Hashim',
      'msisdn': '234098789367',
    };
    HttpsCallable caller = _firebaseFunctions.httpsCallable('PayoutRequest');
    body.addAll({"userID": this.userID});
    var result = await caller.call({'body': body});
    print(result.data);
    if (result.data) {
      return 'stew';
    }
    return 'burst';
  }

  pendingtransfers() async {
    var id = _firebaseAuth.currentUser!.uid;
    var pendingtransfers = await callFunction(
        body: {"userID": userID}, function: 'pendingTransactions');
    // print('PENDING Wallet Transactions');
    // print(pendingtransfers);

    List allpending = pendingtransfers;
    List anotherone = [];
    for (var item in allpending) {
      if (item["transaction_type"] == "walletTransfer") {
        anotherone.add(WalletTransfer.fromMap(item));
      } else {
        anotherone.add(OtherTransfer.fromMap(item));
      }
    }
    print(anotherone.length);
    return anotherone;
  }

  printThis(dynamic) {
    printPrettyJson(dynamic['data']);
  }

  remoteAuthorization(String amount, String cardID, String currency) async {
    //
    var body = {"amount": amount, "card_id": cardID, "currency": currency};
    var response =
        await postRequest(path: '/v1/issuing/cards/authorization', body: body);
    printThis(response);
  }

  removeBalance({required String amount, required String currency}) async {
    var body = {
      'amount': amount,
      'currency': currency,
      'ewallet': activeWallet!.id
    };
    var resonseData =
        await postRequest(path: '/v1/account/withdraw', body: body);
    printThis(resonseData);
  }

  requestResponse(FamRequest current, TransactionAction action) async {
    if (action == TransactionAction.Accept) {
      //perform wallet to wallet transaction
      var response = await transferToWallet(
          amount: current.amount,
          currency: current.currency,
          destination_ewallet: current.requesterWalletId);
      //if response is successful, update status
      var tem = current.toMap();
      tem.addAll({"status": describeEnum(action)});

      await callFunction(body: tem, function: "updateRequest");
      return;
    }

    if (action == TransactionAction.Decline ||
        action == TransactionAction.Cancel) {
      await callFunction(body: current.toMap(), function: "updateRequest");
      return;
    }
  }

  retrievetransactionsInvolvingBank(String bank_account) async {
    var response =
        await getRequest(path: '/v1/issuing/bankaccounts/$bank_account');
    printThis(response);
  }

  setFamilyLimit() async {
    // var body = {"userID": this.userID};
    // return await callFunction(body: body, function: 'setLimit');
    Faker fa = Faker();
    var first = fa.person.firstName();
    var last = fa.person.lastName();

    var number = "+1${randomNumeric(10)}";

    var body = {
      "first_name": first,
      "last_name": last,
      "email": fa.internet.email(),
      "phone_number": number,
      "address": fa.address.streetAddress(),
      "city": fa.address.city(),
      "date_of_birth": '12/12/2002',
      // "mobile_number": number,
      // "name": first + " " + last,
      "postcode": "434342",
      "state": fa.address.state(),
      "beneficiary_country": "NG",
      "beneficiary_entity_type": "individual",
      "payout_method_types": [
        {
          "category": "bank",
          "payout_method_type": "ng_jaizbank_bank",
          "payout_currency": "USD",
          "name": "Jaiz Bank",
          "account_number": "34453524",
          "msisdn": number,
        },
        {
          "category": "eWallet",
          "name": "Wallet",
          "payout_method_type": "rapyd_wallet",
          "destination_ewallet": "ewallet_453462345242"
        }
      ],
    };
    return await callFunction(body: body, function: 'setContacts');
  }

  setPinCode(String id, String code) async {
    var body = {"card": id, "new_pin": code};
    var response = putRequest(path: '/v1/issuing/cards/pin', body: body);
    printThis(response);
  }

  simulateBankTransferToWallet(
      String amount, String currency, String issued_bank_account) async {
    var body = {
      'amount': amount,
      'currency': currency,
      'issued_bank_account': issued_bank_account
    };
    var response = await postRequest(
        path: '/v1/issuing/bankaccounts/bankaccounttransfertobankaccount',
        body: body);
  }

  testGiftCard() async {
    return await callFunction(function: "testGiftCard");
  }

  /////
  ///what workflow is best to get around the issue
  ///idea 1: essentially, let user keep entering variables and then we show them the result?
  ///eg:send money to nigeria, get transfer type, then location,
  ///or find a way to segment it, transfer to cash, bank, etc...then they will pick the location.
  ///next: how to query the necessary body fields

  Tokensaver(String token) async {
    print("this is the token to be saved:: ${token}");

    var result = await saveToken(token);
  }

  transactionDetails(String id) async {
    var details = await callFunction(
        body: {"eWalletID": this.trialUser!.ewallet, "id": id},
        function: 'transactionDetails');
    // var details = await getRequest(
    //     path: '/v1/user/${this.activeWallet!.id}/transactions/$id');
    return details;
    // ["data"].toString();
  }

  payoutToContact(Payout payout) async {
    return await callFunction(body: payout.toMap(), function: 'PayoutRequest');
  }

  transferToWallet(
      {required String amount,
      required String currency,
      required String destination_ewallet}) async {
    print(activeWallet.toString());
    var body = {
      'amount': amount,
      'currency': currency,
      'source_ewallet': activeWallet!.id,
      'destination_ewallet': destination_ewallet
    };
    var response =
        await callFunction(body: body, function: 'walletTransferRequest');
    // var transferStatus = await postRequest(body: body);
    // if (transferStatus['status']['status'] == 'ERROR')
    //   return ResponseCode(
    //       responseCode: ResponseStatus.Error,
    //       error: Errors.fromMap(transferStatus['status']));
    // if (transferStatus['status']['status'] == 'ERROR')
    //   return ResponseCode(
    //       responseCode: ResponseStatus.Success,
    //       successData: transferStatus["data"]);
    // print(transferStatus);
  }

  updateCardStatus(String cardID, String status,
      {String? blocked_reason}) async {
    var body = {"card": cardID, "status": status};
    if (blocked_reason != null) body.addAll({"blocked_reason": blocked_reason});
    var response =
        await postRequest(path: '/v1/issuing/cards/status', body: body);
    printThis(response);
  }

  updateWallet(String location, String newValue) async {
    await putRequest(
        path: '/v1/user',
        body: {"ewallet": activeWallet!.id, location: newValue});
  }

  verifyEntry(Map<String, dynamic> data) async {
    return await callFunction(body: data, function: 'verifyEntry');
  }

  viewAccountBalance() async {
    // String second = "ewallet_6bb2effbaf857ffa24c51522171b6fe0";

    var accountsData = await callFunction(
        body: {"eWalletID": this.activeWallet!.id},
        function: 'loadAccountsBalance');
    List<Account> allAccounts = [];
    List accountsList = accountsData;

    for (var account in accountsList) {
      allAccounts.add(Account.fromMap(account));
    }
    return allAccounts;
  }

  Future<List<Transaction>> viewTranscationsHistory() async {
    //

    var histroy = await callFunction(body: {
      "eWalletID": this.trialUser!.ewallet,
    }, function: "getAllTransactions");
    // printThis(histroy);
    List<Transaction> alltransactions = [];
    for (var transaction in histroy) {
      if (transaction["status"] != "PEN")
        alltransactions.add(Transaction.fromMap(transaction));
      else
        pendingtransactions.add(Transaction.fromMap(transaction));
    }

    return alltransactions;
  }

  viewWallet() async {
    var responseData = await getRequest(path: '/v1/user/${activeWallet!.id}');
    printThis(responseData);
  }

  profileChange(Map<String, dynamic> value) async {
    var body = {"userID": userID, "update": value};
    return await callFunction(body: body, function: 'updateField');
  }

  deleteProfile() async {
    return await callFunction(
        body: {'userID': this.userID, "walletID": this.activeWallet!.id},
        function: 'deleteAccount');
  }

  saveContact(Beneficiary newContact) async {
    var body = {"userID": this.userID, "contactData": newContact.toMap()};
    return await callFunction(body: body, function: 'addNewContact');
  }

  deleteContact(Beneficiary tobedeleted) async {
    return await callFunction(
        body: {"userID": userID, "contactID": tobedeleted.id},
        function: 'deleteContact');
  }

  changeCardPin(WalletCard card, String pin) async {
    return await callFunction(
        body: {"card": card.card_id, "new_pin": pin}, function: 'setPinCode');
  }

  updateCard(WalletCard card, String status) async {
    return await callFunction(
        body: {"card": card.card_id, "status": status}, function: 'updateCard');
  }

  deleteSubscription() {}
}

enum WalletTypes { Person, Business, Client }
