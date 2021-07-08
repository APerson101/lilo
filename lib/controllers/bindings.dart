import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:lilo/controllers/mainController.dart';
import 'package:lilo/models/user.dart';
import 'package:lilo/repositories/authentication_repo.dart';
import 'package:lilo/repositories/rapyd/APIHandler.dart';
import 'package:lilo/repositories/rapyd/loader.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/repositories/user_repo.dart';
import 'package:lilo/views/dashboard/buttonsController.dart';
import 'package:lilo/views/dashboard/cards/cardsController.dart';
import 'package:lilo/views/dashboard/dashboardController.dart';
import 'package:lilo/views/dashboard/dashboardRepository.dart';
import 'package:lilo/views/dashboard/sendmoneyController.dart';
import 'package:lilo/views/welcome/familysignupcontroller.dart';
import 'package:lilo/views/welcome/landing_page_Controller.dart';
import 'package:lilo/views/welcome/personalSignUpController.dart';
import 'package:lilo/views/welcome/signuprepo.dart';

import 'authentication.dart';
import 'speechController.dart';

class GetBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationController());
    // Get.lazyPut(() => UserRepository());
    // Get.lazyPut(() => WalletRepository());

    // Get.lazyPut(() => LandingController());
    FirebaseAuth auth = FirebaseAuth.instance;
    Get.lazyPut(() => AuthenticationRepository(auth), fenix: true);
    // Get.lazyPut(() => MainController());
    // Get.lazyPut(() => PersonalSignUpController());
    // Get.lazyPut(() => DashboardController());
    // Get.lazyPut(() => SignUpRepository());
    // Get.lazyPut(() => DashboardRepository());
    // Get.lazyPut(() => ButtonsController());
    // Get.lazyPut(() => FamController(), fenix: true);
    // Get.lazyPut(() => SendMoneyController());
    // Get.lazyPut(() => CardsController());
    // Get.lazyPut(() => SpeechController());
  }
}
