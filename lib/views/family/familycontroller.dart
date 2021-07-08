import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/userTrial.dart';

class FamilyController extends GetxController {
  // RxList<UserModel2> familyMembers = [].obs;
  // WalletRepository _walletRepository = Get.find();

  RxList<UserModel2> familyMembers = <UserModel2>[].obs;

  RxMap<String, dynamic> userMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> newChanges = <String, dynamic>{}.obs;

  RxList allRequests = [].obs;

  @override
  void onInit() {
    // initdata();
    // loadFamilyMembers();

    super.onInit();
  }

  initdata() {
    loadFamilyMembers();
    // loadSubscriptions();
    // loadRequests();
    // loadMembersTransactions();
    // loadAnalysis();
  }

  loadFamilyMembers() async {
    Faker f = Faker();
    for (var i = 0; i < 4; i++) {
      familyMembers.add(UserModel2(
          last_name: f.person.lastName(),
          phone_number: f.company.position(),
          first_name: f.person.lastName(),
          email: f.internet.email(),
          date_of_birth: '1/1/2002',
          country: f.address.countryCode(),
          city: f.address.city(),
          nationality: f.address.countryCode(),
          address: f.address.buildingNumber(),
          line_1: f.address.streetName(),
          state: f.address.state(),
          zip: f.address.zipCode(),
          phone_country_code: "234"));
    }
    // familyMembers.value = await _walletRepository.loadFamilyMembers();
  }

  loadSubscriptions() async {}

  loadMembersTransactions() async {
    // _membersSummary.value = await _walletRepository.loadMembersTransactions();
  }

  void getMemberDetails() {}

  saveprofileChanges() {}

  fieldchanged(String key, String value) {
    newChanges[key] = value;
  }
}
