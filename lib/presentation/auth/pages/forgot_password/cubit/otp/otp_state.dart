abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpBlocked extends OtpState {}

class OtpUnlocked extends OtpState {}

class OtpSendSuccess extends OtpState {}

class OtpSendFailure extends OtpState {
  String? errorMessage;
  OtpSendFailure({this.errorMessage});
}

// Thêm class này vào file state của bạn
class OtpCountdown extends OtpState {
  final int seconds;
  OtpCountdown(this.seconds);
}

class OtpCheckSuccess extends OtpState {}

class OtpCheckFailure extends OtpState {
  String? errorMessage;
  OtpCheckFailure({this.errorMessage});
}
