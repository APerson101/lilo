// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/DashboardView.dart';

// import 'bloc/app/bloc/app.dart';
import 'controllers/authentication.dart';
import 'controllers/bindings.dart';
// import 'repositories/authentication_repo.dart';
// import 'repositories/user_repo.dart';
import 'models/getpages.dart';
import 'repositories/authentication_repo.dart';
import 'views/main_home/main_home.dart';
import 'views/welcome/welcome_page.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  // print('building this: ');

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // final Appmodel appmodel = Get.put(Appmodel(messaging: messaging));

  // final AuthenticationRepository authenticationRepository =
  //     AuthenticationRepository();
  // final UserRepository userRepository = UserRepository();
  // final WalletRepository walletRepository = WalletRepository();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final Appmodel appmodel =
  // Appmodel(messaging: messaging, userRepository: userRepository);
  runApp(GetMaterialApp(
    theme: ThemeData.dark(),
    getPages: GetPages().getPages(),
    initialRoute: '/',
  ));
}

class MyApp extends StatelessWidget {
  // final AuthenticationRepository authenticationRepository;
  // final Appmodel appmodel;
  // final WalletRepository walletRepository;

  // final UserRepository userRepository;
  MyApp(
      // {required this.authenticationRepository,
      // required this.userRepository,
      // required this.appmodel,
      // required this.walletRepository}
      );
  @override
  Widget build(BuildContext context) {
    // print('building this: ');
    return _App();
    // ));
  }
}

class _App extends StatelessWidget {
  _App({Key? key}) : super(key: key);
  AuthenticationController controller = Get.find<AuthenticationController>();
  @override
  Widget build(BuildContext context) {
    // print('building this: ');
    // ThemeType themeType =
    //     context.select<AppBloc, ThemeType>((value) => value.state.currentTheme);
    // print(themeType);
    // return MainHome();
    //return
    // return Obx(() {
    //   bool state = controller.isAuthenticated;
    //   if (state)
    //     return MainHome();
    //   else
    //     return WelcomePage();
    // });
    // return MainHome();

    return controller.obx(
      (state) {
        if (state == true) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            Get.offNamed('/main_home');
          });
          // Navigator.push(context,
          //     MaterialPageRoute<Widget>(builder: (BuildContext context) {
          //   return MainHome();
          // }));
        }
        if (state == false) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            Get.toNamed('/welcome');
            // Get.offNamed('/main_home');
          });
          // Get.toNamed('/welcome');

          // Navigator.push(context,
          //     MaterialPageRoute<Widget>(builder: (BuildContext context) {
          //   return WelcomePage();
          // }));
          // Get.toNamed('/welcome');
          // return Container();
        }
        return Container();
      },
    );

    // return BlocListener<AppBloc, AppState>(
    //   listener: (context, state) {
    //     // print(state.currentTheme);
    //   },
    //   child: MaterialApp(
    //     title: 'Lilo',
    //     debugShowCheckedModeBanner: false,
    //     // theme:
    //     // themeType == ThemeType.light ? ThemeData.dark() : ThemeData.light(),
    //     home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    //       if (state is Authenticated) {
    //         //
    //         return FutureBuilder(
    //             future: context.read<Appmodel>().userLoggedIn(),
    //             builder: (buildContext, data) {
    //               if (data.connectionState == ConnectionState.done)
    //                 return MainHome();
    //               else
    //                 return CircularProgressIndicator();
    //             });
    //       }
    //       if (state is Unauthenticated) {
    //         //
    //         return WelcomePage();
    //       }
    //       //This will be a splash page in the future, with transitioning
    //       return CircularProgressIndicator();
    //     }),
    //   ),
    // );
  }
}
