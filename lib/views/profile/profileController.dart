import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/userTrial.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

class ProfileController extends GetxController {
  WalletRepository _walletRepository = Get.find();
  UserModel2? user;

  RxMap<String, dynamic> userMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> newChanges = <String, dynamic>{}.obs;

  @override
  void onInit() {
    _loadProfile();
    super.onInit();
  }

  _loadProfile() async {
    user = _walletRepository.trialUser!;
    userMap.value = user!.toMap();
  }

  fieldchanged(String key, String value) {
    newChanges[key] = value;
  }

  submitChanges() async {
    bool status = await _walletRepository.profileChange(newChanges.value);
    if (status) print("profile changes successfully");
    if (!status) print('profile change failed');
  }

  deletProfile() async {
    await _walletRepository.deleteProfile();
  }
}
