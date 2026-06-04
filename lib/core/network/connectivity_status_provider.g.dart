// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits the current [ConnectivityStatus] immediately, then every change.
///
/// Watch this from any widget (see `OfflineBanner`) or controller that needs
/// to react to going offline/online.

@ProviderFor(connectivityStatus)
final connectivityStatusProvider = ConnectivityStatusProvider._();

/// Emits the current [ConnectivityStatus] immediately, then every change.
///
/// Watch this from any widget (see `OfflineBanner`) or controller that needs
/// to react to going offline/online.

final class ConnectivityStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectivityStatus>,
          ConnectivityStatus,
          Stream<ConnectivityStatus>
        >
    with
        $FutureModifier<ConnectivityStatus>,
        $StreamProvider<ConnectivityStatus> {
  /// Emits the current [ConnectivityStatus] immediately, then every change.
  ///
  /// Watch this from any widget (see `OfflineBanner`) or controller that needs
  /// to react to going offline/online.
  ConnectivityStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStatusHash();

  @$internal
  @override
  $StreamProviderElement<ConnectivityStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ConnectivityStatus> create(Ref ref) {
    return connectivityStatus(ref);
  }
}

String _$connectivityStatusHash() =>
    r'1bb0624ffd5c93cc1264ae08935c204214079aae';
