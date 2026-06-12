class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final bool isBought;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.isBought = false,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    bool? isBought,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isBought: isBought ?? this.isBought,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ShoppingItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
