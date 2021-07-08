import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:lilo/models/familyrequest.dart';
import 'package:lilo/models/otherTransfer.dart';
import 'package:lilo/models/wallettransfer.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

enum notificationState { none, single, multiple, loading }

class NotificationsController extends GetxController {
  WalletRepository walletRepository = Get.find();
  var pendingTransfers = <dynamic>[].obs;
  var pendingRequests = <FamRequest>[].obs;
  var allSubscriptions = <dynamic>[].obs;
  var userName = ''.obs;
  var currentState = notificationState.none.obs;
  String message = '';
  @override
  void onInit() {
    super.onInit();
    displayNotifications();
  }

  displayNotifications() async {
    userName.value = walletRepository.user!.firstName +
        " " +
        walletRepository.user!.lastName;
    await _getPendingTransfers();
    if (walletRepository.user!.userType != 'personal')
      await _getPendingRequests();
  }

  _getPendingTransfers() async {
    pendingTransfers.value = await walletRepository.pendingtransfers();
    print(pendingTransfers.value);
  }

  _getPendingRequests() async {
    pendingRequests.value = await walletRepository.getFamilyRequests();
  }

  _getSubscriptions() async {
    allSubscriptions.value = await walletRepository.getSubsciptions();
  }

  getMessage() {
    if (pendingTransfers.length > 1) {
      currentState.value = notificationState.multiple;
      return "you have ${pendingTransfers.length} pending transfers";
    } else if (pendingTransfers.length == 1) {
      currentState.value = notificationState.single;
      if (pendingTransfers[0] is WalletTransfer) {
        var current = pendingTransfers[0] as WalletTransfer;
        if (current.source_ewallet_id == walletRepository.activeWallet!.id)
          return "your transfer of ${current.amount}  to ${current.receiver_name} is pending";
        if (current.destination_ewallet_id == walletRepository.activeWallet!.id)
          return "${current.sender_name} wants to  transfer ${current.amount} to you";
      }
      if (pendingTransfers[0] is OtherTransfer) {
        var current = pendingTransfers[0] as OtherTransfer;

        return "your transaction of ${current.receiver_currency} ${current.amount} to ${current.receiver_name} is pending";
      }
    }
  }

  transferResponse(WalletTransfer current, TransactionAction type) async {
    await walletRepository.acceptDeclineCancelMoney(
        type: type, transferID: current.id);
  }

  cancelPayout(OtherTransfer current) async {
    await walletRepository.cancelPayout(current);
  }

  getRequestMessage() {
    if (walletRepository.user!.userType == 'personal') return;
    if (pendingRequests.value.length == 1) {
      var current = pendingRequests.value[0];
      if (current.requesterWalletId == walletRepository.activeWallet!.id) {
        return "your request for ${current.currency} ${current.amount}  hasn't yet been responded to";
      }
      if (walletRepository.user!.userType == "family_controller") {
        return "${current.name} requested for ${current.amount}";
      }
    }
    if (walletRepository.user!.userType == "family_controller") {
      return "there are ${pendingRequests.length} for you to respond to";
    }
    return "your have sent ${pendingRequests.length} requests ";
  }

  requestResponse(FamRequest current, TransactionAction action) async {
    await walletRepository.requestResponse(current, action);
  }
}
