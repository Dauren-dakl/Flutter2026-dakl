import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/category.dart';
import '../widgets/item_card.dart';
import '../widgets/empty_state.dart';

class ListTab extends StatefulWidget {
  final List<Item> items;
  final void Function(Item) onToggleFavourite;
  final void Function(Item) onOpenDetail;

  const ListTab({
    super.key,
    required this.items,
    required this.onToggleFavourite,
    required this.onOpenDetail,
  });

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  String _search = '';
  Category? _selectedCategory;
  bool _showPast = false;

  List<Item> get _visibleItems {
    var result = widget.items;

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result.where((i) =>
      i.title.toLowerCase().contains(q) ||
          i.location.toLowerCase().contains(q)
      ).toList();
    }

    if (_selectedCategory != null) {
      result = result.where((i) => i.category == _selectedCategory).toList();
    }

    if (!_showPast) {
      result = result.where((i) => !i.isPast).toList();
    }

    result.sort((a, b) => a.when.compareTo(b.when));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _search = ''),
              )
                  : null,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
              ),
              const SizedBox(width: 8),
              ...Category.values.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  avatar: Icon(c.icon, size: 16),
                  label: Text(c.label),
                  selected: _selectedCategory == c,
                  onSelected: (_) => setState(() => _selectedCategory = c),
                ),
              )),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Show past'),
                selected: _showPast,
                onSelected: (v) => setState(() => _showPast = v),
              ),
            ],
          ),
        ),

        Expanded(
          child: items.isEmpty
              ? const EmptyState(icon: Icons.search_off, message: 'No items found')
              : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) => ItemCard(
                    item: items[i],
                    onFavouriteToggle: () => widget.onToggleFavourite(items[i]),
                    onTap: () => widget.onOpenDetail(items[i]),
                  ),
                );
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) => ItemCard(
                    item: items[i],
                    onFavouriteToggle: () => widget.onToggleFavourite(items[i]),
                    onTap: () => widget.onOpenDetail(items[i]),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}