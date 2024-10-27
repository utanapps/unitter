import 'package:flutter/material.dart';

class MessageBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  const MessageBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Close',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5, // 画面の50%の高さに設定
      width: screenWidth, // 画面の幅いっぱいに設定
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.center, // タイトルをセンターに配置
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.left, // メッセージを左寄せに設定
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
