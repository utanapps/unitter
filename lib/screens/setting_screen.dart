import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/generated/l10n.dart';
import 'package:unitter/providers/supabase_provider.dart'; // 必要に応じて修正してください
import 'package:unitter/providers/theme_mode_provider.dart';
import 'package:unitter/components/language_selection_dialog.dart';
import 'package:unitter/screens/password_reset_screen.dart';
import 'package:unitter/screens/signin_screen.dart';

import '../providers/font_size_provider.dart';
import '../services/supabase_service.dart';
import 'package:unitter/screens/edit_profile_screen.dart';

import 'edit_email_screen.dart';
// import 'package:unitter/pages/password_reset_page.dart';
// import 'package:unitter/pages/change_email_page.dart';
// import 'package:unitter/pages/delete_user.dart';

// import '../providers/font_size_provider.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends ConsumerState<SettingScreen> {
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数

  @override
  void initState() {
    super.initState();
    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider); // フォントサイズを取得

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ListView(

        children: [
          SwitchListTile(
            title: Text(S.of(context).darkMode),
            value: themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              ref.read(themeModeProvider.notifier).setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            subtitle: Text(S.of(context).darkModeDescription),
            secondary: Icon(themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
          ),
          ListTile(
            title: Text(S.of(context).languageMode),
            subtitle: Text(S.of(context).languageDescription),
            leading: const Icon(Icons.language),
            onTap: () => showLanguageSelectionDialog(context, ref),
          ),
          ListTile(
            title: Text(S.of(context).fontSize),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: fontSize,
                  min: 12.0,
                  max: 40.0, // 最大値を50に変更
                  divisions: 30, // 12から50までの間に38個の目盛りを表示
                  label: fontSize.toStringAsFixed(0), // 小数点なしで表示
                  onChanged: (double value) {
                    ref.read(fontSizeProvider.notifier).setFontSize(value);
                  },
                ),
                // スライダー下部に目盛りを表示
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6, // 表示する数値の個数
                          (index) => Text(
                        (12 + index * 6).toString(), // 12, 18, 24, 30, 36, 42, 48の数値を表示
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            leading: const Icon(Icons.text_fields),
          ),
          ListTile(
            title: Text(S.of(context).profile),
            subtitle: Text(S.of(context).profileDescription),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(), // ChatPageはチャット画面のクラス
                ),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).password),
            subtitle: Text(S.of(context).passwordChange),
            leading: const Icon(Icons.security),
            onTap: () {
              // Navigator.of(context).pop(); // ドロワーを閉じる
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PasswordResetScreen()),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).email),
            subtitle: Text(S.of(context).emailChange),
            leading: const Icon(Icons.email),
            onTap: () {
              // Navigator.of(context).pop(); // ドロワーを閉じる
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EditEmailScreen()),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).logout),
            subtitle: Text(S.of(context).logoutDescription),
            leading: const Icon(Icons.logout),
            onTap: () async{
              // 非同期処理を実行
              await supabaseService.logout();
              if(mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                      (_) => false,
                );
              }
              // ここでmountedをチェックすることもできますが、ConsumerWidgetでは直接使用できないため、
              // 取得したnavigatorを使って画面遷移を行います。
              if (mounted) { // 画面遷移が可能かどうかを確認
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninScreen()),
                      (_) => false,
                );              }
            },
          ),
        ],
      ),
    );
  }
}