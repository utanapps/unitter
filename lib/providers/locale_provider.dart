import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/user_preferences.dart'; // 正しいパスに修正してください

final localeProvider = StateProvider<Locale>((ref) {
  String localeString = UserPreferences.getLocale();
  return Locale(localeString);
});
