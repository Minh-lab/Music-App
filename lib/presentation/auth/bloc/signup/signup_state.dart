abstract class SignupState {}
class SignupInitial extends SignupState{}
class SignupLoading extends SignupState{}
class SignupFailure extends SignupState{
  String? errorMessage;
  SignupFailure({this.errorMessage});
}
class SignupSuccess extends SignupState{}