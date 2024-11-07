// lib/components/message_bubble.dart

import 'package:flutter/material.dart';
import 'package:unitter/components/message_content.dart';
import 'package:unitter/components/user_info_header.dart';

class MessageCard extends StatelessWidget {
  final String? senderId; // オプショナル
  final String avatarUrl;
  final String username;
  final String messageText;
  final DateTime createdAt;
  final String imageUrl; // 画像URL
  final bool isCurrentUser; // 新しいパラメータを追加

  const MessageCard({
    Key? key,
    this.senderId, // オプショナル
    required this.avatarUrl,
    required this.username,
    required this.messageText,
    required this.createdAt,
    required this.imageUrl,
    required this.isCurrentUser, // 必須パラメータとして追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: hasAvatar
                  ? NetworkImage(avatarUrl)
                  : AssetImage('assets/images/default_avatar.png')
              as ImageProvider,
              radius: 20,
            ),
          if (!isCurrentUser) SizedBox(width: 12.0),
          // メッセージ内容
          Expanded(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                UserInfoHeader(
                  avatarUrl: avatarUrl,
                  username: username,
                  createdAt: createdAt,
                  isCurrentUser: isCurrentUser, // パラメータを渡す
                ),
                SizedBox(height: 8.0),
                MessageContent(
                  messageText: messageText,
                  imageUrl: imageUrl,
                  isCurrentUser: isCurrentUser, // パラメータを渡す
                ),
              ],
            ),
          ),
          if (isCurrentUser) SizedBox(width: 12.0),
          if (isCurrentUser)
            CircleAvatar(
              backgroundImage: hasAvatar
                  ? NetworkImage(avatarUrl)
                  : AssetImage('assets/images/default_avatar.png')
              as ImageProvider,
              radius: 20,
            ),
        ],
      ),
    );
  }
}
