import 'package:flutter/material.dart';
import '../components/message_bottom_sheet.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
class Utils {
  // メッセージのボトムシートを表示する関数
  static Future<void> showMessageBottomSheet(
      BuildContext context,
      String title,
      String message, {
        String buttonText = 'Close', // デフォルトのボタンテキスト
      }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return MessageBottomSheet(
          title: title,
          message: message,
          buttonText: buttonText,
        );
      },
    );
  }
  // 文字列を指定の文字数で省略する関数
  static String truncateString(String? text, {int limit = 50}) {
    if (text == null) return '';
    if (text.length > limit) {
      return text.substring(0, limit) + '...';
    }
    return text;
  }

  static String generateRoomId(String userId1, String userId2) {
    // ユーザーIDを昇順で並べ替えて結合
    List<String> userIds = [userId1, userId2]..sort();
    String combinedIds = userIds.join('_'); // IDを結合

    // 結合されたIDのSHA-256ハッシュを生成
    var bytes = utf8.encode(combinedIds);
    var digest = sha256.convert(bytes);

    // ハッシュの先頭から一定の長さを取り出してUUID風の形式に変換
    String roomId = digest.toString().substring(0, 8) + '-' +
        digest.toString().substring(8, 12) + '-' +
        digest.toString().substring(12, 16) + '-' +
        digest.toString().substring(16, 20) + '-' +
        digest.toString().substring(20, 32);
    return roomId;
  }



}
