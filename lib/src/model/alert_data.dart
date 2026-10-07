import 'package:solar_hatch_mobile/src/core/app_assets.dart';

class AlertData {
  AlertData({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.isUnread,
    required this.icon,
  });

  factory AlertData.fromJson(String id, Map<dynamic, dynamic> json) {
    return AlertData(
      id: id,
      title: json['title'] as String? ?? 'Alert',
      description: json['description'] as String? ?? '',
      time: json['time'] as String? ?? '',
      isUnread: json['isUnread'] as bool? ?? true,
      icon: _getIconPath(json['iconType'] as String?),
    );
  }
  final String id;
  final String title;
  final String description;
  final String time;
  final bool isUnread;
  final String icon;

  static String _getIconPath(String? type) {
    switch (type) {
      case 'humidifier':
        return AppAssets.humidifierIcon;
      case 'temperature':
        return AppAssets.temperatureIcon;
      case 'calendar':
        return AppAssets.calendarIcon;
      case 'system':
      default:
        return AppAssets.settingsIcon;
    }
  }
}
