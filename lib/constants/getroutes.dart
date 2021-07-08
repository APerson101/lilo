import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lilo/views/loading.dart';

class Getroutes {
  static final routes = [
    GetPage(name: '/', page: () => LoadingProgress()),
    // GetPage(name: '/signin', page: () => SignInUI()),
    // GetPage(name: '/signup', page: () => SignUpUI()),
    // GetPage(name: '/home', page: () => HomeUI()),
    // GetPage(name: '/settings', page: () => SettingsUI()),
    // GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    // GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
  ];
}
