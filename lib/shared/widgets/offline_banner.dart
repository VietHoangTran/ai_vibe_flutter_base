import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations_x.dart';
import '../../core/network/connectivity_status_provider.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_spacing.dart';

/// A thin banner that slides in when the device goes offline.
///
/// Wired globally through `MaterialApp.router`'s builder, so any screen shows
/// it automatically. Collapses to zero height while online.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline =
        ref.watch(connectivityStatusProvider).value ==
        ConnectivityStatus.offline;

    final theme = Theme.of(context);

    return AnimatedSize(
      duration: AppDurations.fast,
      curve: AppDurations.easeOut,
      alignment: Alignment.topCenter,
      child: isOffline
          ? Material(
              color: theme.colorScheme.errorContainer,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 18,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        context.l10n.offlineMessage,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(width: double.infinity),
    );
  }
}
