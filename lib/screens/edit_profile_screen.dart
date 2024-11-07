import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/generated/l10n.dart';
import 'package:unitter/services/supabase_service.dart';
import 'package:unitter/components/rounded_close_button.dart';
import 'package:unitter/components/custom_text_field.dart';
import 'package:unitter/components/custom_button.dart';
import 'package:unitter/components/custom_snack_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../providers/supabase_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Formのキーを追加
  final _userNameController = TextEditingController();
  final _profileController = TextEditingController();
  bool _isUsernameAvailable = true; // ユーザー名の利用可能状態を追跡
  // String? _usernameError;

  bool _isLoading = true; // 追加: データ取得中のローディング状態を管理
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  String userId = '';

  @override
  void initState() {
    super.initState();

    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
    userId = supabaseService.client.auth.currentUser!.id;
    _fetchProfileData();
  }

  @override
  void dispose() {
    // TextEditingControllerのリソースを解放
    _userNameController.dispose();
    _profileController.dispose();


    super.dispose();
  }

  // Supabaseからプロファイルデータを取得し、TextEditingControllerに設定する
  void _fetchProfileData() async {
    try {
      final data = await supabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      _userNameController.text = data['username'] ?? '';
      _profileController.text = data['bio'] ?? '';
    } catch (e) {
      if (mounted) CustomSnackBar.show(ScaffoldMessenger.of(context), S.of(context).error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      final updates = {
        'username': _userNameController.text,
        'bio': _profileController.text,
      };

      await supabaseService.client
          .from('profiles')
          .update(updates)
          .eq('id', userId);

      await supabaseService.setUserToProvider(userId, ref);

      if (mounted) CustomSnackBar.show(ScaffoldMessenger.of(context), S.of(context).successChangeProfile);
    } catch (e) {
      if (mounted) CustomSnackBar.show(ScaffoldMessenger.of(context), S.of(context).error);
    }
  }

  void _checkUsernameAvailability() async {
    final username = _userNameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).fieldRequired;
      });
      return;
    }

    if (username.length < 2) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).usernameTooShort;
      });
      return;
    }

    // 2文字以上の場合のみリモートチェックを行う
    try {
        final isAvailable = await supabaseService.client.rpc(
            'check_username_availability',
            params: {'target_username': username, 'exclude_user_id': userId}
        );

        setState(() {
          _isUsernameAvailable = isAvailable;
          // _usernameError = isAvailable ? null : S.of(context).usernameAlreadyTaken;
        });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).error;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
      ),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Form(
                    // Formウィジェットを追加
                    key: _formKey, // キーを割り当て
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            PhosphorIcons.identificationCard(),
                            size:
                                70.0, // Set the size of the icon to 50 logical pixels
                                // Pencil Icon
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: S.of(context).username,
                              suffixIcon: _isUsernameAvailable
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : const Icon(Icons.error, color: Colors.red),
                            ),
                            controller: _userNameController,
                            label: S.of(context).firstName,
                            onChanged: (value) {
                              _checkUsernameAvailability();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              if (value.length < 2) {
                                return S.of(context).usernameTooShort;
                              }
                              if (!_isUsernameAvailable) {
                                return S.of(context).usernameAlreadyTaken;
                              }
                              return null;                            },
                          ),
                          CustomTextField(
                            controller: _profileController,
                            label: S.of(context).bio,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).fieldRequired;
                              }
                              return null;
                            },
                          ),
                          CustomButton(
                            text: S.of(context).update,
                            onPressed: () {
                              // ボタンが押された時の処理
                              _submitForm();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // フォームのバリデーションを実行
      _updateProfile();
    }
  }

  // String? _usernameValidator(String? value) {
  //   print('_usernameValidator');
  //   if (value == null || value.isEmpty) return S.of(context).fieldRequired;
  //   if (value.length < 2) return S.of(context).usernameTooShort;
  //   if (!_isUsernameAvailable) return S.of(context).usernameAlreadyTaken;
  //   print(999999988887777);
  //   return null;
  // }
}
