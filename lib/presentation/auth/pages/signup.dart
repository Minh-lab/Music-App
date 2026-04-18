import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/data/models/auth/create_user_request.dart';
import 'package:spotify_me/domain/usecases/auth/signup.dart';
import 'package:spotify_me/presentation/auth/bloc/signup/signup_cubit.dart';
import 'package:spotify_me/presentation/auth/bloc/signup/signup_state.dart';
import 'package:spotify_me/presentation/auth/pages/signin.dart';
import 'package:spotify_me/presentation/home/pages/home.dart';
import 'package:spotify_me/presentation/main/pages/main_pages.dart';
import 'package:spotify_me/service_locator.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => MainPages()),
              (route) => false,
            );
          }
          if (state is SignupFailure) {
            SnackBar snackBar = SnackBar(
              content: Text(state.errorMessage ?? 'Signup Failed'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                bottomNavigationBar: _signinText(context),
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
                        _registerText(context),
                        SizedBox(height: 50),
                        _fulNameField(context),
                        SizedBox(height: 20),
                        _emailField(context),
                        SizedBox(height: 20),
                        _passwordField(context),
                        SizedBox(height: 20),
                        BasicAppButton(
                          title: 'Create Account',
                          onPressed: () async {
                            context.read<SignupCubit>().signup(
                              CreateUserRequest(
                                fullName: _fullnameController.text.toString(),
                                email: _emailController.text.toString(),
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
              ),
              if (state is SignupLoading) _loading(),
            ],
          );
        },
      ),
    );
  }

  Widget _loading() {
    return Positioned.fill(
      child: AbsorbPointer(
        absorbing: true,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withValues(alpha: 0.2),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _registerText(BuildContext context) {
    return const Text(
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  Widget _fulNameField(BuildContext context) {
    return TextField(
      controller: _fullnameController,
      decoration: InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
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

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Do you have an account? ', style: TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SigninPage(),
                ),
              );
            },
            child: Text(
              'Sign In',
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
