import 'package:flutter/material.dart';

import 'package:worksquare_mobile_devtask/features/home/model/filter_config.dart';
import 'package:worksquare_mobile_devtask/features/home/model/listing_model.dart';
import 'package:worksquare_mobile_devtask/features/home/utils/listing_utils.dart';

/// Bottom‑sheet widget that encapsulates all filter UI and logic.
class HomeFilterSheet extends StatefulWidget {
  const HomeFilterSheet({
    super.key,
    required this.listings,
    required this.initialConfig,
    required this.onApply,
    required this.onClear,
  });

  final List<Listing> listings;
  final FilterConfig initialConfig;
  final ValueChanged<FilterConfig> onApply;
  final VoidCallback onClear;

  @override
  State<HomeFilterSheet> createState() => _HomeFilterSheetState();
}

class _HomeFilterSheetState extends State<HomeFilterSheet> {
  late String? _status;
  late RangeValues _priceRange;
  late int? _minBedrooms;

  late final List<String> _statusList;
  late final int _minPrice;
  late final int _maxPrice;
  late final List<int> _bedroomOptions;

  @override
  void initState() {
    super.initState();

    _status = widget.initialConfig.status;
    _minBedrooms = widget.initialConfig.minBedrooms;

    // Derive unique primary status tags from data, e.g. "House", "Flat".
    final statuses = <String>{
      for (final l in widget.listings)
        if (l.status.isNotEmpty) l.status.first,
    };
    _statusList = statuses.toList()..sort();

    // Derive min/max price and bedrooms for sliders.
    final prices =
        widget.listings
            .map((l) => parsePriceToInt(l.price))
            .whereType<int>()
            .toList()
          ..sort();
    _minPrice = prices.isNotEmpty ? prices.first : 0;
    _maxPrice = prices.isNotEmpty ? prices.last : 0;

    final beds = widget.listings.map((l) => l.bedrooms).toList()..sort();
    _bedroomOptions = beds.toSet().toList()..sort();

    final initialRange = widget.initialConfig.priceRange;
    _priceRange =
        initialRange ?? RangeValues(_minPrice.toDouble(), _maxPrice.toDouble());
  }

  String _formatNaira(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final reverseIndex = str.length - i - 1;
      buffer.write(str[reverseIndex]);
      if ((i + 1) % 3 == 0 && i + 1 != str.length) {
        buffer.write(',');
      }
    }
    final formatted = buffer.toString().split('').reversed.join();
    return '₦$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter listings',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onClear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Property type',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _status == null,
                    onSelected: (_) {
                      setState(() {
                        _status = null;
                      });
                    },
                  ),
                  for (final status in _statusList)
                    ChoiceChip(
                      label: Text(status),
                      selected: _status == status,
                      onSelected: (_) {
                        setState(() {
                          _status = status;
                        });
                      },
                    ),
                ],
              ),
              if (_maxPrice > 0) ...[
                const SizedBox(height: 24),
                Text(
                  'Price range',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatNaira(_priceRange.start.toInt()),
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      _formatNaira(_priceRange.end.toInt()),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: _minPrice.toDouble(),
                  max: _maxPrice.toDouble(),
                  divisions: 20,
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
              ],
              if (_bedroomOptions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Minimum bedrooms',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Any'),
                      selected: _minBedrooms == null,
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() {
                          _minBedrooms = null;
                        });
                      },
                    ),
                    for (final bedsCount in _bedroomOptions)
                      ChoiceChip(
                        label: Text('$bedsCount+ bedrooms'),
                        selected: _minBedrooms == bedsCount,
                        onSelected: (selected) {
                          setState(() {
                            _minBedrooms = selected ? bedsCount : null;
                          });
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      FilterConfig(
                        status: _status,
                        location: widget.initialConfig.location,
                        priceRange: _priceRange,
                        minBedrooms: _minBedrooms,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
