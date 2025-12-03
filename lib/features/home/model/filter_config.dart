import 'package:flutter/material.dart';

/// Immutable configuration representing the active filters on the home screen.
class FilterConfig {
  const FilterConfig({
    this.status,
    this.location,
    this.priceRange,
    this.minBedrooms,
  });

  final String? status;
  final String? location;
  final RangeValues? priceRange;
  final int? minBedrooms;

  FilterConfig copyWith({
    String? status,
    String? location,
    RangeValues? priceRange,
    int? minBedrooms,
  }) {
    return FilterConfig(
      status: status ?? this.status,
      location: location ?? this.location,
      priceRange: priceRange ?? this.priceRange,
      minBedrooms: minBedrooms ?? this.minBedrooms,
    );
  }
}


