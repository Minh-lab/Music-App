import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/change_password/change_password_cubit.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/cubit/change_password/change_password_state.dart';
import 'package:spotify_me/presentation/auth/pages/signin.dart';

class ConfirmPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: _ConfirmPasswordContent(),
    );
  }
}

class _ConfirmPasswordContent extends StatefulWidget {
  @override
  State<_ConfirmPasswordContent> createState() => _ConfirmPasswordContentState();
}

class _ConfirmPasswordContentState extends State<_ConfirmPasswordContent> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SigninPage(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _recoveryPasswordText(context),
                SizedBox(height: 36),
                _passwordField(context, _passwordController),
                SizedBox(height: 36),
                _confirmPasswordField(context, _confirmPasswordController),
                SizedBox(height: 36),
                state is ChangePasswordLoading
                  ? const CircularProgressIndicator()
                  : BasicAppButton(
                      title: 'Confirm', 
                      onPressed: () {
                        context.read<ChangePasswordCubit>().changePassword(
                          _passwordController.text,
                          _confirmPasswordController.text,
                        );
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _recoveryPasswordText(BuildContext context) {
    return const Text(
      'Recovery Password',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  Widget _passwordField(
    BuildContext context,
    TextEditingController _passwordController,
  ) {
    return TextField(
      controller: _passwordController,
      obscuringCharacter: '*',
      obscureText: true,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'New Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _confirmPasswordField(
    BuildContext context,
    TextEditingController _passwordController,
  ) {
    return TextField(
      controller: _passwordController,
      obscuringCharacter: '*',
      obscureText: true,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Confirm Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
