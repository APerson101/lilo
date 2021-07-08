import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/models/userTrial.dart';
import 'package:styled_widget/styled_widget.dart';

import 'familycontroller.dart';

class FamilyView extends StatelessWidget {
  FamilyView({Key? key}) : super(key: key);
  final FamilyController controller = Get.put(FamilyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: familyBody()
        // Container(),
        );
  }

  Widget familyBody() {
    return Row(
      children: [
        Expanded(child: leftWidget(), flex: 3),
        Expanded(child: requestsWidget(), flex: 1),
      ],
    );
  }

  Widget leftWidget() {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          Expanded(flex: 1, child: topWidget()),
          Expanded(flex: 2, child: analysisWidget())
        ],
      ),
    );
  }

  Widget requestsWidget() {
    return Container(
        color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: _requestbuilder(),
          ),
        ));
  }

  List<Widget> _requestbuilder() {
    List<Widget> items = [];
    for (var i = 0; i < 20; i++) {
      items.add(Text("E really chooke"));
    }
    return items;
  }

  Widget topWidget() {
    return Container(
      color: Colors.amberAccent,
      child: Row(
        children: [
          Expanded(child: membersWidget(), flex: 2),
          Expanded(child: upcomingpayments(), flex: 1)
        ],
      ),
    );
  }

  Widget analysisWidget() {
    return Container(color: Colors.blue);
  }

  Widget membersWidget() {
    return Container(
      color: Colors.tealAccent,
      child: membersListView(),
    );
  }

  Widget upcomingpayments() {
    return Container(color: Colors.purple, child: showSubscriptions());
  }

  showSubscriptions() {
    return Container(
        child: Column(
      children: [Text('next payout'), Text('amount'), Text('to who')],
    ));
  }

  membersListView() {
    List<UserModel2> familyMembers = controller.familyMembers;
    return Obx(() {
      if (familyMembers.isEmpty) return Text("you have no family member");
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: familyMembers.length,
          itemBuilder: (buildcontext, index) {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person).padding(all: 12).decorated(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(30),
                      ),
                  Text(familyMembers[index].last_name),
                ],
              ).constrained(width: 70, height: 70),
              onTap: () {
                controller.getMemberDetails();
                showDetails();
              },
            );
          });
    });
  }

  showDetails() {
    Get.defaultDialog(
        content: memberForm(),
        onCancel: () => Get.back(),
        onConfirm: () => controller.saveprofileChanges());
  }

  memberForm() {
    Map<String, dynamic> userdata = controller.userMap.value;
    var keys = userdata.keys.toList();
    var values = userdata.values.toList();

    return Container(
      child: Center(
        child: SafeArea(
            child: ListView.builder(
                itemCount: keys.length + 3,
                itemBuilder: (buildcontext, index) {
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
