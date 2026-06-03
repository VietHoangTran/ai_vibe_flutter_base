import 'package:flutter/widgets.dart';

/// Spacing, radius and sizing tokens used across the app.
///
/// Centralising these keeps rhythm consistent and avoids magic numbers in
/// widgets.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Default page gutter.
  static const double page = 24;

  /// Maximum content width on large screens / foldables.
  static const double maxContentWidth = 480;

  /// Minimum touch target (matches platform accessibility guidance).
  static const double minTouchTarget = 48;
}

/// Corner radius tokens.
class AppRadius {
  const AppRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
}
