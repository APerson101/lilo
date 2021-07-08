abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSucess extends LoginState {}

enum FailureCode { invalidEmail, userNotFound, wrongPassword, internetIssue }

class LoginFailure extends LoginState {
  FailureCode failureCode;
  LoginFailure(this.failureCode);
}

class UnknownLoginError extends LoginState {}
