import 'dart:html';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lilo/models/userTrial.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/welcome/formWidget.dart';
import 'package:lilo/views/welcome/welcome_page.dart';
import 'package:random_string/random_string.dart';

import 'signuprepo.dart';

class FamController extends GetxController {
  var items = <Widget>[].obs;
  var it = <String>[].obs;
  var currentStep = 0.obs;
  List<Wallet> familyWallet = [];
  var currentFamilyMember = 1.obs;
  WalletRepository _walletRepository = Get.find();
  var _familyAmout = 2.obs;

  var firstname = ''.obs;

  var last_name = ''.obs;

  var email = ''.obs;

  var number = ''.obs;

  var Line = ''.obs;

  var country = ''.obs;

  var state = ''.obs;

  var zip = ''.obs;
  get familyAmount => _familyAmout.value;

  @override
  void onInit() {
    addMember();
    addMember();

    super.onInit();
  }

  addMember() {
    String id = randomAlphaNumeric(4);
    it.add(id);
    print('adding $id');
    items.add(item_(id));
    //validate and save
    onSubmit();
  }

  removeMember(String index) {
    print('removing $index it is on index: ${it.indexOf(index)}');
    items.removeAt(it.indexOf(index));
    it.remove(index);
  }

  Widget form(int index) {
    return GFAccordion(
        title: '$index', contentChild: Container(child: FormWidget()));
  }

  Widget item_(String id) {
    return Column(children: [
      SizedBox(height: 20),
      if (items.length >= 2)
        ElevatedButton(
            child: Text('remove item'), onPressed: () => removeMember(id)),
      SizedBox(height: 20),
      form(items.length)
    ]);
  }

  onSubmit() {
    //new member added, validate the first ones.
  }
  createWallet(Map<String, dynamic> entry) {
    //
    Wallet wallet = Wallet(
        contact: Contact(
          address: ContactAddress(
              name: entry['first_name'] + ' ' + entry['last_name'],
              line_1: entry['line_1'],
              city: entry['city'],
              state: entry['state'],
              country: entry['country'],
              zip: entry['zip'],
              phone_number: entry['phone_number']),
          city: entry['city'],
          email: entry['email'],
          phone_number: entry['phone_number'],
          first_name: entry['first_name'],
          last_name: entry['last_name'],
          date_of_birth: entry['date_of_birth'],
          country: entry['country_contact'],
          gender: entry['gender'],
          nationality: entry['nationality'],
        ),
        first_name: entry['first_name'],
        last_name: entry['last_name'],
        email: entry['email'],
        accounts: [],
        phone_number: entry['phone_number']);
    return wallet;
  }

  familyController() {
    return Container(
        child: TextFormField(
      initialValue: "you go enter stuffs",
    ));
  }

  void decreaseFamilyAmount() {
    if (_familyAmout.value <= 2) {
      Get.snackbar('info', 'at least 2 people gats dey!');
      return;
    }
    _familyAmout.value--;
  }

  void increaseFamilyAmount() {
    _familyAmout++;
  }

  var enteredfamilyform = 1.obs;
  currentsstep() async {
    if (currentStep.value == 2) {
      //validate and move to next family member
      // print('last step');

      //fill next form
      {
        print('enter next family member');

        Faker f = Faker();
        var rr = randomNumeric(10);
        var entry = {
          'first_name': f.person.firstName(),
          'last_name': f.person.lastName(),
          'email': f.internet.email(),
          'phone_number': '+1$rr',
          'line_1': f.address.streetAddress(),
          'country': f.address.countryCode(),
          'state': f.address.state(),
          'zip': '998231',
          'password': '999999999',
          'city': f.address.city()
        };
        var status = await vefiryEntry(entry);
        if (status) {
          print(status);
          if (allEntries.length == 0)
            entry.addAll({'user_type': 'family_controller'});
          else
            entry.addAll({'user_type': 'family_member'});
          currentStep.value = 0;

          allEntries.add(entry);
          if (allEntries.length == _familyAmout.value) {
            print('creating wallets for all family members');
            print('all members completed');
            createBatchWallets();
          } else
            return;
        } else {
          Get.snackbar('error', 'verify information, e don burst');
        }

        // return false;
      }

      //completed
      //return true
    } else {
      currentStep.value += 1;
    }
    // print(currentStep);
  }

  List<Map<String, dynamic>> allEntries = [];

  createBatchWallets() async {
    //verify each entry after the button is pressed and then send them again in batch??
    print(allEntries);
    List<Map<String, dynamic>> things = [];

    for (var entry in allEntries) {
      things.add(formatData(entry).toMap());
    }
    print(things);

    var status = await _walletRepository.createFamily(things, allEntries);
    print('result from createBatchWallet is: $status');
    return status;
    // send email to family users for activation
    //take them to the login page to login.
  }

  Wallet formatData(Map<String, dynamic> data) {
    Wallet _wallet = Wallet(
        contact: Contact(
          address: ContactAddress(
              name: data['first_name'] + ' ' + data['last_name'],
              line_1: data['line_1'],
              city: data['city'],
              state: data['state'],
              country: data['country'],
              zip: data['zip'],
              phone_number: data['phoneNumber']),
          city: data['city'],
          email: data['email'],
          phone_number: data['phone_number'],
          first_name: data['first_name'],
          last_name: data['last_name'],
          mothers_name: data['mothers_name'],
          date_of_birth: data['date_of_birth'],
          country: data['country_contact'],
          gender: data['gender'],
          house_type: data['house_type'],
          marital_status: data['marital_status'],
          nationality: data['nationality'],
        ),
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        accounts: [],
        phone_number: data['phone_number']);
    return _wallet;
  }

  vefiryEntry(Map<String, dynamic> data) async {
    ///
    return await _walletRepository.verifyEntry(data);
  }

  testingData() async {
    for (var i = 0; i < 3; i++) {
      Faker f = Faker();
      var rr = randomNumeric(10);

      var entry = UserModel2(
        last_name: f.person.lastName(),
        phone_number: '+1$rr',
        first_name: f.person.firstName(),
        email: f.internet.email(),
        date_of_birth: '01/01/2002',
        country: f.address.countryCode(),
        city: f.address.city(),
        nationality: f.address.countryCode(),
        address: f.address.streetAddress(),
        line_1: f.address.streetName(),
        state: f.address.state(),
        zip: '998231',
        phone_country_code: '+234',
      ).toMap();
      entry.addAll({'country_contact': f.address.countryCode()});
      var status = await vefiryEntry(entry);
      if (status) {
        print(status);
        if (allEntries.length == 0)
          entry.addAll({'user_type': 'family_controller'});
        else
          entry.addAll({'user_type': 'family_member'});

        allEntries.add(entry);
      } else {
        Get.snackbar('error', 'verify information, e don burst');
      }
    }
    print('creating wallets for all family members');
    var status = await createBatchWallets();
    print('final testingdata is $status');
    if (status) Get.snackbar('creating accounts', 'successful');
    //take you to home page where user would then use new credentials to sign in
    Get.offAll(() => WelcomePage());
  }
}
