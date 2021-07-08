import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/models/familyrequest.dart';
import 'package:lilo/models/otherTransfer.dart';
import 'package:lilo/models/wallettransfer.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/notifications/notificationscontroller.dart';
import 'package:styled_widget/styled_widget.dart';

class NotiificationsView extends StatelessWidget {
  // final NotificationsController controller = Get.put(NotificationsController());
  NotiificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _notification(
        Icons.ac_unit, Colors.amber, 7, "new notification", "pending requests");
    // print(controller.pendingRequests.length);
    // print(controller.pendingTransfers.length);
    // return Obx(() {
    //   if (controller.pendingRequests.length > 0 &&
    //       controller.pendingTransfers.length > 0)
    //     return _notification(Icons.ac_unit, Colors.amber, 7, "new notification",
    //         "both contain notifications");
    //   else if (controller.pendingRequests.length > 0 &&
    //       controller.pendingTransfers.length == 0)
    //     return _notification(Icons.ac_unit, Colors.amber, 7, "new notification",
    //         "pending requests");
    //   else if (controller.pendingRequests.length == 0 &&
    //       controller.pendingTransfers.length > 0)
    //     return _notification(Icons.ac_unit, Colors.amber, 10,
    //         "new notification", "pending requests");
    //   // pendingTransfers();

    //   return Container(child: Text("hello: ${controller.userName}"));
    // }
    // );
  }

  _notification(
      IconData icon, Color color, int count, String title, String description) {
    final Widget notificationIcon = Icon(icon, size: 20, color: Colors.white)
        .padding(all: 12)
        .decorated(
          color: color,
          borderRadius: BorderRadius.circular(30),
        )
        .padding(left: 15, right: 10);
    final Widget notificationTitle = Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);
    final Widget notificationDescription = Text(
      description,
      style: TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
    Widget notificationItem = [
      notificationIcon,
      <Widget>[
        notificationTitle,
        notificationDescription,
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ].toRow();
    var item = SizedBox(
        child: notificationItem
            .alignment(Alignment.center)
            .borderRadius(all: 15)
            .ripple()
            .backgroundColor(Colors.white, animate: true)
            .clipRRect(all: 25)
            .borderRadius(all: 25, animate: true)
            .constrained(height: 80, width: 300)
            .animate(Duration(milliseconds: 150), Curves.easeOut)
            .padding(vertical: 12));

    var things = Stack(
      children: [
        item,
        Text("4", style: TextStyle(color: Colors.white))
            .padding(all: 12)
            .decorated(
              shape: BoxShape.circle,
              color: Colors.red,
            )
            // .padding(left: 15, right: 10)
            .positioned(top: 0, right: 0)
      ],
    );
    // return notificationItem;
    return GestureDetector(child: things, onTap: () => print('hope'));
    // showDetails(notificationDetails())
  }

  // pendingTransfers() {
  //   return Container(
  //       child: Center(
  //     child: GestureDetector(
  //         onTap: () => showDetails(notificationDetails()),
  //         child: Text(controller.getMessage())),
  //   ));
  // }

  // showDetails(content) {
  //   Get.defaultDialog(title: "Details", content: content);
  // }

  // notificationDetails() {
  //   List pendings = controller.pendingTransfers;
  //   return Container(
  //       child: SizedBox(
  //     width: 250,
  //     height: 250,
  //     child: ListView.builder(
  //         itemCount: pendings.length,
  //         itemBuilder: (buildcontext, index) {
  //           var firstline = '';
  //           var current = pendings[index];
  //           if (current is WalletTransfer) {
  //             if (current.source_ewallet_id ==
  //                 controller.walletRepository.activeWallet!.id) {
  //               firstline = "Transfer TO ${current.receiver_name}";
  //             }
  //             if (current.destination_ewallet_id ==
  //                 controller.walletRepository.activeWallet!.id) {
  //               firstline = "Transfer FROM ${current.receiver_name}";
  //             }
  //           }
  //           if (current is OtherTransfer)
  //             firstline = "Payout to ${current.receiver_name}";

  //           return Container(
  //               child: SizedBox(
  //             height: 75,
  //             width: 100,
  //             child: Column(
  //               children: [
  //                 Text(firstline),
  //                 if (current is WalletTransfer)
  //                   Text("datetime:  ${current.timestamp}")
  //                 else if (current is OtherTransfer)
  //                   Text("datetime: ${current.created_at}"),
  //                 if (current is OtherTransfer)
  //                   ElevatedButton(
  //                       onPressed: () => controller.cancelPayout(current),
  //                       child: Text("cancel")),
  //                 if (current is WalletTransfer)
  //                   if (current.destination_ewallet_id ==
  //                       controller.walletRepository.activeWallet!.id)
  //                     ButtonBar(
  //                       children: [
  //                         ElevatedButton(
  //                             onPressed: () => controller.transferResponse(
  //                                 current, TransactionAction.Accept),
  //                             child: Text("accept")),
  //                         ElevatedButton(
  //                             onPressed: () => controller.transferResponse(
  //                                 current, TransactionAction.Decline),
  //                             child: Text("reject"))
  //                       ],
  //                     ),
  //                 if (current is WalletTransfer)
  //                   if (current.source_ewallet_id ==
  //                       controller.walletRepository.activeWallet!.id)
  //                     ElevatedButton(
  //                         onPressed: () => controller.transferResponse(
  //                             current, TransactionAction.Cancel),
  //                         child: Text("cancel"))
  //               ],
  //             ),
  //           ));
  //         }),
  //   ));
  // }

  // pendingRequests() {
  //   return Container(
  //       child: Center(
  //     child: GestureDetector(
  //         onTap: () => showDetails(requestDetails()),
  //         child: Text(controller.getRequestMessage())),
  //   ));
  // }

  // requestDetails() {
  //   List<FamRequest> pendings = controller.pendingRequests.value;
  //   return Container(
  //       child: SizedBox(
  //     width: 250,
  //     height: 250,
  //     child: ListView.builder(
  //         itemCount: pendings.length,
  //         itemBuilder: (buildcontext, index) {
  //           var firstline = '';
  //           var current = pendings[index];
  //           if (current.requesterWalletId ==
  //               controller.walletRepository.activeWallet!.id) {
  //             firstline = "Request for  ${current.currency} ${current.amount}";
  //           }
  //           if (controller.walletRepository.user!.userType ==
  //               "family_controller") {
  //             firstline =
  //                 "Request for ${current.currency} ${current.amount} FROM ${current.name}";
  //           }

  //           return Container(
  //               child: SizedBox(
  //             height: 75,
  //             width: 100,
  //             child: Column(
  //               children: [
  //                 Text(firstline),
  //                 Text("datetime: i forgot"),
  //                 if (current.requesterWalletId ==
  //                     controller.walletRepository.activeWallet!.id)
  //                   ElevatedButton(
  //                       onPressed: () => controller.requestResponse(
  //                           current, TransactionAction.Cancel),
  //                       child: Text("cancel")),
  //                 if (controller.walletRepository.user!.userType ==
  //                     "family_controller")
  //                   ButtonBar(
  //                     children: [
  //                       ElevatedButton(
  //                           onPressed: () => controller.requestResponse(
  //                               current, TransactionAction.Accept),
  //                           child: Text("approve")),
  //                       ElevatedButton(
  //                           onPressed: () => controller.requestResponse(
  //                               current, TransactionAction.Decline),
  //                           child: Text("reject"))
  //                     ],
  //                   ),
  //               ],
  //             ),
  //           ));
  //         }),
  //   ));
  // }

}
