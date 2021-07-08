import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/controllers/mainController.dart';
import 'package:lilo/controllers/speechController.dart';
import 'package:lilo/main.dart';
import 'package:lilo/repositories/authentication_repo.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/addcontact.dart';
import 'package:lilo/views/cards/cardsView.dart';
import 'package:lilo/views/dashboard/DashboardView.dart';
import 'package:lilo/views/dashboard/buttonsController.dart';
import 'package:lilo/views/dashboard/cards/cardsController.dart';
import 'package:lilo/views/dashboard/dashboardController.dart';
import 'package:lilo/views/dashboard/dashboardRepository.dart';
import 'package:lilo/views/dashboard/sendmoneyController.dart';
import 'package:lilo/views/main_home/main_home.dart';
import 'package:get/get.dart';
import 'package:lilo/views/transactions/transactions.dart';
import 'package:lilo/views/welcome/familysignupcontroller.dart';
import 'package:lilo/views/welcome/landing_page_Controller.dart';
import 'package:lilo/views/welcome/personalSignUpController.dart';
import 'package:lilo/views/welcome/signuprepo.dart';
import 'package:lilo/views/welcome/welcome_page.dart';

class GetPages {
  List<GetPage<dynamic>> getPages() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return [
      GetPage(name: '/', page: () => MyApp(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => AuthenticationController())),
        BindingsBuilder(() =>
            Get.lazyPut(() => AuthenticationRepository(auth), fenix: true)),
        BindingsBuilder(() => Get.lazyPut(() => WalletRepository())),
      ]),
      GetPage(name: '/main_home', page: () => MainHome(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => MainController())),
      ]),
      GetPage(name: '/welcome', page: () => WelcomePage(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => LandingController())),
        BindingsBuilder(() => Get.lazyPut(() => PersonalSignUpController())),
        BindingsBuilder(() => Get.lazyPut(() => FamController())),
        // BindingsBuilder(() => Get.lazyPut(() => WalletRepository())),
        BindingsBuilder(() => Get.lazyPut(() => SignUpRepository())),
      ]),
      GetPage(name: '/dashboard', page: () => DashboardView(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => CardsController())),
        BindingsBuilder(() => Get.lazyPut(() => SendMoneyController())),
        BindingsBuilder(() => Get.lazyPut(() => ButtonsController())),
        BindingsBuilder(() => Get.lazyPut(() => DashboardRepository())),
        BindingsBuilder(() => Get.lazyPut(() => DashboardController())),
        BindingsBuilder(() => Get.lazyPut(() => SpeechController())),
      ]),
      GetPage(
        name: '/transactions',
        page: () => TransactionsView(),
      ),
      GetPage(name: '/cards', page: () => CardsView()),
      GetPage(name: '/addContact', page: () => AddContact()),
    ];
  }
}
