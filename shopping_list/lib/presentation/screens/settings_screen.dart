import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/core/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (settings) {
          final notifier = ref.read(settingsProvider.notifier);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Тема
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette_outlined,
                              color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(loc.themeLabel,
                              style: theme.textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: const Icon(Icons.light_mode_outlined),
                            label: Text(loc.themeLight),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon:
                                const Icon(Icons.brightness_auto_outlined),
                            label: Text(loc.themeSystem),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: const Icon(Icons.dark_mode_outlined),
                            label: Text(loc.themeDark),
                          ),
                        ],
                        selected: {settings.themeMode},
                        onSelectionChanged: (s) =>
                            notifier.setTheme(s.first),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // ── Язык
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.language_outlined,
                              color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(loc.languageLabel,
                              style: theme.textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<String>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: 'ru',
                            label: Text(loc.langRu),
                          ),
                          ButtonSegment(
                            value: 'en',
                            label: Text(loc.langEn),
                          ),
                        ],
                        selected: {settings.locale.languageCode},
                        onSelectionChanged: (s) =>
                            notifier.setLocale(Locale(s.first)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: colorScheme.surfaceContainerLow,
                child: ListTile(
                  leading: Icon(Icons.info_outline,
                      color: colorScheme.onSurfaceVariant),
                  title: Text(loc.appTitle,
                      style: theme.textTheme.bodyMedium),
                  subtitle: const Text(
                      'v1.0.0 • Material 3 + Riverpod + Hive'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
