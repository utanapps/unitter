import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';
import 'supabase_provider.dart';

class MessageListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final SupabaseService supabaseService;
  final String channelId;
  final int limit;
  bool isLoadingMore = false;
  bool hasMore = true;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  MessageListNotifier({
    required this.supabaseService,
    required this.channelId,
    this.limit = 10,
  }) : super([]) {
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    _subscription = supabaseService
        .fetchChatMessagesStream2(channelId, limit)
        .listen((data) {
      final existingIds = state.map((message) => message['id']).toSet();
      final newMessages =
      data.where((message) => !existingIds.contains(message['id'])).toList();
      state = [...newMessages, ...state];

      if (data.length < limit) {
        hasMore = false;
      }
    }, onError: (error) {
      print('Error loading messages: $error');
    });
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore || !hasMore || state.isEmpty) return;

    isLoadingMore = true;

    DateTime lastMessageTime = DateTime.parse(state.last['created_at']);

    print('Loading more messages before $lastMessageTime');

    try {
      final olderMessages = await supabaseService.fetchOlderMessages(
        channelId,
        lastMessageTime,
        limit,
      );
      final existingIds = state.map((message) => message['id']).toSet();
      final newMessages = olderMessages
          .where((message) => !existingIds.contains(message['id']))
          .toList();
      state = [...state, ...newMessages];

      if (olderMessages.length < limit) {
        hasMore = false;
        print('No more messages to load');
      }
    } catch (error) {
      print('Error loading more messages: $error');
    } finally {
      isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final messageListProvider = StateNotifierProvider.family<
    MessageListNotifier, List<Map<String, dynamic>>, String>((ref, channelId) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return MessageListNotifier(
    supabaseService: supabaseService,
    channelId: channelId,
  );
});
