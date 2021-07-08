import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addcontactscontroller.dart';

class AddContact extends StatelessWidget {
  AddContact({Key? key}) : super(key: key);
  AddContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SafeArea(
            child: ListView.builder(itemBuilder: (buildcontext, index) {
          return Expanded(
              child: TextFormField(
                  decoration: InputDecoration(
            labelText: 'ss',
          )));
        })),
      ),
    );
  }
}
