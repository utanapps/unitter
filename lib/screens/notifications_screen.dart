import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/supabase_service.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart'; // 追加: 多言語サポート用

class NotificationsScreen extends ConsumerStatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<Map<String, dynamic>> _unreadNotifications = [];
  List<Map<String, dynamic>> _readNotifications = [];
  int _selectedTabIndex = 0;

  int _unreadPage = 1;
  int _readPage = 1;
  final int _pageSize = 20;
  bool _unreadHasMore = true;
  bool _readHasMore = true;

  Future<void> _fetchNotifications(SupabaseService supabaseService, String userId, {bool isRead = false}) async {
    try {
      final page = isRead ? _readPage : _unreadPage;
      final notifications = await supabaseService.getNotifications(userId, isRead: isRead, page: page, pageSize: _pageSize);

      setState(() {
        if (isRead) {
          _readNotifications.addAll(notifications);
          _readHasMore = notifications.length == _pageSize;
          _readPage++;
        } else {
          _unreadNotifications.addAll(notifications);
          _unreadHasMore = notifications.length == _pageSize;
          _unreadPage++;
        }
      });
    } catch (e) {
      print('${S.of(context).fetchNotificationsError}: $e');
    }
  }

  Future<void> _markNotificationAsRead(SupabaseService supabaseService, String notificationId, int index) async {
    try {
      await supabaseService.markNotificationAsRead(notificationId);

      setState(() {
        final notification = _unreadNotifications.removeAt(index);
        _readNotifications.insert(0, notification);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).notificationMarkedAsRead)),
      );
    } catch (e) {
      print('${S.of(context).markNotificationAsReadError}: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      _fetchNotifications(supabaseService, userId, isRead: false);
      _fetchNotifications(supabaseService, userId, isRead: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).notifications), // タイトルを多言語対応
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: [
              Tab(text: S.of(context).unread), // タブ1: 未読
              Tab(text: S.of(context).read), // タブ2: 既読
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList(supabaseService, _unreadNotifications, false),
            _buildNotificationList(supabaseService, _readNotifications, true),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(SupabaseService supabaseService, List<Map<String, dynamic>> notifications, bool isRead) {
    final userId = supabaseService.getCurrentUser()?.id;

    return notifications.isNotEmpty
        ? Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final type = notification['type'] ?? 'unknown';
              final message = notification['message'] ?? S.of(context).noNotificationContent;
              final relatedUserId = notification['related_user_id'];
              final notificationId = notification['id'];

              return FutureBuilder<Map<String, dynamic>>(
                future: relatedUserId != null
                    ? supabaseService.getUserProfile(relatedUserId)
                    : null,
                builder: (context, snapshot) {
                  final userProfile = snapshot.data ?? {};
                  final avatarUrl = userProfile['avatar_url'] as String? ?? 'assets/images/default_avatar2.png';
                  final username = userProfile['username'] as String? ?? S.of(context).unknownUser;

                  return Card(
                    color: _getNotificationBackgroundColor(type),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: (avatarUrl.startsWith('http')
                                ? NetworkImage(avatarUrl)
                                : AssetImage('assets/images/default_avatar2.png')) as ImageProvider<Object>,
                            radius: 30,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  relatedUserId != null ? '$username: $message' : message,
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                if (type == 'friend_request')
                                  _getNotificationActions(type, notification, index, isRead),
                              ],
                            ),
                          ),
                          if (!isRead)
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () async {
                                if (notificationId != null) {
                                  await _markNotificationAsRead(supabaseService, notificationId, index);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if ((isRead && _readHasMore) || (!isRead && _unreadHasMore))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (userId != null) {
                  _fetchNotifications(supabaseService, userId, isRead: isRead);
                }
              },
              child: Text(S.of(context).loadMore),
            ),
          ),
      ],
    )
        : Center(
      child: Text(isRead ? S.of(context).noReadNotifications : S.of(context).noUnreadNotifications),
    );
  }

  Color _getNotificationBackgroundColor(String type) {
    switch (type) {
      case 'friend_request':
        return Colors.lightBlue[50]!;
      case 'friend_accepted':
        return Colors.green[50]!;
      case 'system':
        return Colors.yellow[50]!;
      case 'event':
        return Colors.pink[50]!;
      case 'info':
        return Colors.orange[50]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Widget _getNotificationActions(String type, Map<String, dynamic> notification, int index, bool isRead) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;
    final notificationId = notification['id'];

    if (type == 'friend_request' && !isRead) {
      final senderId = notification['related_user_id'];

      return Row(
        children: [
          TextButton(
            onPressed: () async {
              if (senderId != null && userId != null) {
                try {
                  await supabaseService.acceptFriendRequest(senderId, userId);

                  if (notificationId != null) {
                    await supabaseService.markNotificationAsRead(notificationId);
                  }

                  setState(() {
                    _unreadNotifications.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).friendRequestAccepted)),
                  );
                } catch (e) {
                  print('${S.of(context).friendRequestAcceptError}: $e');
                }
              } else {
                print('${S.of(context).invalidSenderOrUserId}');
              }
            },
            child: Text(S.of(context).accept),
          ),
          TextButton(
            onPressed: () async {
              if (notificationId != null) {
                await supabaseService.markNotificationAsRead(notificationId);
              }

              setState(() {
                _unreadNotifications.removeAt(index);
              });
            },
            child: Text(S.of(context).ignore),
          ),
        ],
      );
    }
    return Container();
  }

}
