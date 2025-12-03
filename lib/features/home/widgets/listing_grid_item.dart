import 'package:flutter/material.dart';

import 'package:worksquare_mobile_devtask/features/home/listing_details.dart';
import 'package:worksquare_mobile_devtask/features/home/model/listing_model.dart';
import 'package:worksquare_mobile_devtask/features/home/utils/listing_utils.dart';

class ListingGridItem extends StatelessWidget {
  const ListingGridItem({
    super.key,
    required this.listing,
    required this.imagePath,
    required this.animationDelayIndex,
  });

  final Listing listing;
  final String imagePath;
  final int animationDelayIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heroTag = buildListingHeroTag(listing, imagePath);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + animationDelayIndex * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Slight fade-in + lift + scale for a more premium entrance.
        final double opacity = value;
        final double translateY = 24 * (1 - value);
        final double scale = 0.95 + (0.05 * value);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: Semantics(
        button: true,
        label:
            '${listing.title}, ${listing.bedrooms} bedrooms, ${listing.bathrooms} bathrooms, priced at ${listing.price}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ListingDetailsScreen(
                    listing: listing,
                    imagePath: imagePath,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: heroTag,
                      child: Image.asset(
                        imagePath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    listing.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${listing.bedrooms}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.bathtub_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${listing.bathrooms}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.price,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
