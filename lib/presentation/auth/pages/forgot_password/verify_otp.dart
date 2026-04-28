import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/confirm_password.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/otp/otp_cubit.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/otp/otp_state.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/verify_otp.dart';
import 'package:spotify_me/service_locator.dart';

class VerifyOtp extends StatefulWidget {
  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (BuildContext context) {
        return sl<OtpCubit>();
      },
      child: Scaffold(
        appBar: BasicAppBar(
          title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _VerifyOtpText(context),
              SizedBox(height: 36),
              _emailField(context, _emailController),
              SizedBox(height: 36),

              Row(
                children: [
                  Expanded(child: _otpField(context, _otpController)),
                  const SizedBox(width: 16),
                  BlocBuilder<OtpCubit, OtpState>(
                    builder: (context, state) {
           
                      final bool isCounting = state is OtpCountdown;

            
                      final int secondsLeft = isCounting ? state.seconds : 0;

                      return BasicAppButton(
                        width: 10,
                        height: 60,
                        title: isCounting
                            ? 'Resend in ${secondsLeft}s'
                            : 'Send OTP',

                        onPressed: isCounting
                            ? null
                            : () {
                                context.read<OtpCubit>().sendOtpResetPassword(
                                  _emailController.text,
                                );
                              },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 36),

              BlocListener<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpCheckSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ConfirmPassword()),
                    );
                  }
                  if (state is OtpCheckFailure) {
                    var snackBar = SnackBar(content: Text(state.errorMessage!));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Builder(
                  builder: (innerContext) {
                    return BasicAppButton(
                      title: 'Confirm',
                      onPressed: () async {
                        await innerContext.read<OtpCubit>().checkOtpResetPassword(
                          _emailController.text.trim(),
                          _otpController.text.trim(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpField(BuildContext context, TextEditingController _otpController) {
    return TextField(
      controller: _otpController,
      decoration: InputDecoration(
        hintText: 'Enter otp',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField(
    BuildContext context,
    TextEditingController _emailController,
  ) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _VerifyOtpText(BuildContext context) {
    return const Text(
      'Forgot Password',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  Widget _sendOtpButotn(
    BuildContext context,
    VoidCallback onPressed,
    OtpState state,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Send Email'),
      style: ButtonStyle(),
    );
  }
}
