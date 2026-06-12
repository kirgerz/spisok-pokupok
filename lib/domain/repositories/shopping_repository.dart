  import '../entities/shopping_item.dart';

abstract interface class ShoppingRepository {
  /// Загрузить все товары.
  Future<List<ShoppingItem>> getAll();

  /// Добавить новый товар.
  Future<void> add(ShoppingItem item);

  /// Обновить существующий товар.
  Future<void> update(ShoppingItem item);

  /// Удалить товар по id.
  Future<void> delete(String id);

  /// Поток изменений списка (реактивность).
  Stream<List<ShoppingItem>> watchAll();
}
