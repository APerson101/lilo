import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/repositories/authentication_repo.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/signupForm/signup.dart';

class AuthenticationController extends GetxController with StateMixin<bool> {
  // FirebaseAuth auth = FirebaseAuth.instance;
  WalletRepository _walletRepository = Get.find();
  Rxn<User> _user = Rxn<User>();
  RxBool _authenticated = RxBool(false);
  var userID = ''.obs;

  // RxBool get authenticated => _authenticated;
  User? get user => _user.value;

  //demo user
  Rxn<bool> _demouser = Rxn<bool>();
  RxBool _answ = false.obs;
  bool? get demouser => _demouser.value;
  var _isAuthenticated = false.obs;

  bool get isAuthenticated => _isAuthenticated.value;

  setAuthentication(bool state) {
    _isAuthenticated.value = state;
  }

  @override
  void change(bool? newState, {RxStatus? status}) {
    if (newState != null && newState == true) _answ.value = true;
    if (newState != null && newState == false) _answ.value = false;
    print({newState, status.toString()});

    super.change(newState, status: status);
  }

  @override
  void onInit() {
    // _user.bindStream(auth.authStateChanges());
    initialize();
    // _demouser.bindStream(_answ.stream);
    // change(false, status: RxStatus.success());

    //alternate method:
    // ever(_user, (value) {});
    super.onInit();
  }

  signIn({required String email, required String password}) async {
    //actual sign in
    change(null, status: RxStatus.loading());
    String code = await Get.find<AuthenticationRepository>()
        .signIn(email: email, password: password);
    if (code == "200") {
      await _walletRepository.loadWallet(userID.value);
      change(true, status: RxStatus.success());
      // Get.toNamed('/main_home');
    }
  }

  initialize() {
    change(false, status: RxStatus.loading());

    _user.bindStream(Get.find<AuthenticationRepository>().authenticate());
    print(_user.value);
    if (_user.value == null) {
      change(false, status: RxStatus.success());
      // Get.toNamed('/welcome');
    }
    ;
  }

  demoInit() {
    change(false, status: RxStatus.success());
  }

  signUp() {
    //do stuffs in the backend
    //get status and then
    Get.to(SignUpForm());
  }

  demoSignIn() async {
    change(null, status: RxStatus.loading());
    await Future.delayed(
        Duration(seconds: 0), () => change(true, status: RxStatus.success()));
  }

  demoSignOut() async {
    change(null, status: RxStatus.loading());
    await Future.delayed(
        Duration(seconds: 0), () => change(false, status: RxStatus.success()));
  }
}
