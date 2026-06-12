import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/shopping_item.dart';
import '../../core/di/providers.dart';

const _uuid = Uuid();

class ShoppingListNotifier extends StreamNotifier<List<ShoppingItem>> {
  @override
  Stream<List<ShoppingItem>> build() {
    final useCase = ref.watch(watchShoppingItemsProvider);
    return useCase();
  }

  Future<void> addItem({required String name, required int quantity}) async {
    final item = ShoppingItem(
      id: _uuid.v4(),
      name: name.trim(),
      quantity: quantity,
    );
    await ref.read(addShoppingItemProvider).call(item);
  }

  Future<void> updateItem(ShoppingItem item) async {
    await ref.read(updateShoppingItemProvider).call(item);
  }

  Future<void> deleteItem(String id) async {
    await ref.read(deleteShoppingItemProvider).call(id);
  }

  Future<void> toggleBought(ShoppingItem item) async {
    await ref.read(toggleBoughtProvider).call(item);
  }

  Future<void> clearBought() async {
    final items = state.valueOrNull ?? [];
    for (final item in items.where((i) => i.isBought)) {
      await ref.read(deleteShoppingItemProvider).call(item.id);
    }
  }
}

final shoppingListProvider =
    StreamNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
        ShoppingListNotifier.new);
