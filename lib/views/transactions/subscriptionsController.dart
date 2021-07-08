import 'package:get/get.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

class SubscriptionController extends GetxController {
  WalletRepository _walletRepository = Get.find();

  RxList allSubscriptions = [].obs;

  loadAllsubscriptions() async {
    allSubscriptions.value = await _walletRepository.loadSubscriptions();
  }

  deleteSubscription(int selectedItem) async {
    await _walletRepository.deleteSubscription();
  }
}
