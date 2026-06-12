import 'package:flutter/material.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();
  Future<void> saveTheme(ThemeMode mode);
  Future<void> saveLocale(Locale locale);
}
