# Solar Hatch Mobile

Solar Hatch Mobile is a Flutter application designed for monitoring and diagnosing an automated solar-powered incubation system. 

## Features
- **Dashboard Overview**: Get a bird's-eye view of your incubator's performance.
- **System Diagnostics**: Monitor real-time status of critical components:
  - System Health
  - Humidifier
  - Heater
  - Motor Sensor
- **Incubation Status**: Track essential metrics for successful incubation:
  - Temperature
  - Humidity
  - Total Days & Days Left
- **Network Status**: Ensure constant connectivity and data sync.
- **Notifications**: Stay updated on system warnings and alerts.

## Project Structure
The app's source code is organized primarily inside the `lib/src` directory:

- **`core/`**: Houses app-wide configurations, constants, assets (`app_assets.dart`), and themes (`app_colors.dart`).
- **`model/`**: Contains data models (e.g., `incubation_data.dart`).
- **`view/`**: Contains the main screens (UI pages) of the application, such as `dashboard_view.dart`, `splash_view.dart`, and `notifications_view.dart`.
- **`widgets/`**: Reusable UI components including status cards (`incubation_status_card.dart`, `system_diagnostic_card.dart`, `network_status_card.dart`, etc.).

## Dependencies
This project relies on several key Flutter packages (refer to `pubspec.yaml` for versions):
- [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil): For responsive UI adapting to various screen sizes.
- [`very_good_analysis`](https://pub.dev/packages/very_good_analysis): For strict and robust Dart linting rules.
- `cupertino_icons`: For iOS-style icons.

## Getting Started

### Prerequisites
Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your machine.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/devinnov8hub-code/Solar-hatch-mobile
   ```
2. Navigate to the project directory:
   ```bash
   cd solar_hatch_mobile
   ```
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```

### Running the App
Run the application on a connected device or emulator:
```bash
flutter run
```

## Code Quality
This project uses `very_good_analysis` for strict linting rules. Make sure to run `flutter analyze` before pushing your changes to ensure code quality is maintained.
