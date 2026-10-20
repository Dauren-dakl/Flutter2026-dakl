import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import '../widgets/empty_state.dart';

class FavouritesTab extends StatelessWidget {
  final List<Item> items;
  final void Function(Item) onToggleFavourite;
  final void Function(Item) onOpenDetail;

  const FavouritesTab({
    super.key,
    required this.items,
    required this.onToggleFavourite,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final favs = items.where((i) => i.favourite).toList();

    if (favs.isEmpty) {
      return const EmptyState(icon: Icons.favorite_border, message: 'No favourites yet');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => ItemCard(
        item: favs[i],
        onFavouriteToggle: () => onToggleFavourite(favs[i]),
        onTap: () => onOpenDetail(favs[i]),
      ),
    );
  }
}
