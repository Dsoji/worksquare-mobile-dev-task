import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:worksquare_mobile_devtask/features/home/model/filter_config.dart';
import 'package:worksquare_mobile_devtask/features/home/providers/listings_provider.dart';
import 'package:worksquare_mobile_devtask/features/home/utils/listing_utils.dart';
import 'package:worksquare_mobile_devtask/features/home/widgets/home_filter_sheet.dart';
import 'package:worksquare_mobile_devtask/features/home/widgets/listing_grid_item.dart';
import 'package:worksquare_mobile_devtask/common/res/app_spacing.dart';
import 'package:worksquare_mobile_devtask/common/res/assets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final listingState = ref.watch(listingsProvider);
    final visibleCount = useState(8);
    final selectedStatus = useState<String?>(null);
    final priceRange = useState<RangeValues?>(null);
    final minBedrooms = useState<int?>(null);
    final selectedLocation = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to,',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'DreamDwell Estates',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Open filters',
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer.withOpacity(
                  0.95,
                ),
              ),
              onPressed: () async {
                final asyncListings = ref.read(listingsProvider);

                await showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: theme.colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) {
                    return asyncListings.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Center(
                        child: Text(
                          'Unable to load filters right now.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      data: (listings) {
                        final initialConfig = FilterConfig(
                          status: selectedStatus.value,
                          location: selectedLocation.value,
                          priceRange: priceRange.value,
                          minBedrooms: minBedrooms.value,
                        );

                        return HomeFilterSheet(
                          listings: listings,
                          initialConfig: initialConfig,
                          onApply: (config) {
                            selectedStatus.value = config.status;
                            selectedLocation.value = config.location;
                            priceRange.value = config.priceRange;
                            minBedrooms.value = config.minBedrooms;
                          },
                          onClear: () {
                            selectedStatus.value = null;
                            selectedLocation.value = null;
                            priceRange.value = null;
                            minBedrooms.value = null;
                          },
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.tune_rounded,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: listingState.when(
          loading: () => StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: theme.colorScheme.primary.withOpacity(0.15),
                highlightColor: theme.colorScheme.primary.withOpacity(0.35),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            height: 12,
                            width: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 12,
                            width: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 40,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn’t load the listings.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          data: (listings) {
            // Derive unique high-level locations (e.g. Lagos, Abuja, Ogun).
            final locations = <String>{
              for (final l in listings) extractStateFromLocation(l.location),
            }..removeWhere((e) => e.isEmpty);
            final locationList = locations.toList()..sort();

            // Apply status, price, bedroom and location filters if any.
            final filteredListings = listings.where((listing) {
              // Status filter
              if (selectedStatus.value != null) {
                if (listing.status.isEmpty ||
                    listing.status.first != selectedStatus.value) {
                  return false;
                }
              }

              // Price filter
              if (priceRange.value != null) {
                final priceInt = parsePriceToInt(listing.price);
                if (priceInt == null) return false;
                final range = priceRange.value!;
                if (priceInt < range.start || priceInt > range.end) {
                  return false;
                }
              }

              // Bedroom filter (minimum)
              if (minBedrooms.value != null &&
                  listing.bedrooms < minBedrooms.value!) {
                return false;
              }

              // Location filter (by state/city group)
              if (selectedLocation.value != null) {
                final state = extractStateFromLocation(listing.location);
                if (state != selectedLocation.value) {
                  return false;
                }
              }

              return true;
            }).toList();

            if (filteredListings.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationSelector(
                    locations: locationList,
                    selectedLocation: selectedLocation.value,
                    onChanged: (value) => selectedLocation.value = value,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Expanded(
                    child: Center(
                      child: Text('No listings found for the selected filter.'),
                    ),
                  ),
                ],
              );
            }

            final count = min(visibleCount.value, filteredListings.length);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LocationSelector(
                  locations: locationList,
                  selectedLocation: selectedLocation.value,
                  onChanged: (value) => selectedLocation.value = value,
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200 &&
                          visibleCount.value < filteredListings.length) {
                        visibleCount.value = min(
                          visibleCount.value + 8,
                          filteredListings.length,
                        );
                      }
                      return false;
                    },
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: count,
                      itemBuilder: (context, index) {
                        final listing = filteredListings[index];
                        // Cycle through the four property images for visual variety
                        final images = [
                          ImageAssets.image1,
                          ImageAssets.image2,
                          ImageAssets.image3,
                          ImageAssets.image4,
                        ];
                        final imagePath = images[index % images.length];

                        // Staggered entrance animation per tile is handled
                        // inside the extracted `ListingGridItem` widget.
                        final delayIndex = index % 8;

                        return ListingGridItem(
                          listing: listing,
                          imagePath: imagePath,
                          animationDelayIndex: delayIndex,
                        );
                      },
                      staggeredTileBuilder: (index) =>
                          const StaggeredTile.fit(1),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.locations,
    required this.selectedLocation,
    required this.onChanged,
  });

  final List<String> locations;
  final String? selectedLocation;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (locations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Text(
          'Location',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: DropdownButtonFormField2<String?>(
            value: selectedLocation,
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
            ),
            hint: const Text('Anywhere'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Anywhere'),
              ),
              ...locations.map(
                (loc) =>
                    DropdownMenuItem<String?>(value: loc, child: Text(loc)),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
