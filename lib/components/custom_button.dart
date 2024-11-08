import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor; // デフォルトの背景色を設定
  final Color textColor; // デフォルトのフォントカラーを設定
  final EdgeInsetsGeometry padding;
  final double textSize; // テキストサイズ

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xff06DD76), // Use 'const' here
    this.textColor = Colors.black, // デフォルトのフォントカラーを白に設定
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.textSize = 16.0, // デフォルトのテキストサイズを16に設定
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // 渡された背景色を使用
          foregroundColor: textColor, // 渡されたフォントカラーを使用
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(100, 50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor, // 渡されたフォントカラーを使用
            fontSize: textSize, // 渡されたテキストサイズを使用
          ),
        ),
      ),
    );
  }
}
