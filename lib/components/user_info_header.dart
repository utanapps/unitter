// lib/components/user_info_header.dart

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserInfoHeader extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final DateTime createdAt;
  final bool isCurrentUser; // 新しいパラメータを追加

  const UserInfoHeader({
    Key? key,
    required this.avatarUrl,
    required this.username,
    required this.createdAt,
    required this.isCurrentUser, // 必須パラメータとして追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(createdAt);

    return Row(
      mainAxisAlignment:
      isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start, // 条件付きで変更
      children: [
        Text(
          username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.0), // テキスト間のスペース
        Text(
          timeAgo,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
