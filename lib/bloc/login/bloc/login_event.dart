import 'package:lilo/views/welcome/personalSignUp.dart';
import 'package:lilo/views/welcome/welcome_info.dart';

abstract class LoginEvent {}

class Login extends LoginEvent {
  String username, password;
  Login(this.password, this.username);
}

class Signup extends LoginEvent {
  signUpData signupdata;
  Signup(this.signupdata);
}
