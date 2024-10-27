import 'package:flutter/material.dart'; // Flutterのロケールを使用するために必要
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _keyLocale = 'locale';
  static const _keyThemeMode = 'themeMode'; // テーマモードを保存するためのキーを定義
  static const _keyFontSize = 'fontSize'; // フォントサイズを保存するためのキー

  // SharedPreferencesの初期化
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance(); // SharedPreferencesのインスタンスを取得
    String initialLocale = getLocale(); // SharedPreferencesからロケールを取得
    Locale deviceLocale = WidgetsBinding.instance.window.locale;

    // デバイスのロケールを取得
    if (initialLocale.isEmpty) {
      // SharedPreferencesにロケールが設定されていない場合は、デバイスのロケールを設定
      await setLocale(deviceLocale.languageCode);
    }
  }

  // ロケールを設定するメソッド
  static Future<void> setLocale(String locale) async {
    await _preferences?.setString(_keyLocale, locale); // SharedPreferencesにロケールを設定

  }

  // ロケールを取得するメソッド
  static String getLocale() {
    return _preferences?.getString(_keyLocale) ?? '';// SharedPreferencesからロケールを取得。未設定の場合は空文字列を返す
  }

  // テーマモードを設定するメソッド
  static Future<void> setThemeMode(String themeMode) async {
    await _preferences?.setString(_keyThemeMode, themeMode); // SharedPreferencesにテーマモードを設定
  }

  // テーマモードを取得するメソッド
  static String getThemeMode() {
    return _preferences?.getString(_keyThemeMode) ?? 'System'; // SharedPreferencesからテーマモードを取得。未設定の場合は"System"を返す
  }

  // フォントサイズを保存するメソッド
  static Future<void> setFontSize(double fontSize) async {
    await _preferences?.setDouble(_keyFontSize, fontSize);
  }

  // フォントサイズを取得するメソッド
  static double getFontSize() {
    return _preferences?.getDouble(_keyFontSize) ?? 16.0; // デフォルト値を16.0とする
  }
}


