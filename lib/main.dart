// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unitter/providers/font_size_provider.dart';
import 'package:unitter/providers/locale_provider.dart';
import 'package:unitter/providers/theme_mode_provider.dart';
import 'package:unitter/services/user_preferences.dart';
import 'package:unitter/utils/constants.dart';
import 'package:unitter/utils/timeago_en_short.dart';
import 'generated/l10n.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {

  await dotenv.load();
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl!,
    anonKey:supabaseAnonKey!,
  );
  await UserPreferences.init(); // SharedPreferencesを初期化
  timeago.setLocaleMessages('en_short', EnShortMessages());
  timeago.setDefaultLocale('en_short');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);//

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Unitter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme( // Remove const here to allow dynamic properties
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSize), // 元のフォントサイズ
          bodyMedium: TextStyle(fontSize: fontSize * 0.9), // 10%小さい
          bodySmall: TextStyle(fontSize: fontSize * 0.7), // 20%小さい
          // その他のTextスタイルも必要に応じて設定可能
        ),
      ).copyWith(
        appBarTheme:  AppBarTheme(
          elevation: 4.0, // Shadow height
          shadowColor: Colors.black.withOpacity(0.5), // Shadow c
          backgroundColor: Colors.white, // AppBarの背景色
          foregroundColor: Colors.black, // AppBarのテキストやアイコンの色
          iconTheme: IconThemeData(color: Colors.black), // AppBarのアイコンの色
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 4.0, // Shadow height
          selectedLabelStyle: TextStyle(fontSize: fontSize), // フォントサイズ適用
          unselectedLabelStyle: TextStyle(fontSize: fontSize), // フォントサイズ適用
          // backgroundColor: Color(0xff3fc060), // BottomNavigationBarの背景色
          selectedItemColor: Colors.black87, // 選択されたアイテムのラベルの色
          unselectedItemColor: Colors.black87, // 非選択アイテムのラベルの色
        ),
        // scaffoldBackgroundColor: Colors.grey[800], // Scaffoldの背景色（ダークテーマ）
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme( // Remove const here to allow dynamic properties
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: fontSize), // 元のフォントサイズ
          bodyMedium: TextStyle(fontSize: fontSize * 0.9), // 10%小さい
          bodySmall: TextStyle(fontSize: fontSize * 0.7), // 20%小さい
          // その他のTextスタイルも必要に応じて設定可能
        ),
      ).copyWith(
        appBarTheme:  AppBarTheme(

          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, // AppBarの背景色
          foregroundColor: Colors.black54, // AppBarのテキストやアイコンの色
          iconTheme: IconThemeData(color: Colors.white), // AppBarのアイコンの色
        ),
        bottomNavigationBarTheme:  BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(fontSize: fontSize), // フォントサイズ適用
          unselectedLabelStyle: TextStyle(fontSize: fontSize), // フォントサイズ適用
          // backgroundColor: Color(0xff3fc060), // BottomNavigationBarの背景色
          selectedItemColor: Colors.black87, // 選択されたアイテムのラベルの色
          unselectedItemColor: Colors.black87, // 非選択アイテムのラベルの色
        ),
      ),
      themeMode: themeMode,
      home: supabase.auth.currentUser == null
          ? const SigninScreen()
          : HomeScreen(),
    );
  }
}
