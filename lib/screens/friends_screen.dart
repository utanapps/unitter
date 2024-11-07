import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/supabase_service.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import 'friend_profile_screen.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  List<Map<String, dynamic>> _followers = [];
  List<Map<String, dynamic>> _allUsers = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _allUsersSearchController = TextEditingController();

  Future<void> _fetchFollowers(SupabaseService supabaseService, String userId) async {
    try {
      final followers = await supabaseService.getFollowers(userId);
      setState(() {
        _followers = followers;
      });
    } catch (e) {
      print('Error fetching followers: $e');
    }
  }

  Future<void> _searchAllUsers(SupabaseService supabaseService, String userId, String query) async {
    try {
      final results = await supabaseService.searchUsers(query, userId);
      setState(() {
        _allUsers = results;
      });
    } catch (e) {
      print('Error fetching all users: $e');
    }
  }

  bool _isFollowing(String userId) {
    return _followers.any((follower) =>
    follower['profiles']['id'] == userId || follower['follow_user_id'] == userId);
  }

  @override
  void initState() {
    super.initState();
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      _fetchFollowers(supabaseService, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // タイトルなしでTabBarを直接配置
            TabBar(
              tabs: [
                Tab(text: S.of(context).followingUsers),
                Tab(text: S.of(context).allUsers),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUserListTab(
                    context,
                    "following",
                    _followers,
                    _searchController,
                        (query) {
                      if (userId != null) {
                        _fetchFollowers(supabaseService, userId);
                      }
                    },
                    supabaseService,
                    userId,
                  ),
                  _buildUserListTab(
                    context,
                    "all",
                    _allUsers,
                    _allUsersSearchController,
                        (query) {
                      if (userId != null) {
                        _searchAllUsers(supabaseService, userId, query);
                      }
                    },
                    supabaseService,
                    userId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserListTab(
      BuildContext context,
      String type,
      List<Map<String, dynamic>> userList,
      TextEditingController controller,
      Function(String) onSearch,
      SupabaseService supabaseService,
      String? currentUserId,
      ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: S.of(context).findUsers,
              border: OutlineInputBorder(),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  onSearch(controller.text.trim());
                },
              ),
            ),
            onChanged: onSearch,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final userProfile = type == "following"
                  ? userList[index]['profiles'] ?? {}
                  : userList[index];

              final username = userProfile['username'] ?? 'Unknown';
              final avatarUrl = userProfile['avatar_url'] ?? '';
              final userId = userProfile['id'] ?? '';

              if (userProfile.isEmpty || userId.isEmpty) {
                return SizedBox.shrink();
              }

              return _buildUserCard(
                context,
                userId,
                username,
                avatarUrl,
                currentUserId,
                supabaseService,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(
      BuildContext context,
      String userId,
      String username,
      String avatarUrl,
      String? currentUserId,
      SupabaseService supabaseService,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5), // カードのパディングを設定
      child: Card(
        elevation: 1, // カードの影の強さを設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // カードの角を丸くする
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 内側の余白を調整
          leading: CircleAvatar(
            backgroundImage: avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : AssetImage('assets/images/default_avatar.png') as ImageProvider,
            child: avatarUrl.isEmpty ? Icon(Icons.person) : null,
            radius: 25, // アイコンのサイズを`ChannelSearchScreen`に合わせる
          ),
          title: Text(
            username,
            style: TextStyle(
              fontSize: 18, // チャンネルリストと統一感を持たせるフォントサイズに調整
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isFollowing(userId) ? Icons.favorite : Icons.favorite_border,
              color: _isFollowing(userId) ? Colors.red : null,
            ),
            onPressed: () async {
              try {
                if (_isFollowing(userId)) {
                  await supabaseService.unfollowUser(currentUserId!, userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).unfollowed)),
                  );
                } else {
                  await supabaseService.followUser(currentUserId!, userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).followed)),
                  );
                }
                // リストの再取得
                _fetchFollowers(supabaseService, currentUserId!);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendProfileScreen(
                  userId: userId,
                  username: username,
                  avatarUrl: avatarUrl,
                ),
              ),
            );

            // 戻った後にresultがtrueの場合にリロード
            if (result == true) {
              final supabaseService = ref.read(supabaseServiceProvider);
              _fetchFollowers(supabaseService, currentUserId!); // フォロワーリストを再取得
            }
          },
        ),
      ),
    );
  }
}
