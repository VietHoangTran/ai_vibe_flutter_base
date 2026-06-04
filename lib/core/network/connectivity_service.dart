import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Coarse network reachability state.
///
/// Note: `connectivity_plus` reports the active transport (wifi, mobile, ...),
/// not real end-to-end reachability. `online` therefore means "a network
/// interface is available", which is a good gate for offline banners and
/// retry affordances but not a guarantee that requests will succeed.
enum ConnectivityStatus { online, offline }

abstract interface class ConnectivityService {
  Future<ConnectivityStatus> currentStatus();
  Stream<ConnectivityStatus> statusChanges();
}

class ConnectivityPlusService implements ConnectivityService {
  const ConnectivityPlusService(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<ConnectivityStatus> currentStatus() async =>
      _map(await _connectivity.checkConnectivity());

  @override
  Stream<ConnectivityStatus> statusChanges() =>
      _connectivity.onConnectivityChanged.map(_map);

  ConnectivityStatus _map(List<ConnectivityResult> results) {
    final isOnline = results.any(
      (result) => result != ConnectivityResult.none,
    );
    return isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityPlusService(Connectivity());
});
