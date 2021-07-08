import 'package:lilo/models/user.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/APIHandler.dart';

class Loader extends APIHandler {
  loadWallet(String eWalletID) async {
    var responseData = await callFunction(
        body: {"eWalletID": eWalletID}, function: 'loadWallet');
    var wallet = responseData['data'];
    return Wallet.fromMap(wallet);
  }

  loadUser() async {
    var response =
        await callFunction(body: {"userID": ''}, function: 'loadUser');
    print(response);
    UserModel user = UserModel.fromMap(response);
    return user;
  }
}
