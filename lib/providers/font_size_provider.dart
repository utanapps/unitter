import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/user_preferences.dart';

// SharedPreferencesから保存されたフォントサイズを取得
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final savedFontSize = UserPreferences.getFontSize();
  return FontSizeNotifier(savedFontSize);
});

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier(double state) : super(state);

  void setFontSize(double newSize) {
    state = newSize;
    UserPreferences.setFontSize(newSize); // 新しいフォントサイズを保存
  }
}
