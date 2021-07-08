import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/views/main_home/main_home.dart';
import 'package:lilo/views/signupForm/signup.dart';

class LandingController extends GetxController {
  AuthenticationController _authenticationController =
      Get.find<AuthenticationController>();

  var setpassword = ''.obs;

  var setUsername = ''.obs;
  //

  login({required String email, required String password}) {
    //assuming details already verified, then login
    // _authenticationController.signIn(
    //     email: setUsername.value, password: setpassword.value);

    _authenticationController.signIn(email: email, password: password);
  }

  signupGmail() {
    Get.to(() => SignUpForm());
  }

  _verifyDetails(String email, password) {
    //try sign in
  }
  pop() {
    Get.back();
  }
}
