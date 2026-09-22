import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
    super.key,
  });

  final String icon;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12).r,
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primaryDarkGreen : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12).r,
        boxShadow: isUnread
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8).r,
            decoration: BoxDecoration(
              color: isUnread
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.primaryDarkGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(icon, width: 24.w, height: 24.h),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnread ? Colors.white : AppColors.primaryDarkGreen,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.verticalSpace,
                Text(
                  description,
                  style: TextStyle(
                    color: isUnread
                        ? Colors.white70
                        : AppColors.primaryDarkGreen.withValues(alpha: 0.7),
                    fontSize: 12.spMin,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: isUnread
                      ? Colors.white
                      : AppColors.primaryDarkGreen,
                  fontSize: 12.spMin,
                ),
              ),
              24.verticalSpace,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6).r,
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(8).r,
                ),
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: AppColors.primaryDarkGreen,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
