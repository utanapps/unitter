import 'package:flutter/material.dart';
import 'language_dropdown.dart'; // LanguageDropdown ウィジェット

// カスタムAppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // タイトル
  final List<Widget>? actions; // AppBar のカスタマイズされたアクションボタン
  final Color backgroundColor; // 背景色
  final PreferredSizeWidget? bottom; // Bottomウィジェット（TabBarなど）

  // コンストラクタでパラメータを受け取る
  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor = const Color(0xff06DD76),
    this.bottom,
  }) : super(key: key);

  // PreferredSizeWidget のサイズを定義（AppBarの高さ）
  @override
  Size get preferredSize =>
      Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + 50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        const LanguageDropdown(), // LanguageDropdownは常に表示
        if (actions != null) ...actions!, // 他のカスタマイズされたアクションを追加
      ],
      backgroundColor: backgroundColor,
      bottom: bottom, // 必要に応じてTabBarなどを追加
    );
  }
}
