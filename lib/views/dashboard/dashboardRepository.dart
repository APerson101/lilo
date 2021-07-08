import 'package:get/get.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

class DashboardRepository {
  WalletRepository _walletRepository = Get.find<WalletRepository>();

  List<Account> allAccounts = [];
  loadTransactions() async {
    //load summary and pending transactions summary
    allAccounts = await _walletRepository.viewAccountBalance();
    // print('ALL ACCOUNTS');
    // print(allAccounts);

    //pending payouts
    // var pendingPayouts = await _walletRepository.getPendingPayouts();
    // // print('PENDING PAYOUTS');
    // // prettyJson(pendingPayouts);

    // //pending transactions
    // var pendingtransactions = await _walletRepository.pendingtransfers();

    // //load saved benefitiaries
    // var savedBenefitiaries = await _walletRepository.getSavedBenefitiaries();

    // //load subscriptions
    // var subscriptions = await _walletRepository.loadSubscriptions();

    // //load cards
    // var cards = await _walletRepository.loadCards();

    //load recent transactions
  }
}
