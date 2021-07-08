// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:lilo/views/dashboard/dashboardController.dart';

// class NotificationsWidget extends StatelessWidget {
//   NotificationsWidget({Key? key}) : super(key: key);
//   DashboardController controller = Get.find<DashboardController>();
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: getCarousalView());
//   }

//   getCarousalView() {
//     //
//     return Obx(() {
//       return GFCarousel(items: getCarousalItems());
//     });
//   }

//   getCarousalItems() {
//     //subscriptions widget, pending request, pending transfers and birthdays widgets
//     var pendingTransctions = controller.getpendingTransactions();
//     var subscriptions = controller.getSubscriptions();
//     var pendingTransactionList =
//         ListView.builder(itemBuilder: (buildcontext, index) {
//       return Column(
//         children: [
//           Text(pendingTransctions[index]["amount"]),
//           Text(pendingTransctions[index]["sender"]),
//           Text(pendingTransctions[index]["date"]),
//           Text(pendingTransctions[index]["timeleft"]),
//           pendingTransctions[index]["type"] == "sender"
//               ? ElevatedButton(onPressed: () {}, child: Text("cancel"))
//               : ButtonBar(
//                   children: [
//                     ElevatedButton(onPressed: () {}, child: Text('accept')),
//                     ElevatedButton(onPressed: () {}, child: Text('reject')),
//                   ],
//                 )
//         ],
//       );
//     });
//     var subscriptionsList =
//         ListView.builder(itemBuilder: (buildcontext, index) {
//       return Column(
//         children: [
//           Text(subscriptions[index]["amount"]),
//           Text(pendingTransctions[index]["nextDate"]),
//           Image.network(pendingTransctions[index]["Image"]),
//         ],
//       );
//     });

//     var carousalWidgets = [];
//     carousalWidgets.add(pendingTransactionList);
//     carousalWidgets.add(subscriptionsList);
//     return carousalWidgets;
//   }
// }
