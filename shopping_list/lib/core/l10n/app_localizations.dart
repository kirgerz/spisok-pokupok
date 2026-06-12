import 'package:flutter/material.dart';

/// Ручная локализация — без кодогенерации, без flutter_gen.
/// Добавить новый язык: создать класс _AppLocalizationsXX и добавить в _delegates.
abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    _AppLocalizationsDelegate(),
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ru'),
    Locale('en'),
  ];

  String get appTitle;
  String get settingsTitle;
  String get addItem;
  String get itemNameHint;
  String get itemNameError;
  String get quantity;
  String get deleteItem;
  String get emptyList;
  String get themeLabel;
  String get themeLight;
  String get themeDark;
  String get themeSystem;
  String get languageLabel;
  String get langEn;
  String get langRu;
  String get cancel;
  String get add;
  String get editItem;
  String get save;
  String get delete;
  String get boughtSection;
  String get toBuySection;
  String get clearBought;
  String deleteConfirm(String name);
}

// ── Русский ──────────────────────────────────────────────
class _AppLocalizationsRu extends AppLocalizations {
  @override String get appTitle       => 'Список покупок';
  @override String get settingsTitle  => 'Настройки';
  @override String get addItem        => 'Добавить товар';
  @override String get itemNameHint   => 'Название товара';
  @override String get itemNameError  => 'Введите название';
  @override String get quantity       => 'Кол-во';
  @override String get deleteItem     => 'Удалить';
  @override String get emptyList      => 'Список пуст.\nНажмите + чтобы добавить товары.';
  @override String get themeLabel     => 'Тема';
  @override String get themeLight     => 'Светлая';
  @override String get themeDark      => 'Тёмная';
  @override String get themeSystem    => 'Системная';
  @override String get languageLabel  => 'Язык';
  @override String get langEn         => 'English';
  @override String get langRu         => 'Русский';
  @override String get cancel         => 'Отмена';
  @override String get add            => 'Добавить';
  @override String get editItem       => 'Редактировать';
  @override String get save           => 'Сохранить';
  @override String get delete         => 'Удалить';
  @override String get boughtSection  => 'Куплено';
  @override String get toBuySection   => 'Купить';
  @override String get clearBought    => 'Очистить куплено';
  @override String deleteConfirm(String name) => 'Удалить «$name»?';
}

// ── English ───────────────────────────────────────────────
class _AppLocalizationsEn extends AppLocalizations {
  @override String get appTitle       => 'Shopping List';
  @override String get settingsTitle  => 'Settings';
  @override String get addItem        => 'Add item';
  @override String get itemNameHint   => 'Item name';
  @override String get itemNameError  => 'Please enter a name';
  @override String get quantity       => 'Qty';
  @override String get deleteItem     => 'Delete';
  @override String get emptyList      => 'Your list is empty.\nTap + to add items.';
  @override String get themeLabel     => 'Theme';
  @override String get themeLight     => 'Light';
  @override String get themeDark      => 'Dark';
  @override String get themeSystem    => 'System';
  @override String get languageLabel  => 'Language';
  @override String get langEn         => 'English';
  @override String get langRu         => 'Русский';
  @override String get cancel         => 'Cancel';
  @override String get add            => 'Add';
  @override String get editItem       => 'Edit item';
  @override String get save           => 'Save';
  @override String get delete         => 'Delete';
  @override String get boughtSection  => 'Bought';
  @override String get toBuySection   => 'To buy';
  @override String get clearBought    => 'Clear bought';
  @override String deleteConfirm(String name) => 'Delete "$name"?';
}

// ── Delegate ──────────────────────────────────────────────
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return locale.languageCode == 'en'
        ? _AppLocalizationsEn()
        : _AppLocalizationsRu();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
