import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/localization/app_localizations_x.dart';
import '../../core/theme/app_spacing.dart';

/// Renders an [AsyncValue] with sensible defaults for every state.
///
/// The default error state shows a friendly, localized message (or the
/// [AppException.message] when one is available) plus a retry button when
/// [onRetry] is provided. Raw exceptions are never shown to the user; pass
/// a custom [error] builder when a feature needs different handling.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (err, stackTrace) =>
          error?.call(err, stackTrace) ??
          _DefaultErrorView(error: err, onRetry: onRetry),
    );
  }
}

class _DefaultErrorView extends StatelessWidget {
  const _DefaultErrorView({required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = switch (error) {
      AppException(:final message) => message,
      _ => context.l10n.errorGeneric,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
