import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/providers/locale_provider.dart'; // 正しいパスに修正してください
import 'package:unitter/services/user_preferences.dart';


class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final locale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Rowのサイズを子ウィジェットに合わせる
          children: <Widget>[
            Icon(Icons.language,color: Theme.of(context).colorScheme.onSurface,), // 言語アイコン
          ],
        ),
      ),
      onSelected: (Locale newLocale) async {
        await UserPreferences.setLocale(newLocale.languageCode);
        ref.read(localeProvider.notifier).state = newLocale;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en', ''),
          child: Text('English'),
          // child: Text('English', style: TextStyle(fontSize: baseFontSize)),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ja', ''),
          child: Text('日本語'),
          // child: Text('日本語', style: TextStyle(fontSize: baseFontSize)),

        ),
      ],
    );
  }
}

