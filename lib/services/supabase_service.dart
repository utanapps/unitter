import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:unitter/utils/utils.dart';
import '../models/app_user.dart';

final appUserProvider = StateProvider<AppUser?>((ref) => null);

class SupabaseService {
  SupabaseService._internal();

  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  final SupabaseClient client = Supabase.instance.client;

  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      // エラーハンドリング
      throw AuthException(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Future<String> fetchLatestVersion() async {
    try {
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', 'latest_version')
          .single();
      return response['value'];
    } catch (e) {
      throw Exception('Failed to fetch latest version');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response =
          await client.from('profiles').select().eq('id', userId).single();
      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<void> setUserToProvider(String userId, WidgetRef ref) async {
    try {
      final userProfile = await getUserProfile(userId);
      final appUser = AppUser.fromJson(userProfile);
      ref.read(appUserProvider.notifier).state = appUser;
    } catch (e) {
      throw Exception('Failed to set user profile to provider');
    }
  }

  Future<void> deleteImage({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await client.storage.from(bucketName).remove([filePath]);
      print('画像削除成功: $filePath');
    } catch (e) {
      print('画像削除エラー: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> fetchChatMessagesStream(
      String channelId, SupabaseService supabaseService) {
    return supabaseService.client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('channel_id', channelId)
        .order('created_at', ascending: false)
        .limit(5)
        .map((response) => response as List<Map<String, dynamic>>);
  }

  Future<List<Map<String, dynamic>>> fetchChatMessages(
    String channelId,
    int limit,
    int offset,
  ) async {
    final response = await client
        .from('chat_messages')
        .select()
        .eq('channel_id', channelId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String?> uploadImage({
    required String bucketName,
    required String userId,
    required Uint8List imageData,
    required String fileName,
  }) async {
    try {
      String filePath = '$userId/$fileName';

      await client.storage.from(bucketName).uploadBinary(filePath, imageData);

      final imageUrl = client.storage.from(bucketName).getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      print('画像アップロードエラー: $e');
      return null;
    }
  }

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    try {
      // 既にフレンドリクエストが送信されているかを確認
      final existingRequest = await client
          .from('friend_requests')
          .select()
          .or('sender_id.eq.$senderId,receiver_id.eq.$senderId') // 自分が送信者
          .eq('receiver_id', receiverId) // 受信者が相手
          .maybeSingle();

      if (existingRequest != null) {
        print('すでにフレンドリクエストが送信されています');
        return; // 既にリクエストが存在する場合は何もしない
      }

      // ストアドプロシージャを呼び出してフレンドリクエストを作成し、通知を送信
      await client.rpc('send_friend_request', params: {
        '_var_sender_id': senderId,
        '_var_receiver_id': receiverId,
      });

      print('フレンドリクエストが送信されました');
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('フレンドリクエスト送信中にエラーが発生しました');
    }
  }

  Future<String> getFriendRequestStatus(
      String currentUserId, String targetUserId) async {
    try {
      final response = await client.rpc('get_friend_request_status', params: {
        'current_user_id': currentUserId, // 引数名を変更
        'target_user_id': targetUserId, // 引数名を変更
      });
      print(8838383);
      print(response);

      return response ?? 'none'; // ステータスを返す
    } catch (e) {
      print('フレンドステータス取得エラー: $e');
      return 'none';
    }
  }

  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    try {
      final response = await client
          .from('friends')
          .select(
              'friend_id, profiles!friends_friend_id_fkey(username, avatar_url)')
          .eq('user_id', userId); // 自分がuser_idのレコードを取得

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      print('フレンド一覧取得エラー: $e');
      throw Exception('フレンド一覧取得エラー');
    }
  }


  // ユーザーのオンライン状態を設定するメソッド
  Future<void> setUserOnlineStatus(bool isOnline) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    if (!isOnline) {
      // オフライン時に位置情報を削除
      await client.from('user_locations').delete().eq('id', userId);
    } else {
      // オンライン時にステータスを更新
      await client.from('user_locations').upsert({
        'id': userId,
        'is_online': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ユーザーの位置情報を更新するメソッド
  Future<void> updateUserLocation(double latitude, double longitude) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    final updates = {
      'id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
      'is_online': true,
    };

    await client.from('user_locations').upsert(updates);
  }

  Stream<List<Map<String, dynamic>>> subscribeToUserLocations() {
    return client
        .from('user_locations')
        .stream(primaryKey: ['id']).eq('is_online', true);
  }

  Future<void> createProduct(
    String userId,
    String name,
    String description,
    double price,
    String category,
    List<String> imageUrls, // 修正: String から List<String> に変更
  ) async {
    try {
      // 商品情報を 'marketplace_posts' テーブルに挿入し、生成された productId を取得
      final response = await client
          .from('marketplace_posts')
          .insert({
            'user_id': userId,
            'title': name,
            'description': description,
            'price': price,
            'category': category,
            'status': 'available',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      final productId = response['id'] as String;

      // 各画像URLを 'product_images' テーブルに挿入
      for (String imageUrl in imageUrls) {
        await client.from('product_images').insert({
          'product_id': productId,
          'image_url': imageUrl,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('商品作成エラー: $e');
      throw Exception('商品作成に失敗しました');
    }
  }

  Future<void> updateMarketplacePost({
    required String postId,
    required String title,
    required String description,
    required String price,
    String? category, // 既存のカテゴリ引数
    String? status, // 新しく追加するステータス引数
    List<String>? imageUrls,
  }) async {
    try {
      final updates = {
        'title': title,
        'description': description,
        'price': price,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // categoryが指定されている場合に追加
      if (category != null) {
        updates['category'] = category;
      }

      // statusが指定されている場合に追加
      if (status != null) {
        updates['status'] = status;
      }

      final response = await client
          .from('marketplace_posts')
          .update(updates)
          .eq('id', postId)
          .select('id')
          .single();

      final productId = response['id'] as String;

      if (imageUrls != null && imageUrls.isNotEmpty) {
        // 古い画像を削除
        await client
            .from('product_images')
            .delete()
            .eq('product_id', productId);

        // 新しい画像を挿入
        for (String imageUrl in imageUrls) {
          await client.from('product_images').insert({
            'product_id': productId,
            'image_url': imageUrl,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      print('更新エラー: $e');
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> getNotifications(String userId,
      {required bool isRead, int page = 1, int pageSize = 20}) async {
    try {
      final offset = (page - 1) * pageSize;
      final response = await client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('status', isRead ? 'read' : 'unread')
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1); // ページネーションのための範囲指定

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      print('通知取得エラー: $e');
      throw Exception('通知取得エラー');
    }
  }

  // 通知を既読にする
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await client
          .from('notifications')
          .update({'status': 'read'}).eq('id', notificationId);
    } catch (e) {
      print('通知更新エラー: $e');
      throw Exception('通知更新エラー');
    }
  }

  Future<void> acceptFriendRequest(String senderId, String receiverId) async {
    try {
      // ストアドプロシージャを呼び出す
      await client.rpc('accept_friend_request', params: {
        '_var_sender_id': senderId, // ストアドプロシージャの引数名に合わせる
        '_var_receiver_id': receiverId, // ストアドプロシージャの引数名に合わせる
      });

      print('フレンドリクエストが承認されました');
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('フレンドリクエスト承認中にエラーが発生しました');
    }
  }

  // Future<List<Map<String, dynamic>>> getNotifications(String userId,
  //     {required bool isRead, int page = 1, int pageSize = 20}) async {
  //   try {
  //     final offset = (page - 1) * pageSize;
  //     final response = await client
  //         .from('notifications')
  //         .select()
  //         .eq('user_id', userId)
  //         .eq('status', isRead ? 'read' : 'unread')
  //         .order('created_at', ascending: false)
  //         .range(offset, offset + pageSize - 1); // ページネーションのための範囲指定
  //
  //     return response as List<Map<String, dynamic>>;
  //   } catch (e) {
  //     print('通知取得エラー: $e');
  //     throw Exception('通知取得エラー');
  //   }
  // }

  Stream<List<Map<String, dynamic>>> getPrivateMessagesStream(
      String currentUserId, String friendId) {
    return client
        .rpc('get_private_messages', params: {
          'user1': currentUserId,
          'user2': friendId,
        })
        .asStream()
        .map((response) {
          return (response as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        });
  }

  // Stream<List<Map<String, dynamic>>> getPrivateMessagesStream(
  //     String currentUserId, String friendId) {
  //   return client
  //       .rpc('get_private_messages', params: {
  //     'user1': currentUserId,
  //     'user2': friendId,
  //   })
  //       .asStream()
  //       .map((response) {
  //     return (response as List)
  //         .map((e) => e as Map<String, dynamic>)
  //         .toList();
  //   });
  // }

  Future<void> sendPrivateMessage({
    required String senderId,
    required String receiverId,
    required String roomId, // 追加
    required String messageText,
    String? imageUrl,
  }) async {
    try {
      await client.from('private_messages').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'room_id': roomId, // 追加
        'message_text': messageText,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('sendPrivateMessage エラー: $e');
      throw Exception('メッセージ送信に失敗しました');
    }
  }

  Future<bool> isFollowing(String userId, String followUserId) async {
    final response = await client
        .from('follows')
        .select()
        .eq('user_id', userId)
        .eq('follow_user_id', followUserId)
        .maybeSingle();

    return response != null;
  }

  // フォローするメソッド
  Future<void> followUser(String userId, String followUserId) async {
    await client.from('follows').insert({
      'user_id': userId,
      'follow_user_id': followUserId,
    });
  }

  // フォローを解除するメソッド
  Future<void> unfollowUser(String userId, String followUserId) async {
    await client
        .from('follows')
        .delete()
        .eq('user_id', userId)
        .eq('follow_user_id', followUserId);
  }

  // Fetch followers method
  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    try {
      final response = await client
          .from('follows')
          .select(
              'follow_user_id, profiles!follows_follow_user_id_fkey(id, username, avatar_url)')
          .eq('user_id', userId);
      print(userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch followers: $e');
    }
  }

  // User search method example
  Future<List<Map<String, dynamic>>> searchUsers(
      String query, String currentUserId) async {
    try {
      final response = await client
          .from('profiles')
          .select('id, username, avatar_url')
          .like('username', '%$query%')
          .neq('id', currentUserId);
      print(response);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  Future<String> getOrCreateRoomId(String senderId, String receiverId) async {
    // まず、既存のチャットルームを探します
    final existingRoom = await client
        .from('chat_rooms')
        .select('id')
        .or('and(user1_id.eq.$senderId,user2_id.eq.$receiverId),and(user1_id.eq.$receiverId,user2_id.eq.$senderId)')
        .maybeSingle();

    if (existingRoom != null) {
      // すでに存在する場合は、そのルームIDを返す
      return existingRoom['id'];
    } else {
      // 存在しない場合は、新しいroom_idを生成
      final newRoomId = Utils.generateRoomId(senderId, receiverId);

      // 新しいチャットルームをデータベースに挿入
      await client.from('chat_rooms').insert({
        'id': newRoomId,
        'user1_id': senderId,
        'user2_id': receiverId,
        'created_at': DateTime.now().toIso8601String(),
      });

      return newRoomId;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPrivateChatMessages(
    String roomId,
    int limit,
    int offset,
  ) async {
    final response = await client
        .from('private_messages')
        .select()
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  Stream<List<Map<String, dynamic>>>? streamPrivateChatMessages(
      String roomId, int limit, int offset) {
    try {
      print(1);
      return client
          .from('private_messages')
          .stream(primaryKey: ['id'])
          .order('created_at')
          .map((maps) => List<Map<String, dynamic>>.from(maps));
    } catch (e) {
      print(e);
      return null; // エラー時にはnullを返す
    }
  }

  Stream<List<Map<String, dynamic>>>? streamMessages(String roomId) {
    try {
      print(1);
      return client
          .from('private_messages')
          .stream(primaryKey: ['id'])
          .order('created_at')
          .map((maps) => List<Map<String, dynamic>>.from(maps));
    } catch (e) {
      print(e);
      return null; // エラー時にはnullを返す
    }
  }

  Stream<List<Map<String, dynamic>>> fetchPrivateChatMessagesStream(
      String roomId) {
    return client
        .from('private_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .map((maps) => List<Map<String, dynamic>>.from(maps));
  }

  Future<void> addFavorite(String channelId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await client.from('user_channels').insert({
        'user_id': userId,
        'channel_id': channelId,
        'favorited_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // チャンネルのお気に入りを解除するメソッド
  Future<void> removeFavorite(String channelId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await client.from('user_channels').delete().match({
        'user_id': userId,
        'channel_id': channelId,
      });
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  Future<void> postChatMessage({
    required String channelId,
    required String userId,
    required String messageText,
    String? imageUrl,
  }) async {
    try {
      // ユーザープロファイルを取得して、ユーザー名とアバターURLを取得
      final profile = await getUserProfile(userId);
      final username = profile['username'];
      final avatarUrl = profile['avatar_url'];

      // メッセージのデータをチャットテーブルに挿入
      await client.from('chat_messages').insert({
        'channel_id': channelId,
        'sender_id': userId,
        'message_text': messageText,
        'image_url': imageUrl,
        'username': username,
        'avatar_url': avatarUrl,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('メッセージ送信エラー: $e');
    }
  }


  // チャンネルメッセージのリアルタイムStream (2)
  Stream<List<Map<String, dynamic>>> fetchChatMessagesStream2(
      String channelId, int limit) {
    return client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('channel_id', channelId)
        .order('created_at', ascending: false)
        .limit(limit)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // チャンネルメッセージのリアルタイムStream (2)
  Stream<List<Map<String, dynamic>>> fetchPrivateChatMessagesStream2(
      String roomId, String userId, int limit) {
    return client
        .from('private_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .limit(limit)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  //
  // // 過去のメッセージを取得するメソッド
  Future<List<Map<String, dynamic>>> fetchOlderMessages(
      String channelId, DateTime lastMessageTime, int limit) async {
    final response = await client
        .from('chat_messages')
        .select()
        .eq('channel_id', channelId)
        .lt('created_at', lastMessageTime.toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchOlderMessages2(
      String roomId, String userId, DateTime lastMessageTime, int limit) async {
    final response = await client
        .from('private_messages')
        .select()
        .lt('created_at', lastMessageTime.toIso8601String())
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> isChannelFavorited(String userId, String channelId) async {
    try {
      print("userId:${userId}");
      print(channelId);

      final data = await client
          .from('user_channels')
          .select('user_id')
          .eq('user_id', userId)
          .eq('channel_id', channelId);
      print(data);

      return data != null && data.isNotEmpty;
    } catch (e) {
      print("xxxxx");
      print(userId);
      print(channelId);
      print(e);
      print('お気に入り状態の取得エラー: $e');
      return false;
    }
  }

  //
  // // お気に入り状態を切り替え
  Future<void> toggleChannelFavorite(
      String userId, String channelId, bool isFavorited) async {
    try {
      if (isFavorited) {
        // お気に入りを解除する
        await client
            .from('user_channels')
            .delete()
            .eq('user_id', userId)
            .eq('channel_id', channelId);
      } else {
        // お気に入りにする
        await client.from('user_channels').insert({
          'user_id': userId,
          'channel_id': channelId,
          'favorited_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('お気に入り状態の更新エラー: $e');
    }
  }

  // プロフィール情報を取得
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select('username, karma, avatar_url')
          .eq('id', userId)
          .single();
      return response;
    } catch (error) {
      print("Error fetching user profile: $error");
      return {};
    }
  }

  // お気に入りチャンネルを取得
  Future<List<Map<String, dynamic>>> fetchFavoriteChannels(
      String userId) async {
    try {
      final response = await client
          .rpc('get_user_favorite_channels', params: {'input_user_id': userId});
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Error fetching favorite channels: $error");
      return [];
    }
  }

  // 自分がオーナーのチャンネルを取得
  Future<List<Map<String, dynamic>>> fetchOwnedChannels(String userId) async {
    try {
      final response = await client
          .from('channels')
          .select('id, name, avatar_url')
          .eq('owner_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Error fetching owned channels: $error");
      return [];
    }
  }

  Future<UserResponse> updateUserEmail({newEmail, String? languageCode}) async {
    try {
      final data = {
        'locale': languageCode,
      };

      final UserResponse res = await client.auth.updateUser(
        UserAttributes(email: newEmail // 引数から取得した新しいメールアドレスを使用
            ),
      );

      return res; // UserResponse型のresを返す
    } catch (e) {
      throw Exception('Failed to update user email: $e');
    }
  }

  Future<void> sendOtpToEmail(String email) async {
    try {
      // Supabaseの認証機能を使用して、パスワードリセットとしてOTPをメールに送信
      await client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception('Failed to send OTP: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// OTPを検証し、成功したらメールアドレスを変更する
  Future<void> verifyOtpAndChangeEmail({
    required String email,
    required String token,
  }) async {
    print(token);
    print(email);
    try {
      await client.auth
          .verifyOTP(type: OtpType.emailChange, email: email, token: token);

      await client.auth.updateUser(
        UserAttributes(email: email),
      );
    } on AuthException catch (e) {
      throw Exception('Failed to verify OTP and change email: ${e}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPolls() async {
    try {
      final response = await client
          .from('polls')
          .select('*')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response ?? []);
    } on AuthException catch (e) {
      throw Exception('Failed to fetchPolls : ${e}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMarketplacePosts({
    String? category,
    String? status,
  }) async {
    try {
      // 'marketplace_posts'テーブルのデータと関連する'marketplace_post_images'テーブルの画像を取得
      var query = client
          .from('marketplace_posts')
          .select('*, marketplace_post_images(image_url)');

      // カテゴリーでフィルタリング
      if (category != null) {
        query = query.eq('category', category);
      }

      // ステータスでフィルタリング
      if (status != null) {
        query = query.eq('status', status);
      }

      // データの取得
      final List<dynamic> response = await query;

      // レスポンスを期待される形式に変換して返す
      return response.map((e) => e as Map<String, dynamic>).toList();
    } catch (error) {
      throw Exception('Marketplace投稿のデータ取得に失敗しました');
    }
  }


  Future<Map<String, dynamic>?> getMarketplacePostDetail(String postId) async {
    try {
      // クエリの構築
      var query = client
          .from('marketplace_posts')
          .select('*, marketplace_post_images(image_url)')
          .eq('id', postId)
          .single(); // 詳細ページのため単一レコードを取得

      // デバッグ表示：クエリ内容

      // データの取得
      final response = await query;

      // データをMapとして返す
      return response as Map<String, dynamic>;
    } catch (error) {
      print("デバッグ: 詳細データ取得エラー - $error");
      return null; // エラー時にnullを返す
    }
  }

  Future<void> deleteImageFromPost(String postId, String imageUrl) async {
    try {
      // marketplace_post_imagesテーブルから該当する画像を削除
      final response = await client
          .from('marketplace_post_images')
          .delete()
          .eq('post_id', postId)
          .eq('image_url', imageUrl);

      print('画像が正常に削除されました');
    } catch (error) {
      print('デバッグ: 画像削除中にエラーが発生しました - $error');
      throw Exception('画像削除に失敗しました');
    }
  }

  Future<List<String>> fetchMarketplaceCategories() async {
    try {
      final response = await client
          .from('marketplace_categories')
          .select('name')
          .order('sort_order', ascending: true);

      // エラーがない場合、カテゴリ名リストを返す
      return List<String>.from(response.map((category) => category['name'] as String));
    } catch (error) {
      print('カテゴリ取得エラー: $error');
      return [];
    }
  }

}
