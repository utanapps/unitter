// lib/services/rate_limiter.dart

import 'package:shared_preferences/shared_preferences.dart';

class RateLimiter {
  static const String _prefix = 'otp_sends_';
  static const int maxSends = 3; // 最大送信回数
  static const Duration window = Duration(minutes: 10); // 制限時間

  /// 指定された電話番号に対してOTPを送信できるか確認します。
  Future<bool> canSendOtp(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$phoneNumber';
    final List<String>? sendTimes = prefs.getStringList(key);

    if (sendTimes == null) {
      return true;
    }

    final now = DateTime.now();
    final windowStart = now.subtract(window);
    final recentSends = sendTimes
        .map((ts) => DateTime.parse(ts))
        .where((dt) => dt.isAfter(windowStart))
        .toList();

    return recentSends.length < maxSends;
  }

  /// 指定された電話番号に対するOTP送信を記録します。
  Future<void> recordOtpSend(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$phoneNumber';
    final now = DateTime.now();

    List<String> sendTimes = prefs.getStringList(key) ?? [];
    sendTimes.add(now.toIso8601String());

    // 制限時間内の送信履歴のみ保持
    final windowStart = now.subtract(window);
    sendTimes = sendTimes
        .where((ts) => DateTime.parse(ts).isAfter(windowStart))
        .toList();

    await prefs.setStringList(key, sendTimes);
  }
}
