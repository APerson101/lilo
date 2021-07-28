import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
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
      Expanded(child: NotiificationsView())
          .decorated(
              color: Get.theme.backgroundColor,
              borderRadius: BorderRadius.circular(25))
          .padding(right: 25),
      Expanded(child: AccountDetails()).decorated(
          color: Get.theme.backgroundColor,
          borderRadius: BorderRadius.circular(25))
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
    return Obx(() {
      List<Account> ccs = dashcontroller.allAccounts;
      List<Widget> accItems = [];
      for (var item in ccs) {
        var thing = Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("${item.currency}"),
                    SizedBox(width: 4),
                    Text("${item.balance}",
                        style: TextStyle(fontSize: 16, color: Colors.white))
                  ],
                ),
                Row(
                  children: [Text("US Dollars")],
                )
              ]),
        ).ripple().clipRRect(all: 25).decorated(
            borderRadius: BorderRadius.circular(9),
            color: Colors.purple.shade300);
        accItems.add(thing);
      }
      return Expanded(
        child: GFCarousel(
          items: accItems,
          viewportFraction: 1.0,
          // height: 100,
          // aspectRatio: 1,
        ),
      ).constrained(height: 110, width: 330);
    });
  }
}
