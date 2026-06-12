import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Настройки хранятся в Hive (box с примитивами, без адаптера).
class HiveSettingsDataSource implements SettingsRepository {
  static const _boxName = 'settings';
  static const _keyTheme = 'theme_mode';
  static const _keyLocale = 'locale';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  @override
  Future<AppSettings> load() async {
    final themeIndex = _box.get(_keyTheme, defaultValue: ThemeMode.system.index) as int;
    final localeTag = _box.get(_keyLocale, defaultValue: 'ru') as String;
    return AppSettings(
      themeMode: ThemeMode.values[themeIndex],
      locale: Locale(localeTag),
    );
  }

  @override
  Future<void> saveTheme(ThemeMode mode) async {
    await _box.put(_keyTheme, mode.index);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _box.put(_keyLocale, locale.languageCode);
  }
}
