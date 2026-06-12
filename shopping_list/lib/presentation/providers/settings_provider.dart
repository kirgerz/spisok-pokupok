import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';
import '../../core/di/providers.dart';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.load();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveTheme(mode);
    state = AsyncData(state.requireValue.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveLocale(locale);
    state = AsyncData(state.requireValue.copyWith(locale: locale));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
