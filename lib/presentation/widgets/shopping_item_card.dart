import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/core/l10n/app_localizations.dart';
import '../../domain/entities/shopping_item.dart';
import '../providers/shopping_list_provider.dart';
import 'add_edit_item_sheet.dart';

class ShoppingItemCard extends ConsumerWidget {
  final ShoppingItem item;
  const ShoppingItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(shoppingListProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Checkbox(
          value: item.isBought,
          onChanged: (_) => notifier.toggleBought(item),
          shape: const CircleBorder(),
        ),
        title: Text(
          item.name,
          style: item.isBought
              ? theme.textTheme.bodyLarge!.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colorScheme.outline,
                )
              : theme.textTheme.bodyLarge,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '×${item.quantity}',
                style: theme.textTheme.labelMedium!.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: item.isBought
                  ? null
                  : () => _openEditSheet(context, item),
              color: colorScheme.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: colorScheme.error,
              onPressed: () async {
                final confirmed = await _confirmDelete(context, item.name);
                if (confirmed == true) notifier.deleteItem(item.id);
              },
            ),
          ],
        ),
        onTap: () => notifier.toggleBought(item),
        onLongPress: () => _openEditSheet(context, item),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    final loc = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final errorColor = Theme.of(ctx).colorScheme.error;
        return AlertDialog(
          title: Text(loc.deleteItem),
          content: Text(loc.deleteConfirm(name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(loc.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: errorColor),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(loc.delete),
            ),
          ],
        );
      },
    );
  }

  void _openEditSheet(BuildContext context, ShoppingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddEditItemSheet(item: item),
    );
  }
}
