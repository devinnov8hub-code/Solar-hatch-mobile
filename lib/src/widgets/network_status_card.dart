import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';

class NetworkStatusCard extends StatelessWidget {
  const NetworkStatusCard({super.key, this.isConnected = true});
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
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
            color: AppColors.accentYellow,
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
