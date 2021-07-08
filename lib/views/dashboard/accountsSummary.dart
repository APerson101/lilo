import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/views/dashboard/dashboardController.dart';
import 'package:lilo/views/dashboard/dashboardRepository.dart';
import 'package:styled_widget/styled_widget.dart';

import 'notifications/notificationsview.dart';

class AccountSummary extends StatelessWidget {
  AccountSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: NotiificationsView()),
      Expanded(child: AccountDetails())
    ]);
  }

  eachItem(Account acc) {
    return Column(
      children: [
        Text(acc.currency),
        Text(acc.balance.toString()),
      ],
    );
  }
}

class AccountDetails extends StatelessWidget {
  AccountDetails({Key? key}) : super(key: key);
  DashboardController dashcontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    List<Account> ccs = dashcontroller.allAccounts;
    return Obx(() {
      return SizedBox(
        width: 200,
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ccs.length,
            itemBuilder: (buildcontext, index) {
              Account current = ccs[index];
              return Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [Text("${current.currency}")],
                      ),
                      Row(
                        children: [
                          Text("${current.balance}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white))
                        ],
                      ),
                      Row(
                        children: [Text("US Dollars")],
                      )
                    ]),
              )
                  // .constrained(width: 75, height: 100)
                  .ripple()
                  .clipRRect(all: 25)
                  .decorated(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.purple.shade300);
            }),
      );
    });
  }
}
