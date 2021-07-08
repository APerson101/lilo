import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/views/main_home/main_home.dart';
import 'package:lilo/views/welcome/signuprepo.dart';
import 'package:random_string/random_string.dart';

import 'landing_page_Controller.dart';

class PersonalSignUpController extends GetxController {
  SignUpRepository _signUpRepository = Get.find<SignUpRepository>();
  AuthenticationController _authenticationController =
      Get.find<AuthenticationController>();
  void signUp({required GlobalKey<FormBuilderState> key}) async {
    //after verification, then sign up.
    print(key.currentState!.value);
    //signup
    Faker f = Faker();
    String num = randomNumeric(10);
    var testData = {
      'first_name': f.person.firstName(),
      'last_name': f.person.lastName(),
      'email': f.internet.email(),
      'password': f.internet.password(),
      'phone_number': '+1$num',
      'state': f.address.state(),
      'country_contact': f.address.countryCode(),
      'zip': f.address.zipCode(),
      'line_1': f.address.streetAddress(),
      'city': f.address.city(),
      'contact_type': 'individual',
      'sender_entity_type': 'individual',
      'date_of_birth': '01/01/2002',
      'country': f.address.countryCode(),
      'gender': 'female',
      'marital_Status': 'single',
      'nationality': f.address.countryCode(),
      'id_date_of_issue': '11/11/11',
      'id_expiry': '11/12',
      'id_issue_authority': 'FIRS',
      'id_issue_location': 'Abuja',
      'occupation': 'student',
      'source_of_income': "yahoo boy",
      'tax_id': '3452435234',
      'mothers_name': f.person.name(),
      'identification_type': '419 Card',
      'identification_number': '34234643653452',
      'address': f.address.neighborhood(),
      'line_2': f.address.streetAddress(),
      'line_3': 'e burst',
      'district': f.address.neighborhood(),
      'canton': 'bypass',
      'suburb': f.address.stateAbbreviation(),
      'phone_country_code': "+234"
    };

    var testDatas = {
      'first_name': f.person.firstName(),
      'last_name': f.person.lastName(),
      'email': f.internet.email(),
      'password': f.internet.password(),
      'phone_number': '+1$num',
      'state': f.address.state(),
      'zip': '56789',
      'line_1': f.address.streetAddress(),
      'city': f.address.city(),
      'contact_type': 'individual',
      'sender_entity_type': 'individual',
      'date_of_birth': '01/01/2002',
      'country': f.address.countryCode(),
      'phone_country_code': "+234",
      'address': f.address.neighborhood(),
      'nationality': f.address.countryCode(),
      'country_contact': f.address.countryCode(),
    };

    // var realData = {
    //   'first_name': key.currentState!.value["first_name"],
    //   'last_name': key.currentState!.value["first_name"],
    //   'email': key.currentState!.value["first_name"],
    //   'password': key.currentState!.value["first_name"],
    //   'phone_number': key.currentState!.value["first_name"],
    //   'state': key.currentState!.value["first_name"],
    //   'country_contact': key.currentState!.value["first_name"],
    //   'zip': key.currentState!.value["first_name"],
    //   'line_1': key.currentState!.value["first_name"],
    //   'city': key.currentState!.value["first_name"],
    //   'contact_type': 'individual',
    //   'sender_entity_type': 'individual',
    //   'date_of_birth': '01/01/2002',
    //   'country': key.currentState!.value["first_name"],
    //   'gender': key.currentState!.value["first_name"],
    //   'marital_Status': key.currentState!.value["first_name"],
    //   'nationality': key.currentState!.value["first_name"],
    //   'id_date_of_issue': key.currentState!.value["first_name"],
    //   'id_expiry': key.currentState!.value["first_name"],
    //   'id_issue_authority': key.currentState!.value["first_name"],
    //   'id_issue_location': id_issue_location,
    //   'occupation': occupation,
    //   'source_of_income': source_of_income,
    //   'tax_id': tax_id,
    //   'mothers_name': contact.mothers_name,
    //   'identification_type': contact.identification_type,
    //   'identification_number': contact.identification_number,
    //   'house_type': contact.house_type,
    //   'marital_status': contact.marital_status,
    //   'address': contact.address?.name,
    //   'line_2': contact.address?.line_2,
    //   'line_3': contact.address?.line_3,
    //   'district': contact.address?.district,
    //   'canton': contact.address?.canton,
    //   'suburb': suburb,
    // };

    // _signUpRepository.signUpProcedure(key.currentState!.value);
    // var status = await _signUpRepository.signUpProcedure(testData);
    var status = await _signUpRepository.signUpProcedure2(testDatas);
    if (status == 'success') {
      Get.back(canPop: true, closeOverlays: true);
      LandingController jj = Get.find();
      print('transaction succesfully execyted');
      jj.pop();
      // _authenticationController.setAuthentication(true);
      _authenticationController.demoSignIn();
    } else
      Get.defaultDialog(title: 'error', content: Text(status));
  }
}
