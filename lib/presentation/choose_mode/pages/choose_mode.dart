import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_me/common/widgets/button/basic_app_button.dart';
import 'package:spotify_me/core/configs/assets/app_images.dart';
import 'package:spotify_me/core/configs/assets/app_vectors.dart';
import 'package:spotify_me/presentation/auth/pages/signup_or_signin.dart';
import 'package:spotify_me/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify_me/presentation/home/pages/home.dart';

class ChooseModePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseModePageState();
  }
}

class ChooseModePageState extends State<ChooseModePage> {
  bool isLight = false;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.chooseModeBG),
              ),
              color: Colors.grey,
            ),
          ),

          Container(color: Colors.black.withValues(alpha: 0.15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      'Choose Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isDark = true;
                                  isLight = false;
                                });
                                context.read<ThemeCubit>().updateTheme(
                                  ThemeMode.dark,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF30393C,
                                  ).withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: (isDark)
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: SvgPicture.asset(AppVectors.moon),
                              ),
                            ),
                          ),
                        ),
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isDark = false;
                                  isLight = true;
                                  context.read<ThemeCubit>().updateTheme(
                                    ThemeMode.light,
                                  );
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF30393C,
                                  ).withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: (isLight)
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: SvgPicture.asset(AppVectors.sun),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 21),

                SizedBox(height: 20),
                BasicAppButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
