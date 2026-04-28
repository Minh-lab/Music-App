import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/common/helpers/is_dark_mode.dart';
import 'package:spotify_me/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/domain/entities/auth/user.dart';
import 'package:spotify_me/presentation/auth/pages/signup_or_signin.dart';
import 'package:spotify_me/presentation/profile/bloc/logout_cubit.dart';
import 'package:spotify_me/presentation/profile/bloc/logout_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, 
            color: context.isDarkMode ? Color(0xFFDBDBDB) : Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [_userInformation(context, UserEntity())]),
      ),
    );
  }

  Widget _userInformation(BuildContext context, UserEntity user) {
    return Center(
      child: Column(
        // spacing: 20,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD9D9D9),
              border: Border.all(
                width: 2,
                color: context.isDarkMode ? Colors.transparent : Colors.black,
              ),
            ),
            child: ClipOval(
              child: Image.asset(AppImages.avartar, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 12),
          Text(user.fullName ?? 'Anonymouse'),
          Text(user.email ?? 'anonymouse@gmail.com'),
          SizedBox(height: 50),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                _action(
                  context,
                  Icon(Icons.edit_outlined, size: 30),
                  'Edit Profile',
                  Icon(Icons.arrow_forward_ios_outlined),
                  () {},
                ),
                _action(
                  context,
                  Icon(Icons.lock_outline_rounded, size: 30),
                  'Change Password',
                  Icon(Icons.arrow_forward_ios_outlined),
                  () {},
                ),
                _action(
                  context,
                  Icon(Icons.settings_outlined, size: 30),
                  'Setting',
                  Icon(Icons.arrow_forward_ios_outlined),
                  () {},
                ),
                BlocProvider(
                  create: (_) => LogoutCubit(),
                  child: BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, state) {
                      return _action(
                        context,
                        Icon(Icons.lock_outline_rounded, size: 30),
                        'Logout',
                        Icon(Icons.arrow_forward_ios_outlined),
                        () {
                          context.read<LogoutCubit>().logout();
                          Future.delayed(Duration(seconds: 2));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupOrSigninPage(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(
    BuildContext context,
    Widget? leadIcon,
    String? title,
    Widget? suffixIcon,
    VoidCallback? onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: leadIcon,
                  ),
                  Text(title ?? 'No action'),
                ],
              ),
            ),

            IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
