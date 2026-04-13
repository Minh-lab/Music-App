import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/domain/usecases/auth/signup.dart';
import 'package:spotify_me/presentation/auth/bloc/signin/signin_state.dart';
import 'package:spotify_me/presentation/auth/bloc/signup/signup_state.dart';
import 'package:spotify_me/service_locator.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  Future<void> signup(CreateUserRequest createUserRequest) async {
    emit(SignupLoading());
    var results = await Future.wait([
      sl<SignupUsecase>().call(params: createUserRequest),
      Future.delayed(Duration(seconds: 2)),
    ]);
    var result = results[0] as Either;
    result.fold(
      (l) {
        emit(SignupFailure(errorMessage: l.toString()));
      },
      (r) {
        emit(SignupSuccess());
      },
    );
  }
}
