import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/controller/network_checker_service.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';

class NetworkStatusCard extends StatelessWidget {
  const NetworkStatusCard({
    super.key,
    this.isConnected,
    this.networkService,
  });

  /// Explicit connection status. If null, the card streams the live network
  /// connection from [NetworkCheckerService].
  final bool? isConnected;

  /// Optional custom [NetworkCheckerService] instance (useful for testing).
  final NetworkCheckerService? networkService;

  @override
  Widget build(BuildContext context) {
    if (isConnected != null) {
      return _buildCard(isConnected: isConnected!);
    }

    final service = networkService ?? NetworkCheckerService();
    return StreamBuilder<bool>(
      stream: service.isConnectedStream,
      initialData: service.isConnected,
      builder: (context, snapshot) {
        final connected = snapshot.data ?? service.isConnected;
        return _buildCard(isConnected: connected);
      },
    );
  }

  Widget _buildCard({required bool isConnected}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20).r,
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: isConnected ? AppColors.accentYellow : Colors.redAccent,
            size: 38.r,
          ),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Network Status',
                style: TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.verticalSpace,
              Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18.spMin,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
