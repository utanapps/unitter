import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supabase_provider.dart';
import '../services/supabase_service.dart';
import 'private_chat_screen.dart';
import '../generated/l10n.dart';

class FriendProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final String username;
  final String avatarUrl;

  FriendProfileScreen({
    required this.userId,
    required this.username,
    required this.avatarUrl,
  });

  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends ConsumerState<FriendProfileScreen> {
  String? _bio;
  bool _isLoading = true;
  String? _friendStatus;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _fetchFriendProfile();
  }

  Future<void> _fetchFriendProfile() async {
    final supabaseService = ref.read(supabaseServiceProvider);

    try {
      final profile = await supabaseService.getUserProfile(widget.userId);
      setState(() {
        _bio = profile['bio'];
        _isLoading = false;
      });

      _checkFriendRequestStatus(supabaseService);
      _checkFollowStatus(supabaseService);
    } catch (e) {
      print(S.of(context).profileFetchError + ': $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkFriendRequestStatus(SupabaseService supabaseService) async {
    final currentUserId = supabaseService.getCurrentUser()?.id;

    if (currentUserId != null) {
      try {
        final status = await supabaseService.getFriendRequestStatus(currentUserId, widget.userId);
        setState(() {
          _friendStatus = status;
        });
      } catch (e) {
        print(S.of(context).friendRequestStatusError + ': $e');
      }
    }
  }

  Future<void> _checkFollowStatus(SupabaseService supabaseService) async {
    final currentUserId = supabaseService.getCurrentUser()?.id;

    if (currentUserId != null) {
      try {
        final isFollowing = await supabaseService.isFollowing(currentUserId, widget.userId);
        setState(() {
          _isFollowing = isFollowing;
        });
      } catch (e) {
        print(S.of(context).followStatusError + ': $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final currentUserId = supabaseService.getCurrentUser()?.id;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.username} ${S.of(context).profileTitle}'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: widget.avatarUrl.startsWith('http')
                      ? NetworkImage(widget.avatarUrl)
                      : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  radius: 80,
                  backgroundColor: Colors.blueAccent.shade100,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _bio != null && _bio!.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _bio!,
                    textAlign: TextAlign.center,
                  ),
                )
                    : Text(S.of(context).noBioMessage),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!_isFollowing) {
                          try {
                            await supabaseService.followUser(currentUserId!, widget.userId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(S.of(context).followSuccessMessage)),
                            );
                            setState(() {
                              _isFollowing = true;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${S.of(context).errorOccurred}: $e')),
                            );
                          }
                        } else {
                          try {
                            await supabaseService.unfollowUser(currentUserId!, widget.userId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(S.of(context).unfollowSuccessMessage)),
                            );
                            setState(() {
                              _isFollowing = false;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${S.of(context).errorOccurred}: $e')),
                            );
                          }
                        }
                      },
                      child: Text(_isFollowing ? S.of(context).unfollowButton : S.of(context).followButton),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        if (currentUserId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivateChatScreen(
                                currentUserId: currentUserId,
                                friendId: widget.userId,
                                friendUsername: widget.username,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).userFetchErrorMessage)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
