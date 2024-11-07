import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/components/message_card.dart';
import 'package:unitter/components/message_input.dart';
import '../providers/supabase_provider.dart';
import '../components/custom_snack_bar.dart';
import '../generated/l10n.dart';

class PrivateChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendUsername;

  PrivateChatScreen({
    required this.currentUserId,
    required this.friendId,
    required this.friendUsername,
  });

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends ConsumerState<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final int _limit = 10;
  String? _roomId;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final supabaseService = ref.read(supabaseServiceProvider);
    try {
      _roomId = await supabaseService.getOrCreateRoomId(widget.currentUserId, widget.friendId);
      if (_roomId != null) {
        _loadInitialMessages(_roomId!);
        _setupScrollController();
      }
    } catch (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).chatInitError,
      );
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadInitialMessages(String roomId) {
    final supabaseService = ref.read(supabaseServiceProvider);

    _subscription = supabaseService
        .fetchPrivateChatMessagesStream2(_roomId!, widget.currentUserId, _limit)
        .listen((data) {
      setState(() {
        final existingIds = _messages.map((message) => message['id']).toSet();

        final newMessages = data
            .where((message) => !existingIds.contains(message['id']))
            .toList();

        _messages.insertAll(0, newMessages);

        if (data.length < _limit) {
          _hasMore = false;
        }
      });
    }, onError: (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).messageLoadError,
      );
    });
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMore || _messages.isEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    final supabaseService = ref.read(supabaseServiceProvider);
    DateTime lastMessageTime = DateTime.parse(_messages.last['created_at']);

    try {
      final olderMessages = await supabaseService.fetchOlderMessages2(
        _roomId!,
        widget.currentUserId,
        lastMessageTime,
        _limit,
      );

      setState(() {
        final existingIds = _messages.map((message) => message['id']).toSet();

        final newMessages = olderMessages
            .where((message) => !existingIds.contains(message['id']))
            .toList();

        _messages.addAll(newMessages);

        if (olderMessages.length < _limit) {
          _hasMore = false;
        }
        _isLoadingMore = false;
      });
    } catch (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).messageLoadError,
      );
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _sendMessage(
      String messageText, Uint8List? imageData, String? imageFileName) async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      String? imageUrl;

      if (imageData != null && imageFileName != null) {
        try {
          imageUrl = await supabaseService.uploadImage(
            bucketName: 'chat',
            userId: userId,
            imageData: imageData,
            fileName: imageFileName,
          );
        } catch (error) {
          CustomSnackBar.show(
            ScaffoldMessenger.of(context),
            S.of(context).imageUploadError,
          );
          return;
        }
      }

      try {
        await supabaseService.sendPrivateMessage(
          senderId: widget.currentUserId,
          receiverId: widget.friendId,
          roomId: _roomId!,
          messageText: messageText,
          imageUrl: imageUrl,
        );
      } catch (error) {
        CustomSnackBar.show(
          ScaffoldMessenger.of(context),
          S.of(context).messageSendError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.friendUsername),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendUsername),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoadingMore && index == _messages.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final message = _messages[index];
                  final senderId = message["sender_id"];
                  final messageText = message['message_text'] ?? '';
                  final createdAt = DateTime.parse(message['created_at']);
                  final username = message['username'] ?? S.of(context).unknownUser;
                  final avatarUrl = message['avatar_url'] ?? '';
                  final imageUrl = message['image_url'] ?? '';

                  final isCurrentUser = senderId == widget.currentUserId;

                  return MessageCard(
                    senderId: senderId,
                    avatarUrl: avatarUrl,
                    username: username,
                    messageText: messageText,
                    createdAt: createdAt,
                    imageUrl: imageUrl,
                    isCurrentUser: isCurrentUser,
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
