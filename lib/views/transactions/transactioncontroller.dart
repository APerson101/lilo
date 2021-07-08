import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/widgets/analyzerController.dart';
import 'package:lilo/views/dashboard/widgets/analyzerview.dart';
import 'package:lilo/views/transactions/transactions.dart';

enum transactionsState { summary, detailed, loading }

class TransactionsController extends GetxController {
  WalletRepository _walletRepository = Get.find();
  var allTransactions = <Transaction>[].obs;
  var pendingTransactions = [].obs;
  var currentState = transactionsState.loading.obs;
  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  loadHistory() async {
    currentState.value = transactionsState.loading;

    var result = await _walletRepository.viewTranscationsHistory();
    allTransactions.value = result;
    currentState.value = transactionsState.detailed;
  }

  loadtransactiondetails(String id) async {
    return await _walletRepository.transactionDetails(id);
  }

  List<FinanceData> getCreditSources() {
    Random rand = Random();
    List<FinanceData> things = [];
    for (var i = 0; i < 7; i++) {
      int rr = rand.nextInt(3);

      double amount = rand.nextDouble() * 1000;
      CreditTypes tt = CreditTypes.values[rr];
      things.add(FinanceData(amount: amount, source: describeEnum(tt)));
    }
    return things;
  }

  var selectedsource = ''.obs;

  List<FinanceData> getDebitSources() {
    Random rand = Random();
    List<FinanceData> things = [];
    for (var i = 0; i < 7; i++) {
      int rr = rand.nextInt(3);

      double amount = rand.nextDouble() * 1000;
      typesOut tt = typesOut.values[rr];
      things.add(FinanceData(amount: amount, source: describeEnum(tt)));
    }
    return things;
  }

  List<FinanceData> getDeditPersons() {
    Random rand = Random();
    List<FinanceData> things = [];
    for (var i = 0; i < 7; i++) {
      int rr = rand.nextInt(3);

      double amount = rand.nextDouble() * 1000;
      DebitPersons tt = DebitPersons.values[rr];
      things.add(FinanceData(amount: amount, source: describeEnum(tt)));
    }
    return things;
    // return [];
  }

  List<FinanceData> getCreditPersons() {
    Random rand = Random();
    List<FinanceData> things = [];
    for (var i = 0; i < 7; i++) {
      int rr = rand.nextInt(3);

      double amount = rand.nextDouble() * 1000;
      CreditPersons tt = CreditPersons.values[rr];
      things.add(FinanceData(amount: amount, source: describeEnum(tt)));
    }
    return things;
  }

  List<GraphData> getDashData() {
    Random rand = Random();
    List<GraphData> things = [];

    for (var i = 0; i < 7; i++) {
      int r1 = rand.nextInt(2);

      double amount = rand.nextDouble() * 1000;
      ff t = ff.values[r1];
      things.add(GraphData(
          amount: amount,
          source: describeEnum(t),
          time: DateTime(2017, 9, 7, 17, rand.nextInt(58))));
    }
    return things;
  }

  getTrnsactionHistory() {}
}

class FinanceData {
  double amount;
  String source;
  FinanceData({
    required this.amount,
    required this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'source': source,
    };
  }

  factory FinanceData.fromMap(Map<String, dynamic> map) {
    return FinanceData(
      amount: map['amount'],
      source: map['source'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FinanceData.fromJson(String source) =>
      FinanceData.fromMap(json.decode(source));
}
