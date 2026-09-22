import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_hatch_mobile/src/controller/firebase_service.dart';
import 'package:solar_hatch_mobile/src/core/app_colors.dart';
import 'package:solar_hatch_mobile/src/model/alert_data.dart';
import 'package:solar_hatch_mobile/src/widgets/notification_card.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundScaffold,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16).r,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'Notifications & Alerts',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18.spMin,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<AlertData>>(
        stream: _firebaseService.alertsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading alerts'));
          }

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkGreen,
              ),
            );
          }

          final alerts = snapshot.data ?? [];
          if (alerts.isEmpty) {
            return const Center(child: Text('No recent alerts'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: AppColors.primaryDarkGreen,
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ).r,
                      decoration: BoxDecoration(
                        color: AppColors.alertRed,
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Dismiss All',
                            style: TextStyle(
                              color: AppColors.alertRedText,
                              fontSize: 12.spMin,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.horizontalSpace,
                          Icon(
                            Icons.close,
                            color: AppColors.alertRedText,
                            size: 16.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                ...alerts.map(
                  (alert) => NotificationCard(
                    icon: alert.icon,
                    title: alert.title,
                    description: alert.description,
                    time: alert.time,
                    isUnread: alert.isUnread,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
