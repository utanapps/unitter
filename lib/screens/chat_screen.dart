// lib/screens/chat_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/favorite_button.dart';
import '../components/message_card.dart';
import '../components/message_input.dart';
import '../providers/message_list_notifier.dart';
import '../providers/supabase_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String channelId;
  final String channelName;

  ChatScreen({required this.channelId, required this.channelName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // スクロールコントローラーの設定
    _scrollController.addListener(() {
      final messageListNotifier =
      ref.read(messageListProvider(widget.channelId).notifier);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !messageListNotifier.isLoadingMore &&
          messageListNotifier.hasMore) {
        messageListNotifier.loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(
      String messageText, Uint8List? imageData, String? imageFileName) async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      String? imageUrl;

      if (imageData != null && imageFileName != null) {
        imageUrl = await supabaseService.uploadImage(
          bucketName: 'chat',
          userId: userId,
          imageData: imageData,
          fileName: imageFileName,
        );
      }

      await supabaseService.postChatMessage(
        channelId: widget.channelId,
        userId: userId,
        messageText: messageText,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageListProvider(widget.channelId));
    final messageListNotifier =
    ref.read(messageListProvider(widget.channelId).notifier);

    // 現在のユーザーIDを取得
    final supabaseService = ref.read(supabaseServiceProvider);
    final currentUserId = supabaseService.getCurrentUser()?.id;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text(widget.channelName),
        actions: [
          FavoriteButton(channelId: widget.channelId),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length +
                    (messageListNotifier.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (messageListNotifier.isLoadingMore &&
                      index == messages.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final message = messages[index];
                  final messageText = message['message_text'] ?? '';
                  final createdAt = DateTime.parse(message['created_at']);
                  final username = message['username'] ?? 'Unknown User';
                  final avatarUrl = message['avatar_url'] ?? '';
                  final imageUrl = message['image_url'] ?? '';
                  final senderId = message['sender_id'] ?? '';

                  // メッセージが現在のユーザーからのものかどうかを判定
                  final isCurrentUser = senderId == currentUserId;

                  return MessageCard(
                    avatarUrl: avatarUrl,
                    username: username,
                    messageText: messageText,
                    createdAt: createdAt,
                    imageUrl: imageUrl,
                    isCurrentUser: isCurrentUser, // パラメータを渡す
                  );
                },
              ),
            ),
            MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
