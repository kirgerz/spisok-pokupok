# Список покупок — Flutter App

## Стек
- **Flutter** 3.10+, Dart 3.0+
- **Управление состоянием:** Riverpod (StreamNotifier, AsyncNotifier)
- **Хранилище:** Hive (товары + настройки)
- **DI:** Riverpod Provider + ProviderScope overrides
- **UI:** Material 3, адаптивный (телефон / планшет)
- **Локализация:** Flutter Gen-l10n (ru / en)

## Архитектура

```
lib/
├── core/
│   ├── di/          # Riverpod-провайдеры (DI + инверсия зависимостей)
│   ├── l10n/        # ARB-файлы (en, ru)
│   └── theme/       # Material 3 тема (light / dark)
├── data/
│   ├── datasources/ # Реализации репозиториев (Hive)
│   └── models/      # Hive-модели с адаптерами
├── domain/
│   ├── entities/    # Чистые сущности (ShoppingItem, AppSettings)
│   ├── repositories/# Абстрактные интерфейсы (инверсия зависимостей)
│   └── usecases/    # Бизнес-логика
└── presentation/
    ├── providers/   # Riverpod Notifiers
    ├── screens/     # Экраны
    └── widgets/     # Переиспользуемые виджеты
```

## Запуск

### 1. Установить зависимости
```bash
flutter pub get
```

### 2. Сгенерировать код локализации
```bash
flutter gen-l10n
```

### 3. Сгенерировать Hive-адаптеры (если нужно пересоздать)
```bash
dart run build_runner build --delete-conflicting-outputs
```
> Файл `shopping_item_model.g.dart` уже включён в репозиторий,
> поэтому шаг 3 нужен только при изменении модели.

### 4. Запустить
```bash
flutter run
```

## Функции

### Экран списка покупок
- ➕ Добавление товара (название + количество)
- ✏️ Редактирование (нажать иконку или long press)
- ✅ Отметить куплено (checkbox или tap по строке) — вычёркивание без удаления
- 🗑️ Удаление свайпом вправо → влево (с подтверждением)
- 🧹 Кнопка «Очистить куплено» — удалить все отмеченные
- Секции «Купить» / «Куплено»
- Адаптивный layout: на широких экранах (>600px) — две колонки

### Экран настроек
- 🎨 Переключение темы: Светлая / Системная / Тёмная
- 🌍 Переключение языка: Русский / English
- Настройки сохраняются в Hive между запусками

## Инверсия зависимостей

Domain-слой объявляет **интерфейсы** (`ShoppingRepository`, `SettingsRepository`).
Data-слой предоставляет **реализации** (`HiveShoppingDataSource`, `HiveSettingsDataSource`).
В `main.dart` через `ProviderScope.overrides` реализации подставляются в провайдеры —
domain никогда не импортирует пакет `hive`.

```dart
ProviderScope(
  overrides: [
    hiveShoppingDsProvider.overrideWithValue(shoppingDs),
    hiveSettingsDsProvider.overrideWithValue(settingsDs),
  ],
  child: const ShoppingApp(),
)
```
