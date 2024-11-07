import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/screens/user_profile_screen.dart';
import 'package:unitter/services/supabase_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unitter/utils/dialog_helpers.dart';
import '../generated/l10n.dart';
import 'chat_screen.dart';
import 'create_channel_screen.dart';
import 'edit_channel_screen.dart';
import 'poll_detail_screen.dart';
import 'create_poll_screen.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  bool imageLoadingFailed = false;

  @override
  void initState() {
    super.initState();
    final supabaseService = SupabaseService();
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      // プロフィール情報を取得し、usernameが空またはnullの場合のみダイアログを表示
      supabaseService.fetchUserProfile(userId).then((profile) {
        if (profile.isEmpty) {
          // プロフィールが取得できない場合のエラーメッセージ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).error)),
          );
        } else if (profile['username'] == null || profile['username'].isEmpty) {
          // usernameが空またはnullの場合にダイアログを表示
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final result = await showUsernameDialog(context, supabaseService, userId);
            if (result == true) {
              setState(() {});
            }
          });
        }
      }).catchError((error) {
        // 通信エラー時のエラーメッセージ表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).error)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();
    final userId = supabaseService.getCurrentUser()?.id;

    return Scaffold(
      body: userId == null
          ? Center(child: Text(S.of(context).notLoggedInMessage))
          : ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          // プロファイル情報の表示
          FutureBuilder<Map<String, dynamic>>(
            future: supabaseService.fetchUserProfile(userId!),
            builder: (context, karmaSnapshot) {
              if (!karmaSnapshot.hasData) {
                return _buildPlaceholderCard();
              }

              final int karma = karmaSnapshot.data?['karma'] ?? 0;
              final String avatarUrl = karmaSnapshot.data?['avatar_url'] ?? '';
              final String username = karmaSnapshot.data?['username'] ?? 'anon';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                  );
                },
                child: Card(
                  color: const Color(0xffD1E3E2),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: !imageLoadingFailed && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              imageLoadingFailed = true;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${S.of(context).karmaLabel} : $karma",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        QrImageView(
                          data: userId,
                          version: QrVersions.auto,
                          size: 100.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // 自分がオーナーのチャンネルリストの表示
          FutureBuilder<List<Map<String, dynamic>>>(
            future: supabaseService.fetchOwnedChannels(userId!),
            builder: (context, ownedChannelSnapshot) {
              if (!ownedChannelSnapshot.hasData) {
                return _buildPlaceholderCard();
              }

              final ownedChannels = ownedChannelSnapshot.data ?? [];
              return ownedChannels.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      S.of(context).yourChannelsLabel,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ownedChannels.length,
                    itemBuilder: (context, index) {
                      final channel = ownedChannels[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(channel['avatar_url'] ?? ''),
                              child: channel['avatar_url'] == null ? const Icon(Icons.group) : null,
                              radius: 25,
                            ),
                            title: Text(
                              channel['name'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditChannelScreen(
                                      channelId: channel['id'],
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  setState(() {});
                                }
                              },
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    channelId: channel['id'],
                                    channelName: channel['name'],
                                  ),
                                ),
                              );

                              if (result == true) {
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          // お気に入りチャンネルリストの表示
          FutureBuilder<List<Map<String, dynamic>>>(
            future: supabaseService.fetchFavoriteChannels(userId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildPlaceholderCard();
              }

              final favoriteChannels = snapshot.data ?? [];
              return favoriteChannels.isEmpty
                  ? Center(child: Text(S.of(context).noFavoriteChannelsMessage))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      S.of(context).favoriteLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: favoriteChannels.length,
                    itemBuilder: (context, index) {
                      final channel = favoriteChannels[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(channel['avatar_url'] ?? ''),
                              child: channel['avatar_url'] == null ? const Icon(Icons.group) : null,
                              radius: 25,
                            ),
                            title: Text(
                              channel['name'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    channelId: channel['id'],
                                    channelName: channel['name'],
                                  ),
                                ),
                              );
                              if (result == true) {
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          // const SizedBox(height: 16),
          //
          // // 投票リストの表示
          // FutureBuilder<List<Map<String, dynamic>>>(
          //   future: supabaseService.fetchPolls(),
          //   builder: (context, pollSnapshot) {
          //     if (!pollSnapshot.hasData) {
          //       return _buildPlaceholderCard();
          //     }
          //
          //     final polls = pollSnapshot.data ?? [];
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //           child: Text(
          //             S.of(context).pollListLabel,
          //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //           ),
          //         ),
          //         // ListView.builder(
          //         //   physics: const NeverScrollableScrollPhysics(),
          //         //   shrinkWrap: true,
          //         //   itemCount: polls.length,
          //         //   itemBuilder: (context, index) {
          //         //     final poll = polls[index];
          //         //     return Padding(
          //         //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          //         //       child: Card(
          //         //         elevation: 1,
          //         //         shape: RoundedRectangleBorder(
          //         //           borderRadius: BorderRadius.circular(16),
          //         //         ),
          //         //         child: ListTile(
          //         //           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //         //           title: Text(
          //         //             poll['title'],
          //         //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //         //           ),
          //         //           subtitle: Text(poll['description'] ?? ''),
          //         //           onTap: () {
          //         //             Navigator.push(
          //         //               context,
          //         //               MaterialPageRoute(
          //         //                 builder: (context) => PollDetailScreen(pollId: poll['id']),
          //         //               ),
          //         //             );
          //         //           },
          //         //         ),
          //         //       ),
          //         //     );
          //         //   },
          //         // ),
          //       ],
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          title: Container(
            height: 18,
            width: 100,
            color: Colors.grey[300],
          ),
          subtitle: Container(
            height: 16,
            width: 60,
            color: Colors.grey[200],
          ),
          trailing: Icon(Icons.edit, color: Colors.grey[400]),
        ),
      ),
    );
  }
}
