import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_me/common/circle_process/circle_process.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/data/models/auth/signin_request.dart';
import 'package:spotify_me/domain/usecases/auth/signin.dart';
import 'package:spotify_me/presentation/auth/bloc/signin/signin_cubit.dart';
import 'package:spotify_me/presentation/auth/bloc/signin/signin_state.dart';
import 'package:spotify_me/presentation/auth/pages/forgot_password/verify_otp.dart';
import 'package:spotify_me/presentation/auth/pages/signup.dart';
import 'package:spotify_me/presentation/home/pages/home.dart';
import 'package:spotify_me/presentation/main/pages/main_pages.dart';
import 'package:spotify_me/service_locator.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SigninPageState();
  }
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (_) => SigninCubit(),
      child: BlocConsumer<SigninCubit, SigninState>(
        listener: (context, state) {
          if (state is SigninSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => MainPages()),
              (route) => false,
            );
          }
          if (state is SigninFailure) {
            SnackBar snackBar = SnackBar(
              content: Text(state.errorMessage ?? 'Sign in failed'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: BasicAppBar(
                  title: SvgPicture.asset(
                    AppVectors.logo,
                    height: 40,
                    width: 40,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 47,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _signinText(context),
                        SizedBox(height: 50),
                        _emailField(context),

                        SizedBox(height: 20),
                        _passwordField(context),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _recoveryPassword(context),
                          ),
                        ),
                        SizedBox(height: 20),
                        BasicAppButton(
                          title: 'Sign In',
                          onPressed: () {
                            context.read<SigninCubit>().signin(
                              SigninRequest(
                                userOrEmail: _emailController.text.toString(),
                                password: _passwordController.text.toString(),
                              ),
                            );
                          },
                        ),

                        // Spacer(),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: _registerText(context),
              ),

              if (state is SigninLoading)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.2),
                        child: CircleProcess(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signinText(BuildContext context) {
    return const Text(
      'Sign In',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: _isObscure,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),

        hintText: 'Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _recoveryPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtp()),
        );
      },
      child: Text('Recovery Password'),
    );
  }

  Widget _registerText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Not A Member ?', style: TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage(),
                ),
              );
            },
            child: Text(
              'Register Now',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF288CE9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
