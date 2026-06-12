import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/hive_shopping_datasource.dart';
import '../../data/datasources/hive_settings_datasource.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/shopping_usecases.dart';


final hiveShoppingDsProvider = Provider<HiveShoppingDataSource>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

final hiveSettingsDsProvider = Provider<HiveSettingsDataSource>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});


final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ref.watch(hiveShoppingDsProvider);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return ref.watch(hiveSettingsDsProvider);
});


final watchShoppingItemsProvider = Provider((ref) {
  return WatchShoppingItems(ref.watch(shoppingRepositoryProvider));
});

final addShoppingItemProvider = Provider((ref) {
  return AddShoppingItem(ref.watch(shoppingRepositoryProvider));
});

final updateShoppingItemProvider = Provider((ref) {
  return UpdateShoppingItem(ref.watch(shoppingRepositoryProvider));
});

final deleteShoppingItemProvider = Provider((ref) {
  return DeleteShoppingItem(ref.watch(shoppingRepositoryProvider));
});

final toggleBoughtProvider = Provider((ref) {
  return ToggleBought(ref.watch(shoppingRepositoryProvider));
});
