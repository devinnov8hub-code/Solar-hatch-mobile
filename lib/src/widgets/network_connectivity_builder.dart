import 'package:flutter/material.dart';
import 'package:solar_hatch_mobile/src/controller/network_checker_service.dart';

/// A widget builder that listens to [NetworkCheckerService.isConnectedStream]
/// and rebuilds whenever the network connection status changes.
class NetworkConnectivityBuilder extends StatelessWidget {
  const NetworkConnectivityBuilder({
    required this.builder,
    super.key,
    this.networkService,
  });

  /// Builder callback providing [BuildContext] and a boolean `isConnected`.
  final Widget Function(BuildContext context, bool isConnected) builder;

  /// Optional custom [NetworkCheckerService] instance. Defaults to singleton.
  final NetworkCheckerService? networkService;

  @override
  Widget build(BuildContext context) {
    final service = networkService ?? NetworkCheckerService();
    return StreamBuilder<bool>(
      stream: service.isConnectedStream,
      initialData: service.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? service.isConnected;
        return builder(context, isConnected);
      },
    );
  }
}
