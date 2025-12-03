import 'package:flutter/material.dart';

/// Centralized text styles and helpers.
///
/// These build on top of the theme's text styles, so they adapt to
/// light/dark mode while giving us consistent weights and sizes.
class AppTypography {
  const AppTypography._();

  static TextStyle? sectionTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          );

  static TextStyle? mutedBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
}


