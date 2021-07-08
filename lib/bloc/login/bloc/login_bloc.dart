import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lilo/models/signUp.dart';
import 'package:lilo/repositories/login_repo.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  LoginRepository _loginRepository = LoginRepository();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      String response =
          await _loginRepository.signIn(event.username, event.password);
      print(response);
      switch (response) {
        case '200':
          yield LoginSucess();
          break;
        case 'invalid-email':
          yield LoginFailure(FailureCode.invalidEmail);
          break;
        case 'user-not-found':
          yield LoginFailure(FailureCode.userNotFound);
          break;
        case 'wrong-password':
          yield LoginFailure(FailureCode.wrongPassword);
          break;
        case 'network-request-failed':
          yield LoginFailure(FailureCode.internetIssue);
          break;
        default:
          print(response);
          yield UnknownLoginError();
      }
    }

    if (event is Signup) {
      WalletRepository walletRepo = WalletRepository();
      String response = await _loginRepository.signUp(SignUp(
          password: event.signupdata.password, email: event.signupdata.email));
      //create wallet
      // await walletRepo.createWallet(event.signupdata);
      await _loginRepository.signIn(
          event.signupdata.email, event.signupdata.password);
      yield LoginSucess();
    }
  }
}
