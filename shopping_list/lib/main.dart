import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/providers.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/hive_settings_datasource.dart';
import 'data/datasources/hive_shopping_datasource.dart';
import 'data/models/shopping_item_model.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/shopping_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ShoppingItemModelAdapter());

  final shoppingDs = HiveShoppingDataSource();
  await shoppingDs.init();

  final settingsDs = HiveSettingsDataSource();
  await settingsDs.init();

  runApp(
    ProviderScope(
      overrides: [
        hiveShoppingDsProvider.overrideWithValue(shoppingDs),
        hiveSettingsDsProvider.overrideWithValue(settingsDs),
      ],
      child: const ShoppingApp(),
    ),
  );
}

class ShoppingApp extends ConsumerWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, _) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Init error: $e'))),
      ),
      data: (settings) => MaterialApp(
        title: 'Shopping List',
        debugShowCheckedModeBanner: false,
        themeMode: settings.themeMode,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        // FIX: убран const — AppLocalizations.delegate не является const-значением
        localizationsDelegates: [
          ...AppLocalizations.delegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const ShoppingListScreen(),
      ),
    );
  }
}
