import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/views/welcome/familysignup.dart';
import 'package:lilo/views/welcome/personalSignUp.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          child: Center(
              child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          //_family and person
          ElevatedButton(
              child: Text("Family"),
              onPressed: () => Get.to(() => FamilySignUp())),
          ElevatedButton(
              child: Text("Personal"),
              onPressed: () => Get.to(() => PersonalSignUp()))
        ],
      ))),
    );
  }
}
