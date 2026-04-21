import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';
import 'package:spotify_me/domain/usecases/auth/signin.dart';
import 'package:spotify_me/presentation/auth/bloc/signin/signin_state.dart';
import 'package:spotify_me/service_locator.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());
  Future<void> signin(SigninRequest signinRequest) async {
    emit(SigninLoading());
    var results = await Future.wait([
      sl<SigninUsecase>().call(params: signinRequest),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    var result = results[0] as Either;
    result.fold(
      (l) {
        emit(SigninFailure(errorMessage: l.toString()));
      
      },
      (r) {
        if(!isClosed)emit(SigninSuccess());
      },
    );
  }
}
