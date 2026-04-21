import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/auth/logout.dart';
import 'package:spotify_me/presentation/profile/bloc/logout_state.dart';
import 'package:spotify_me/service_locator.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());
  Future<void> logout() async {
    var result = await sl<LogoutUsecase>().call();
    result.fold(
      (l) {
        emit(LogoutFailure());
      },
      (r) {
        if (r == true) {
          // emit(LogoutSuccess());
        } else {
          emit(LogoutFailure());
        }
      },
    );
  }
}
