import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/user_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  // UserPreferencesから保存されたテーマモードを取得し、それに基づいて初期化する
  final themeModeString = UserPreferences.getThemeMode();
  final themeMode = ThemeMode.values.firstWhere((mode) => mode.toString().split('.').last == themeModeString, orElse: () => ThemeMode.system);
  return ThemeModeNotifier(themeMode);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(super.state);

  // テーマモードを設定し、UserPreferencesに保存
  void setThemeMode(ThemeMode newThemeMode) {
    state = newThemeMode;
    UserPreferences.setThemeMode(newThemeMode.toString().split('.').last);
  }
}
