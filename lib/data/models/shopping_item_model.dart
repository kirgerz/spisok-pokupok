import 'package:hive/hive.dart';
import '../../domain/entities/shopping_item.dart';

part 'shopping_item_model.g.dart';

@HiveType(typeId: 0)
class ShoppingItemModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int quantity;

  @HiveField(3)
  late bool isBought;

  ShoppingItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isBought,
  });

  factory ShoppingItemModel.fromEntity(ShoppingItem e) => ShoppingItemModel(
        id: e.id,
        name: e.name,
        quantity: e.quantity,
        isBought: e.isBought,
      );

  ShoppingItem toEntity() => ShoppingItem(
        id: id,
        name: name,
        quantity: quantity,
        isBought: isBought,
      );
}
