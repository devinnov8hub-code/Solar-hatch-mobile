class IncubationData {
  IncubationData({
    required this.currentIncubationDay,
    required this.hatchingDays,
    required this.humidity,
    required this.motorTurned,
    required this.setHumidity,
    required this.setTemperature,
    required this.temperature,
    required this.totalIncubationDays,
    required this.turnInterval,
    required this.turnStop,
    required this.wifiStatus,
  });

  factory IncubationData.fromJson(Map<dynamic, dynamic> json) {
    return IncubationData(
      currentIncubationDay:
          (json['currentIncubationDay'] as num?)?.toInt() ?? 0,
      hatchingDays: (json['hatchingDays'] as num?)?.toInt() ?? 0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      motorTurned: (json['motorTurned'] as num?)?.toInt() ?? 0,
      setHumidity: (json['setHumidity'] as num?)?.toDouble() ?? 0.0,
      setTemperature: (json['setTemperature'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      totalIncubationDays: (json['totalIncubationDays'] as num?)?.toInt() ?? 0,
      turnInterval: (json['turnInterval'] as num?)?.toInt() ?? 0,
      turnStop: (json['turnStop'] as num?)?.toInt() ?? 0,
      wifiStatus: (json['wifiStatus'] as num?)?.toInt() ?? 0,
    );
  }

  factory IncubationData.initial() {
    return IncubationData(
      currentIncubationDay: 0,
      hatchingDays: 0,
      humidity: 0,
      motorTurned: 0,
      setHumidity: 0,
      setTemperature: 0,
      temperature: 0,
      totalIncubationDays: 0,
      turnInterval: 2,
      turnStop: 0,
      wifiStatus: 0,
    );
  }

  final int currentIncubationDay;
  final int hatchingDays;
  final double humidity;
  final int motorTurned;
  final double setHumidity;
  final double setTemperature;
  final double temperature;
  final int totalIncubationDays;
  final int turnInterval;
  final int turnStop;
  final int wifiStatus;
}
