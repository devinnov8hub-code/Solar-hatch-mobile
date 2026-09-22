class IncubationData {
  IncubationData({
    required this.currentIncubationDay,
    required this.hatchingDays,
    required this.humidity,
    required this.setHumidity,
    required this.setTemperature,
    required this.temperature,
    required this.totalIncubationDays,
    required this.wifiStatus,
  });

  factory IncubationData.fromJson(Map<dynamic, dynamic> json) {
    return IncubationData(
      currentIncubationDay:
          (json['currentIncubationDay'] as num?)?.toInt() ?? 0,
      hatchingDays: (json['hatchingDays'] as num?)?.toInt() ?? 0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      setHumidity: (json['setHumidity'] as num?)?.toDouble() ?? 0.0,
      setTemperature: (json['setTemperature'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      totalIncubationDays: (json['totalIncubationDays'] as num?)?.toInt() ?? 0,
      wifiStatus: (json['wifiStatus'] as num?)?.toInt() ?? 0,
    );
  }

  factory IncubationData.initial() {
    return IncubationData(
      currentIncubationDay: 0,
      hatchingDays: 0,
      humidity: 0,
      setHumidity: 0,
      setTemperature: 0,
      temperature: 0,
      totalIncubationDays: 0,
      wifiStatus: 0,
    );
  }
  final int currentIncubationDay;
  final int hatchingDays;
  final double humidity;
  final double setHumidity;
  final double setTemperature;
  final double temperature;
  final int totalIncubationDays;
  final int wifiStatus;
}
