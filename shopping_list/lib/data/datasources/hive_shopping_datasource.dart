import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/shopping_item_model.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';

class HiveShoppingDataSource implements ShoppingRepository {
  static const _boxName = 'shopping_items';
  late Box<ShoppingItemModel> _box;

  // StreamController для реактивного обновления UI
  final _controller = StreamController<List<ShoppingItem>>.broadcast();

  Future<void> init() async {
    _box = await Hive.openBox<ShoppingItemModel>(_boxName);
    // Слушаем изменения Hive-бокса и транслируем в Stream
    _box.listenable().addListener(_onBoxChanged);
  }

  void _onBoxChanged() {
    _controller.add(_mapAll());
  }

  List<ShoppingItem> _mapAll() =>
      _box.values.map((m) => m.toEntity()).toList();

  @override
  Future<List<ShoppingItem>> getAll() async => _mapAll();

  @override
  Stream<List<ShoppingItem>> watchAll() {
    // Сразу отдаём текущее состояние при подписке
    return _controller.stream;
  }

  @override
  Future<void> add(ShoppingItem item) async {
    await _box.put(item.id, ShoppingItemModel.fromEntity(item));
  }

  @override
  Future<void> update(ShoppingItem item) async {
    await _box.put(item.id, ShoppingItemModel.fromEntity(item));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  void dispose() {
    _box.listenable().removeListener(_onBoxChanged);
    _controller.close();
  }
}
