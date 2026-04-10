import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit(): super(ThemeMode.system);
  //mặc định hiển thị sáng tối tùy theo cài đặt hệ điều hành trên điện thoại
  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final themeIndex = json['theme'] as int?;
    if (themeIndex != null) {
      return ThemeMode.values[themeIndex];
    }
    return ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme': state.index};
  }
}