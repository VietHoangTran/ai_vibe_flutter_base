import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';

/// Entrance animation that fades and slides a child up into place.
///
/// Honours the platform "remove animations" accessibility setting via
/// [MediaQueryData.disableAnimations]: when enabled, the child appears
/// immediately with no motion.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.slow,
    this.offset = 24,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Vertical distance (in logical pixels) the child travels while entering.
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: AppDurations.easeOut,
  );

  bool _started = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
      return;
    }

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _opacity.value) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
