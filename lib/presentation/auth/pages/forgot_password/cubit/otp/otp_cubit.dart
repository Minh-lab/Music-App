import 'dart:async'; // Bắt buộc import để dùng Timer
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/auth/check_otp.dart';
import 'package:spotify_me/domain/usecases/auth/send_otp.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/otp/otp_state.dart';
import 'package:spotify_me/service_locator.dart';

class OtpCubit extends Cubit<OtpState> {
  Timer? _timer;

  OtpCubit() : super(OtpInitial());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> sendOtpResetPassword(String email) async {
    if (state is OtpCountdown) return;

    var result = await sl<SendOtpUsecase>().call(params: email);

    result.fold(
      (l) {
        if (!isClosed) (OtpSendFailure(errorMessage: l.toString()));
      },
      (r) {
        if (!isClosed) emit(OtpSendSuccess());
        _startCountdown(60);
      },
    );
  }

  void _startCountdown(int startSeconds) {
    _timer?.cancel(); // Xóa timer cũ nếu có
    int remaining = startSeconds;

    emit(OtpCountdown(remaining));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;

      if (remaining > 0) {
        emit(OtpCountdown(remaining));
      } else {
        timer.cancel();
        emit(OtpUnlocked());
      }
    });
  }

  Future<void> checkOtpResetPassword(String email, String otpCode) async {
    var result = await sl<CheckOtpUsecase>().call(
      params: CheckOtpParams(email: email, otp: otpCode),
    );
    result.fold(
      (l) {
        emit(OtpCheckFailure(errorMessage: l.toString()));
      },
      (r) {
        emit(OtpCheckSuccess());
      },
    );
  }
}
