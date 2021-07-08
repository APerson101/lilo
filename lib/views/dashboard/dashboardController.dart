import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/dashboardRepository.dart';

enum TransferType { eWallet, Payout }

class DashboardController extends GetxController {
  WalletRepository _walletRepository = Get.find<WalletRepository>();
  DashboardRepository _dashboardRepository = DashboardRepository();
  RxBool hasNotifications = false.obs;
  @override
  void onInit() {
    loadTransactions();
    super.onInit();
  }

  var selectedAccount = 1.obs;
  var selectedGroup = 'bills'.obs;

  setAccount(int newValue) => selectedAccount.value = newValue;

  transferMoney(String amount, String currency, String destination_ewallet) {
    _walletRepository.transferToWallet(
        amount: amount,
        currency: currency,
        destination_ewallet: destination_ewallet);
  }

  RxList<Account> allAccounts = <Account>[].obs;
  loadTransactions() async {
    //load summary and pending transactions summary
    allAccounts.value = await _walletRepository.viewAccountBalance();
  }

  setUtilityType(String string) {
    utilitytype.value = string;
  }

  var utilitytype = ''.obs;

  loadserviceProviders() async {
    //
    providerslist.value = await _walletRepository.loadProviders('MX');
  }

  RxList<String> providerslist = <String>[].obs;

  processProviderPayment(
      String account_number, String amount, String id) async {
    var response =
        await _walletRepository.makeProviderPayment(id, amount, account_number);
    if (response['status']['status'] == 'ERROR') {
      return 'burst';
    }
    return 'success';
  }

  setFamilyLimit() async {
    await _walletRepository.setFamilyLimit();
  }

  getRecentTransactions() {}
}
