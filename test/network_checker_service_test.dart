import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:solar_hatch_mobile/src/controller/network_checker_service.dart';
import 'package:solar_hatch_mobile/src/widgets/network_connectivity_builder.dart';
import 'package:solar_hatch_mobile/src/widgets/network_status_card.dart';

class FakeInternetConnection implements InternetConnection {
  FakeInternetConnection({bool initialAccess = true})
      : _hasAccess = initialAccess;

  final StreamController<InternetStatus> _controller =
      StreamController<InternetStatus>.broadcast(sync: true);

  bool _hasAccess;

  void emitStatus(InternetStatus status) {
    _hasAccess = status == InternetStatus.connected;
    _controller.add(status);
  }

  @override
  Stream<InternetStatus> get onStatusChange => _controller.stream;

  @override
  Future<bool> get hasInternetAccess async => _hasAccess;

  @override
  Future<InternetStatus> get internetStatus async =>
      _hasAccess ? InternetStatus.connected : InternetStatus.disconnected;

  @override
  InternetStatus? get lastTryResults =>
      _hasAccess ? InternetStatus.connected : InternetStatus.disconnected;

  @override
  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('NetworkCheckerService', () {
    late FakeInternetConnection fakeConnection;
    late NetworkCheckerService service;

    setUp(() {
      fakeConnection = FakeInternetConnection();
      service = NetworkCheckerService(internetConnection: fakeConnection);
    });

    tearDown(() async {
      service.dispose();
      await fakeConnection.dispose();
    });

    test('initializes and checks connection status', () async {
      final isConnected = await service.checkConnection();
      expect(isConnected, isTrue);
      expect(service.isConnected, isTrue);
      expect(service.currentStatus, InternetStatus.connected);
    });

    test('streams connection status changes as boolean', () async {
      final statuses = <bool>[];
      final subscription = service.isConnectedStream.listen(statuses.add);

      fakeConnection
        ..emitStatus(InternetStatus.disconnected)
        ..emitStatus(InternetStatus.connected);

      await pumpEventQueue();

      expect(statuses, equals([false, true]));

      await subscription.cancel();
    });

    test('streams raw InternetStatus changes', () async {
      final statuses = <InternetStatus>[];
      final subscription = service.statusStream.listen(statuses.add);

      fakeConnection.emitStatus(InternetStatus.disconnected);

      await pumpEventQueue();

      expect(statuses, equals([InternetStatus.disconnected]));

      await subscription.cancel();
    });
  });

  group('NetworkStatusCard Widget', () {
    testWidgets('renders Connected when isConnected is true', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(383, 852),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: NetworkStatusCard(isConnected: true),
            ),
          ),
        ),
      );

      expect(find.text('Connected'), findsOneWidget);
      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });

    testWidgets('renders Disconnected when isConnected is false',
        (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(383, 852),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: NetworkStatusCard(isConnected: false),
            ),
          ),
        ),
      );

      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('updates live when NetworkCheckerService emits changes',
        (tester) async {
      final fake = FakeInternetConnection();
      final testService = NetworkCheckerService(internetConnection: fake);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(383, 852),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: NetworkStatusCard(networkService: testService),
            ),
          ),
        ),
      );

      expect(find.text('Connected'), findsOneWidget);

      fake.emitStatus(InternetStatus.disconnected);
      await tester.pump();

      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);

      testService.dispose();
      await fake.dispose();
    });
  });

  group('NetworkConnectivityBuilder', () {
    testWidgets('rebuilds UI when network status changes', (tester) async {
      final fake = FakeInternetConnection();
      final testService = NetworkCheckerService(internetConnection: fake);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NetworkConnectivityBuilder(
              networkService: testService,
              builder: (context, isConnected) {
                return Text(
                  isConnected ? 'ONLINE' : 'OFFLINE',
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('ONLINE'), findsOneWidget);

      fake.emitStatus(InternetStatus.disconnected);
      await tester.pump();

      expect(find.text('OFFLINE'), findsOneWidget);

      testService.dispose();
      await fake.dispose();
    });
  });
}
