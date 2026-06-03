import 'package:flutter/material.dart';

/// The app's gradient logo mark — a rounded square with a glyph, matching the
/// indigo launcher icon. Reused on the login screen and as the home avatar.
class BrandMark extends StatelessWidget {
  const BrandMark({
    this.size = 72,
    this.icon = Icons.bolt_rounded,
    super.key,
  });

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.tertiary],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.35),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Icon(icon, color: colors.onPrimary, size: size * 0.5),
    );
  }
}
