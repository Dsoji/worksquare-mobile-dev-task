import 'package:worksquare_mobile_devtask/features/home/model/listing_model.dart';

/// Utility functions related to `Listing` data and filters.
///
/// Keeping these here keeps `home_screen.dart` focused on UI concerns.

int? parsePriceToInt(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return int.tryParse(digits);
}

String extractStateFromLocation(String location) {
  final parts = location.split(',');
  if (parts.length < 2) return location.trim();
  return parts.last.trim();
}

/// Builds a stable hero tag for a listing/image pair.
String buildListingHeroTag(Listing listing, String imagePath) =>
    'listing-${listing.id}-$imagePath';
