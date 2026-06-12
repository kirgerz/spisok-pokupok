  import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/core/l10n/app_localizations.dart';
import '../../domain/entities/shopping_item.dart';
import '../providers/shopping_list_provider.dart';

class AddEditItemSheet extends ConsumerStatefulWidget {
  final ShoppingItem? item;
  const AddEditItemSheet({super.key, this.item});

  @override
  ConsumerState<AddEditItemSheet> createState() => _AddEditItemSheetState();
}

class _AddEditItemSheetState extends ConsumerState<AddEditItemSheet> {
  late final TextEditingController _nameCtrl;
  late int _quantity;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    _quantity = widget.item?.quantity ?? 1;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(shoppingListProvider.notifier);
    if (_isEdit) {
      await notifier.updateItem(
        widget.item!.copyWith(name: _nameCtrl.text, quantity: _quantity),
      );
    } else {
      await notifier.addItem(name: _nameCtrl.text, quantity: _quantity);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isEdit ? loc.editItem : loc.addItem,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: loc.itemNameHint,
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? loc.itemNameError : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(loc.quantity, style: theme.textTheme.bodyLarge),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed:
                      _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('$_quantity',
                      style: theme.textTheme.headlineSmall),
                ),
                IconButton.filledTonal(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEdit ? loc.save : loc.add),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
