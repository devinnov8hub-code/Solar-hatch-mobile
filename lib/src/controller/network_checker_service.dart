import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// A service that monitors and streams device network and internet connectivity
/// status to the UI using [InternetConnection].
class NetworkCheckerService {
  /// Returns the singleton instance of [NetworkCheckerService], or a new
  /// instance with a custom [internetConnection] if specified (useful for testing).
  factory NetworkCheckerService({
    InternetConnection? internetConnection,
  }) {
    if (internetConnection != null) {
      return NetworkCheckerService._internal(internetConnection);
    }
    return _instance ??= NetworkCheckerService._internal(
      InternetConnection(),
    );
  }

  NetworkCheckerService._internal(this._internetConnection) {
    _init();
  }

  static NetworkCheckerService? _instance;

  final InternetConnection _internetConnection;
  StreamSubscription<InternetStatus>? _subscription;

  final StreamController<bool> _connectedController =
      StreamController<bool>.broadcast();
  final StreamController<InternetStatus> _statusController =
      StreamController<InternetStatus>.broadcast();

  InternetStatus _currentStatus = InternetStatus.disconnected;
  bool _isInitialized = false;

  /// Synchronously returns the latest known [InternetStatus].
  InternetStatus get currentStatus => _currentStatus;

  /// Synchronously returns `true` if internet connection is currently active.
  bool get isConnected => _currentStatus == InternetStatus.connected;

  /// Broadcast stream of boolean internet connection status
  /// (`true` = connected, `false` = disconnected).
  Stream<bool> get isConnectedStream => _connectedController.stream;

  /// Broadcast stream of raw [InternetStatus] enum events.
  Stream<InternetStatus> get statusStream => _statusController.stream;

  /// Actively checks internet reachability and updates listeners.
  ///
  /// Returns `true` if the device currently has active internet connectivity.
  Future<bool> checkConnection() async {
    try {
      final hasAccess = await _internetConnection.hasInternetAccess;
      final newStatus = hasAccess
          ? InternetStatus.connected
          : InternetStatus.disconnected;
      _updateStatus(newStatus);
      return hasAccess;
    } catch (e) {
      debugPrint('NetworkCheckerService: error checking connectivity: $e');
      _updateStatus(InternetStatus.disconnected);
      return false;
    }
  }

  void _init() {
    // If last try results are already known, adopt them immediately
    final last = _internetConnection.lastTryResults;
    if (last != null) {
      _currentStatus = last;
      _isInitialized = true;
    }

    _subscription = _internetConnection.onStatusChange.listen(
      _updateStatus,
      onError: (Object error) {
        debugPrint('NetworkCheckerService: onStatusChange error: $error');
        _updateStatus(InternetStatus.disconnected);
      },
    );

    // Perform an initial check immediately so initial state is accurate.
    unawaited(checkConnection());
  }

  void _updateStatus(InternetStatus newStatus) {
    final statusChanged = !_isInitialized || _currentStatus != newStatus;
    _currentStatus = newStatus;
    _isInitialized = true;

    if (statusChanged) {
      final connected = newStatus == InternetStatus.connected;
      if (!_statusController.isClosed) {
        _statusController.add(newStatus);
      }
      if (!_connectedController.isClosed) {
        _connectedController.add(connected);
      }
    }
  }

  /// Disposes resources and closes internal streams.
  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    unawaited(_statusController.close());
    unawaited(_connectedController.close());
    if (identical(_instance, this)) {
      _instance = null;
    }
  }
}
