import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:group_button/group_button.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/dashboardController.dart';
import 'package:lilo/views/dashboard/sendmoneyController.dart';

class PayoutForm extends StatelessWidget {
  PayoutForm({Key? key}) : super(key: key);
  SendMoneyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ObxValue((Rx<displayState> state) {
        if (state.value == displayState.loading)
          return Center(child: CircularProgressIndicator());
        if (state.value == displayState.requirements) return requirementsForm();
        if (state.value == displayState.burst)
          return Container(child: Center(child: Text('burst')));
        if (state.value == displayState.payoutOptions) return payoutOptions();
        if (state.value == displayState.payoutSuccess)
          return Container(child: Center(child: Text("E NO BURSTTT")));
        return Container(child: Center(child: Text("error")));
      }, controller.displayStatus),
    );
  }

/**
 * List<dynamic> senderRequirements =
        payoutRequirements["sender_required_fields"];
    List<String> senderNames = [];
    senderRequirements.forEach((element) {
      senderNames.add(element["name"]);
    });
    Map<String, dynamic> sender = {};
    senderNames.forEach((element) {
      sender[element] = _walletRepository.trialUser!.toMap()[element];
    });

 */
  requirementsForm() {
    Map<String, dynamic> requirements = controller.payoutRequirements;
    return Container(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: TextField(
          decoration: InputDecoration(hintText: 'enter amount'),
          onChanged: (value) =>
              controller.enteredAmount.value = double.parse(value),
        )),
        Expanded(
            child: _senderRequirements(requirements['sender_required_fields'])),
        Expanded(
          child: _benefitiaryRequirements(
              requirements['beneficiary_required_fields']),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          buttonPadding: EdgeInsets.all(7),
          children: [
            ElevatedButton(
                onPressed: () => controller.newTransfer(), child: Text('send')),
            ElevatedButton(onPressed: () => Get.back(), child: Text('cancel'))
          ],
        ),
      ],
    )));
  }

  WalletRepository _walletRepository = Get.find();
  _senderRequirements(List requirements) {
    List updated = [];
    var keys = _walletRepository.trialUser!.toMap().keys;
    for (var requirement in requirements) {
      if (keys.contains(requirement["name"])) {
        controller.SenderRequirementsMap.value[requirement['name']] =
            _walletRepository.trialUser!.toMap()[requirement['name']];
      } else {
        updated.add(requirement);
      }
    }
    return ListView.builder(
        itemBuilder: (buildContext, index) {
          var currentOne = updated[index];

          return TextField(
            decoration: InputDecoration(
                hintText: currentOne['description'],
                labelText: currentOne['name']),
            onChanged: (value) => controller
                .SenderRequirementsMap.value[currentOne['name']] = value,
          );
        },
        itemCount: updated.length);
  }

  _benefitiaryRequirements(List requirements) {
    return ListView.builder(
        itemBuilder: (buildContext, index) {
          var currentOne = requirements[index];
          return TextField(
            decoration: InputDecoration(
                hintText: currentOne['description'],
                labelText: currentOne['name']),
            onChanged: (value) => controller
                .ReceiverRequirementsMap.value[currentOne['name']] = value,
          );
        },
        itemCount: requirements.length);
  }

  payoutOptions() {
    var items = controller.payoutOptions;
    DashboardController dashboardController = Get.find();
    return Container(
        child: Column(children: [
      Text('select one option'),
      Expanded(
          child: ListView.builder(
        itemBuilder: (buildcontext, index) {
          return ElevatedButton(
              child: Text(items[index]['name']),
              onPressed: () async {
                print("details  are ${items[index]}");
                controller.selectedpayoutMethod.value =
                    items[index]['payout_method_type'];
                // Get.back();
                List<String> things = [];
                var accounts = dashboardController.allAccounts;
                for (var item in accounts) {
                  things.add(item.balance.toString());
                }
                Get.defaultDialog(
                    title: 'select account',
                    content: Obx(() {
                      var selected = controller.selectedAccountIndex.value;
                      //
                      return GroupButton(
                        isRadio: true,
                        spacing: 10,
                        selectedButton: selected,
                        onSelected: (index, isSelected) {
                          print('$index button is selected');
                          controller.selectedAccount.value =
                              accounts[index].currency;
                        },
                        buttons: things,
                      );
                    }),
                    onCancel: () => Get.back(),
                    onConfirm: () async {
                      controller.displayStatus.value = displayState.loading;
                      Get.back();
                      await controller.getPayoutRequirements();
                    });
              });
        },
        itemCount: items.length,
      ))
    ]));
  }
}
