import '../entities/shopping_item.dart';

abstract interface class ShoppingRepository {
  Future<List<ShoppingItem>> getAll();

  Future<void> add(ShoppingItem item);

  Future<void> update(ShoppingItem item);

  Future<void> delete(String id);

  Stream<List<ShoppingItem>> watchAll();
}
