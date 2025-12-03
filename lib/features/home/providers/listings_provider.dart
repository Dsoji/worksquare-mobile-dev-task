import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/listing_model.dart';

final listingsProvider = FutureProvider<List<Listing>>((ref) async {
  final results = await Future.wait([
    rootBundle.loadString('assets/json/listing.json'),
    Future<void>.delayed(const Duration(milliseconds: 1500)),
  ]);

  final jsonString = results.first as String;
  final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
  return decoded
      .map((item) => Listing.fromJson(item as Map<String, dynamic>))
      .toList();
});
