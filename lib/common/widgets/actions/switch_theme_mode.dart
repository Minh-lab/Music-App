import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_me/core/configs/theme/app_colors.dart';
import 'package:spotify_me/core/configs/theme/app_theme.dart';
import 'package:spotify_me/presentation/choose_mode/bloc/theme_cubit.dart';

class SwitchThemeMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SwitchThemeModeState();
  }
}

class SwitchThemeModeState extends State<SwitchThemeMode> {
  bool _isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Switch(
          padding: EdgeInsets.only(right: 30),
          activeTrackColor: Colors.black,
          activeThumbColor: Colors.white,
          thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.nightlight_round, color: Colors.amber);
            }

            return const Icon(Icons.wb_sunny_rounded, color: Colors.amber);
          }),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
          value: mode == ThemeMode.dark,
          onChanged: (bool value) {
            context.read<ThemeCubit>().updateTheme(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        );
      },
    );
  }
}
