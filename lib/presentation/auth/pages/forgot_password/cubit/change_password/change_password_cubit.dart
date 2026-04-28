import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/auth/change_password.dart';
import 'package:spotify_me/service_locator.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  Future<void> changePassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(ChangePasswordFailure(message: 'Please fill all fields'));
      return;
    }
    if (newPassword != confirmPassword) {
      emit(ChangePasswordFailure(message: 'Passwords do not match'));
      return;
    }

    emit(ChangePasswordLoading());

    final result = await sl<ChangePasswordUseCase>().call(
      params: newPassword,
    );

    result.fold(
      (error) {
        emit(ChangePasswordFailure(message: error.toString()));
      },
      (success) {
        emit(ChangePasswordSuccess());
      },
    );
  }
}
