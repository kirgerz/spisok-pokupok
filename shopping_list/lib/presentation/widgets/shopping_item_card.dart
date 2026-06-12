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

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) => _confirmDelete(context, item.name),
      onDismissed: (_) => notifier.deleteItem(item.id),
      child: Card(
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
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: item.isBought
                    ? null
                    : () => _openEditSheet(context, item),
                color: colorScheme.primary,
              ),
            ],
          ),
          onTap: () => notifier.toggleBought(item),
          onLongPress: () => _openEditSheet(context, item),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    final loc = AppLocalizations.of(context)!;
    // FIX 3: Theme.of используем из ctx (контекст диалога), а не из
    // внешнего context, который может быть уже размонтирован после свайпа.
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
