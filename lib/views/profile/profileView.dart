import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/views/profile/profileController.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userdata = controller.userMap.value;
    var keys = userdata.keys.toList();
    var values = userdata.values.toList();

    return Container(
      child: Center(
        child: SafeArea(
            child: ListView.builder(
                itemCount: keys.length + 3,
                itemBuilder: (buildcontext, index) {
                  if (index == keys.length)
                    return Expanded(
                        child: ElevatedButton(
                            onPressed: () => controller.submitChanges(),
                            child: Text('save')));
                  if (index == keys.length + 1)
                    return ElevatedButton(
                        onPressed: () => controller.deletProfile(),
                        child: Text("delete"));

                  if (index == keys.length + 2)
                    return ElevatedButton(
                        onPressed: () => Get.toNamed('/addContact'),
                        child: Text("add contat"));
                  return Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        initialValue: values[index].toString(),
                        decoration: InputDecoration(
                          labelText: keys[index].toString(),
                        ),
                        onChanged: (value) =>
                            controller.fieldchanged(keys[index], value),
                      ))
                    ],
                  );
                })),
      ),
    );
  }
}
