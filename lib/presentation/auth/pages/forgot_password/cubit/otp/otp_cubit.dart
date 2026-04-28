import 'dart:async'; // Bắt buộc import để dùng Timer
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/domain/usecases/auth/check_otp.dart';
import 'package:spotify_me/domain/usecases/auth/send_otp.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/otp/otp_state.dart';
import 'package:spotify_me/service_locator.dart';

class OtpCubit extends Cubit<OtpState> {
  Timer? _timer; // Biến giữ đồng hồ đếm

  OtpCubit() : super(OtpInitial());

  // RẤT QUAN TRỌNG: Hủy đồng hồ khi người dùng thoát trang
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> sendOtpResetPassword(String email) async {
    // Chặn không cho bấm gửi tiếp nếu đang trong lúc đếm ngược
    if (state is OtpCountdown) return;

    var result = await sl<SendOtpUsecase>().call(params: email);

    result.fold(
      (l) {
        if (!isClosed) (OtpSendFailure(errorMessage: l.toString()));
      },
      (r) {
        if (!isClosed) emit(OtpSendSuccess());
        _startCountdown(60); // Gọi hàm bắt đầu đếm 60s
      },
    );
  }

  // Hàm xử lý đếm ngược
  void _startCountdown(int startSeconds) {
    _timer?.cancel(); // Xóa timer cũ nếu có
    int remaining = startSeconds;

    emit(OtpCountdown(remaining)); // Phát tín hiệu giây đầu tiên (60)

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;

      if (remaining > 0) {
        // Nếu còn thời gian -> emit số giây còn lại
        emit(OtpCountdown(remaining));
      } else {
        // Hết giờ -> Hủy đồng hồ và mở khóa nút
        timer.cancel();
        emit(OtpUnlocked()); // Trở lại trạng thái bình thường
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
