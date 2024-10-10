import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacon Scanner',
      home: BeaconScannerPage(),
    );
  }
}

class BeaconScannerPage extends StatefulWidget {
  @override
  _BeaconScannerPageState createState() => _BeaconScannerPageState();
}

class _BeaconScannerPageState extends State<BeaconScannerPage> {
  final StreamController<String> beaconEventsController = StreamController<String>.broadcast();
  String _beaconResult = "";

  @override
  void initState() {
    super.initState();
    initializeBeaconScanner();
  }

  Future<void> initializeBeaconScanner() async {
    // Request permissions for location and Bluetooth
    await _requestPermissions();

    // Add a region to monitor all beacons (using an empty UUID)
    await BeaconsPlugin.addRegion("myBeacon", "");  // Using empty string for any beacon

    // Run in background if needed
    await BeaconsPlugin.runInBackground(true);

    // Start monitoring for beacons based on platform
    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
    }

    // Listen to beacon events
    BeaconsPlugin.listenToBeacons(beaconEventsController);

    beaconEventsController.stream.listen(
            (data) {
          if (data.isNotEmpty) {
            setState(() {
              _beaconResult = data;
            });
            print("Beacons Data Received: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });
  }

  Future<void> _requestPermissions() async {
    // Request location and Bluetooth permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.locationWhenInUse]!.isDenied ||
        statuses[Permission.bluetooth]!.isDenied ||
        statuses[Permission.bluetoothConnect]!.isDenied ||
        statuses[Permission.bluetoothScan]!.isDenied) {
      // Handle permission denied scenario
      print("Permissions denied, please enable them in settings. "
          "\n locationWhenInUse: ${statuses[Permission.locationWhenInUse]}"
          "\n bluetooth: ${statuses[Permission.bluetooth]}"
          "\n bluetoothConnect: ${statuses[Permission.bluetoothConnect]}"
          "\n bluetoothScan: ${statuses[Permission.bluetoothScan]}");
    } else {
      print("All necessary permissions granted.");
    }
  }

  @override
  void dispose() {
    // Stop monitoring and clear regions when disposed
    BeaconsPlugin.stopMonitoring();
    BeaconsPlugin.clearRegions();
    beaconEventsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beacon Scanner')),
      body: Center(
        child: Text('Beacon Data: $_beaconResult'),
      ),
    );
  }
}
