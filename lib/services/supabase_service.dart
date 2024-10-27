import 'package:supabase_flutter/supabase_flutter.dart';

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

}