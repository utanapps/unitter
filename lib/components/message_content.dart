// lib/components/message_content.dart

import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:unitter/utils/link_utils.dart';
import 'package:unitter/components/link_preview.dart';
import 'package:unitter/components/message_text_bubble.dart';
import 'package:unitter/components/polaroid_image.dart';

class MessageContent extends StatelessWidget {
  final String messageText;
  final String imageUrl;
  final bool isCurrentUser; // 新しいパラメータを追加

  const MessageContent({
    Key? key,
    required this.messageText,
    required this.imageUrl,
    required this.isCurrentUser, // 必須パラメータとして追加
  }) : super(key: key);

  // メッセージがリンクのみで構成されているかを判定する関数
  bool isMessageLinkOnly(String message) {
    final elements = linkify(message);
    // リンク以外のテキストがあるか確認
    bool hasNonLinkText = elements.any(
          (element) => element is TextElement && element.text.trim().isNotEmpty,
    );
    return !hasNonLinkText;
  }

  // メッセージ内のURLを抽出する関数
  String? extractUrl(String message) {
    final link = extractUrlFromMessage(message);
    return link;
  }

  @override
  Widget build(BuildContext context) {
    final hasMessageText = messageText.trim().isNotEmpty;
    final hasImage = imageUrl.isNotEmpty;
    final url = extractUrl(messageText);

    // メッセージがリンクのみで構成されているかどうかを判定
    final linkOnly = isMessageLinkOnly(messageText);

    // メッセージコンテンツのリスト
    List<Widget> contentWidgets = [];

    // メッセージテキストが存在し、リンクのみでない場合に MessageTextBubble を表示
    if (hasMessageText && !linkOnly) {
      contentWidgets.add(
        MessageTextBubble(
          messageText: messageText,
          isLinkOnly: false,
          isCurrentUser: isCurrentUser, // パラメータを渡す
        ),
      );
    }

    // メッセージがリンクのみで構成されている場合は MessageTextBubble を追加しない
    // ただし、リンクプレビューは表示する
    if (linkOnly && url != null) {
      contentWidgets.add(
        LinkPreview(url: url),
      );
    }

    // 画像の表示（画像がある場合のみ表示）
    if (hasImage) {
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PolaroidImage(imageUrl: imageUrl),
        ),
      );
    }

    // メッセージがリンクのみでない場合でも、リンクプレビューがあれば表示
    if (!linkOnly && url != null) {
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LinkPreview(url: url),
        ),
      );
    }

    // 何も表示するものがなければ空のウィジェット
    if (contentWidgets.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: isCurrentUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start, // 条件付きで変更
      children: contentWidgets,
    );
  }
}
