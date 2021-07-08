import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:lilo/views/welcome/familysignupcontroller.dart';

import 'moreForms.dart';

class FamilySignUp extends StatelessWidget {
  FamilySignUp({Key? key}) : super(key: key);
  final FamController controller = Get.find<FamController>();
  final List<Widget> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: controller.decreaseFamilyAmount,
                child: Text('Decrease')),
            Text('${controller.familyAmount}'),
            ElevatedButton(
                onPressed: controller.increaseFamilyAmount,
                child: Text('Increase')),
            ElevatedButton(
              child: Text("proceed"),
              onPressed: () {
                controller.testingData();
                Get.to(() => MoreForms());
              },
            )
          ]);
    }));
  }
}
