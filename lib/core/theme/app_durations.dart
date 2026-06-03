import 'package:flutter/widgets.dart';

/// Animation timing tokens.
///
/// Micro-interactions stay within 150-300ms; entrance animations are slightly
/// longer. Easing favours `easeOutCubic` for entering elements.
class AppDurations {
  const AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  /// Per-item delay used when staggering a list/grid entrance.
  static const Duration stagger = Duration(milliseconds: 70);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
}
