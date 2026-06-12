import '../entities/shopping_item.dart';
import '../repositories/shopping_repository.dart';

class WatchShoppingItems {
  final ShoppingRepository _repo;
  const WatchShoppingItems(this._repo);
  Stream<List<ShoppingItem>> call() => _repo.watchAll();
}

class AddShoppingItem {
  final ShoppingRepository _repo;
  const AddShoppingItem(this._repo);
  Future<void> call(ShoppingItem item) => _repo.add(item);
}

class UpdateShoppingItem {
  final ShoppingRepository _repo;
  const UpdateShoppingItem(this._repo);
  Future<void> call(ShoppingItem item) => _repo.update(item);
}

class DeleteShoppingItem {
  final ShoppingRepository _repo;
  const DeleteShoppingItem(this._repo);
  Future<void> call(String id) => _repo.delete(id);
}

class ToggleBought {
  final ShoppingRepository _repo;
  const ToggleBought(this._repo);

  Future<void> call(ShoppingItem item) =>
      _repo.update(item.copyWith(isBought: !item.isBought));
}
