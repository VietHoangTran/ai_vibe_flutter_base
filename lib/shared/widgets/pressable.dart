import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_spacing.dart';

/// Wraps a tappable surface with a subtle scale-down press animation and a
/// ripple. Use for cards and custom tiles to make them feel interactive.
///
/// The scale effect is skipped when the platform "remove animations"
/// accessibility setting is enabled.
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.borderRadius = AppRadius.card,
    this.pressedScale = 0.97,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final double pressedScale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final scale = (_pressed && !reduceMotion) ? widget.pressedScale : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: AppDurations.fast,
      curve: AppDurations.easeOut,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
