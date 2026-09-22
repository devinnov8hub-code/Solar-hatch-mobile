import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';

enum DiagnosticStatus { operational, warning }

class SystemDiagnosticCard extends StatelessWidget {
  const SystemDiagnosticCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.description,
    super.key,
  });
  final String icon;
  final String title;
  final DiagnosticStatus status;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isOperational = status == DiagnosticStatus.operational;
    final statusColor = isOperational
        ? AppColors.statusOperational
        : AppColors.statusWarning;
    final statusText = isOperational ? 'OPERATIONAL' : 'WARNING';

    return Container(
      padding: const EdgeInsets.all(12).r,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 23.w, height: 23.h),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color.fromRGBO(3, 64, 34, 1),
                      fontSize: 10.spMin,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
