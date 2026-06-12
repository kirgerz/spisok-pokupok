import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/core/l10n/app_localizations.dart';
import '../../domain/entities/shopping_item.dart';
import '../providers/shopping_list_provider.dart';
import '../widgets/add_edit_item_sheet.dart';
import '../widgets/shopping_item_card.dart';
import 'settings_screen.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(shoppingListProvider);
    final loc = AppLocalizations.of(context)!;

    // FIX 1: вынесли hasBought наружу, чтобы использовать if-in-list вместо
    // whenOrNull (который возвращает Widget?, несовместимый с List<Widget>).
    final hasBought =
        asyncItems.valueOrNull?.any((i) => i.isBought) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          // FIX 2: простой if вместо whenOrNull — корректный тип для actions.
          if (hasBought)
            TextButton.icon(
              onPressed: () =>
                  ref.read(shoppingListProvider.notifier).clearBought(),
              icon: const Icon(Icons.cleaning_services_outlined),
              label: Text(loc.clearBought),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: loc.settingsTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: asyncItems.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (items) => _buildList(context, items, loc),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add),
        label: Text(loc.addItem),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<ShoppingItem> items,
    AppLocalizations loc,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              loc.emptyList,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    final toBuy = items.where((i) => !i.isBought).toList();
    final bought = items.where((i) => i.isBought).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return _WideLayout(toBuy: toBuy, bought: bought, loc: loc);
        }
        return CustomScrollView(
          slivers: [
            if (toBuy.isNotEmpty) ...[
              _SectionHeader(title: loc.toBuySection),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ShoppingItemCard(item: toBuy[i]),
                  childCount: toBuy.length,
                ),
              ),
            ],
            if (bought.isNotEmpty) ...[
              _SectionHeader(title: loc.boughtSection),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ShoppingItemCard(item: bought[i]),
                  childCount: bought.length,
                ),
              ),
            ],
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        );
      },
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const AddEditItemSheet(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final List<ShoppingItem> toBuy;
  final List<ShoppingItem> bought;
  final AppLocalizations loc;

  const _WideLayout({
    required this.toBuy,
    required this.bought,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget column(String label, List<ShoppingItem> items) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: items.length,
                  itemBuilder: (_, i) => ShoppingItemCard(item: items[i]),
                ),
              ),
            ],
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        column(loc.toBuySection, toBuy),
        VerticalDivider(width: 1, color: theme.colorScheme.outlineVariant),
        column(loc.boughtSection, bought),
      ],
    );
  }
}
