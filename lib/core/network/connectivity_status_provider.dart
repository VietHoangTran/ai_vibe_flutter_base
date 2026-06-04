import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'connectivity_service.dart';

part 'connectivity_status_provider.g.dart';

/// Emits the current [ConnectivityStatus] immediately, then every change.
///
/// Watch this from any widget (see `OfflineBanner`) or controller that needs
/// to react to going offline/online.
@riverpod
Stream<ConnectivityStatus> connectivityStatus(Ref ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield await service.currentStatus();
  yield* service.statusChanges();
}
