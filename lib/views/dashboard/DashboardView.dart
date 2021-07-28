import 'package:country_list_pick/country_list_pick.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:group_button/group_button.dart';
import 'package:lilo/views/dashboard/buttonsController.dart';
import 'package:lilo/views/dashboard/widgets/analyzerview.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:get/get.dart';
import '../../styles.dart';
import 'accountsSummary.dart';
import 'buttons.dart';
import 'cards/cardsView.dart';
import 'dashboardController.dart';
import 'notifications/notificationsview.dart';
import 'sendmoneyview.dart';
import 'upcomingpayments.dart';

class DashboardView extends StatelessWidget {
  DashboardController controller = Get.put(DashboardController());
  ButtonsController __controller = Get.put(ButtonsController());
  // DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    print(context.width);
    var sideMenuWidth = Sizes.sideBarSm;
    double leftOffset = 0;
    double rightOffset = width * 0.25;
    double trialOffset = width * 0.51;
    double trialWidthLeft = width * 0.5;
    return Container(
        child: Stack(children: [
      rightStack(trialOffset, context, context.height),
      centerStack(leftOffset, rightOffset, trialWidthLeft, trialOffset)
    ]));
  }

  rightStack(double width, context, double height) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        flex: 65,
        child: CardsView()
            .decorated(
                // color: Colors.blue[600],
                borderRadius: BorderRadius.circular(25))
            .padding(bottom: 25),
      ),
      Expanded(
          flex: 120,
          child: Container(
              child: Column(children: [
            // Expanded(
            //   child: Container(
            //           child: Center(
            //     child: UpcomingPayments(),
            //   ))
            //       .decorated(
            //           // color: Colors.blueGrey,
            //           borderRadius: BorderRadius.circular(25))
            //       .padding(bottom: 25),
            // ),
            Expanded(
              child: SendMoney(),
            ),
            // Expanded(
            //     child: ButtonBar(
            //   children: [
            // ElevatedButton(
            //     onPressed: () => controller.setFamilyLimit(),
            //     child: Text('set limit'))
            //   ],
            // ))
            // .decorated(
            // color: Colors.blueGrey,
            // borderRadius: BorderRadius.circular(25)),
          ])).decorated(borderRadius: BorderRadius.circular(25))),
    ]).positioned(right: 0, left: width, top: 0, bottom: 0);
  }

  centerStack(
      double leftOffset, double rightOffset, trialWidthLeft, trialOffset) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 60,
          child: buttons(trialWidthLeft),
        ),
        Expanded(flex: 30, child: AccountSummary())
            .padding(bottom: 25, left: 10),
        Expanded(
          flex: 120,
          child: AnalyzerDashboard(),
        )
            .decorated(
                color: Get.theme.backgroundColor,
                borderRadius: BorderRadius.circular(25))
            .padding(left: 10)
      ],
    ).paddingOnly(right: 10, left: 15).positioned(
        // right: rightOffset,
        left: leftOffset,
        top: 0,
        bottom: 0,
        width: trialWidthLeft);
  }

  buttons(trialOffset) {
    return Container(
      child: Expanded(child: Buttons())
          .decorated(borderRadius: BorderRadius.circular(25))
          .padding(bottom: 15),
    );
  }

  _accountOptions() {
    return Obx(() {
      var selected = controller.selectedAccount.value;
      return GroupButton(
          isRadio: true,
          spacing: 10,
          selectedButton: selected,
          onSelected: (index, isSelected) {
            print('$index button is selected');
            controller.setAccount(index);
          },
          buttons: ["USD 7000", "GBP 4000"]);
    });
  }
}
