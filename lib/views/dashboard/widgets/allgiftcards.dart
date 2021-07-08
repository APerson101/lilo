import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/models/giftcards.dart';
import 'package:lilo/repositories/rapyd/giftcard2.dart';
import 'package:lilo/views/dashboard/buttonsController.dart';
import 'package:lilo/views/dashboard/widgets/webview.dart';

class AllCards extends StatelessWidget {
  AllCards({Key? key}) : super(key: key);
  ButtonsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: Center(
        child: ListView.builder(
            itemBuilder: (buildcontext, index) {
              List<GiftCard2> gifts = controller.allgiftcards.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(index.toString()),
                  Text(gifts[index].name),
                  if (gifts[index].image_url.isNotEmpty)
                    Expanded(
                        child: Image.network(
                      gifts[index].image_url,
                      scale: 0.3,
                    ))
                  else
                    Container(),
                  ElevatedButton(
                      onPressed: () async {
                        String thing =
                            await controller.buyGiftCard(gifts[index]);
                        Get.to(WebView(thing));
                      },
                      child: Text("buy"))
                ],
              );
            },
            itemCount: controller.allgiftcards.value.length),
      ));
    });
  }
}
