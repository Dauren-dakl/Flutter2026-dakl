import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/format.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onFavouriteToggle,
    required this.onTap,
  });

  final Item item;
  final VoidCallback onFavouriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    backgroundColor: item.category.color(colors).withOpacity(0.2),
                    child: Icon(item.category.icon, color: item.category.color(colors)),
                  ),
                  if (item.isFull || item.freePlaces <= 5)
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isFull ? colors.error : colors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.surface, width: 2),
                        ),
                        child: Text(
                          item.isFull ? 'FULL' : '${item.freePlaces} left',
                          style: textTheme.labelSmall?.copyWith(
                            color: item.isFull ? colors.onError : colors.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatDateTime(item.when)} • ${item.location}',
                      style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  item.favourite ? Icons.favorite : Icons.favorite_border,
                  color: item.favourite ? colors.error : null,
                ),
                onPressed: onFavouriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}