abstract class SigninState {}

class SigninInitial extends SigninState {}

class SigninFailure extends SigninState {
  String? errorMessage;
  SigninFailure({this.errorMessage});
}

class SigninLoading extends SigninState {}

class SigninSuccess extends SigninState {}
