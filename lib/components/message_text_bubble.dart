// lib/components/message_text_bubble.dart

import 'package:flutter/material.dart';

class MessageTextBubble extends StatelessWidget {
  final String messageText;
  final bool isLinkOnly;
  final bool isCurrentUser; // 新しいパラメータを追加

  const MessageTextBubble({
    Key? key,
    required this.messageText,
    this.isLinkOnly = false,
    required this.isCurrentUser, // 必須パラメータとして追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 現在のユーザーかどうかに基づいて背景色を変更
    final backgroundColor = isCurrentUser
        ? Colors.blue[100] // 現在のユーザーの場合の背景色
        : Colors.grey[200]; // 他のユーザーの場合の背景色

    // isCurrentUser に基づいて borderRadius を動的に設定
    final borderRadius = isCurrentUser
        ? BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(8.0),
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    );

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isLinkOnly ? Colors.transparent : backgroundColor,
        borderRadius: borderRadius, // 動的に設定した borderRadius を適用
        border: isLinkOnly
            ? null
            : Border.all(color: Colors.black), // リンクのみの場合は枠線なし
      ),
      child: Text(
        messageText,
        style: TextStyle(
          color: isLinkOnly
              ? Theme.of(context).colorScheme.primary
              : Colors.black,
          decoration:
          isLinkOnly ? TextDecoration.underline : TextDecoration.none,
        ),
        textAlign: isCurrentUser ? TextAlign.right : TextAlign.left, // テキストの配置を変更
      ),
    );
  }
}
