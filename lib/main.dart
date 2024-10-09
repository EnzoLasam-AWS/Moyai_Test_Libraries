import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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
  final flutterReactiveBle = FlutterReactiveBle();
  late Stream<DiscoveredDevice> scanStream;
  List<DiscoveredDevice> _beacons = [];

  // Define your beacon UUID here
  final String beaconUuid = "YOUR_BEACON_UUID"; // Replace with your beacon UUID

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _startScanning();
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  void _startScanning() {
    scanStream = flutterReactiveBle.scanForDevices(
      withServices: [], // Can be set to specific UUIDs if needed
      scanMode: ScanMode.balanced,
    );

    scanStream.listen((device) {
      // Check if the device's service UUID matches the beacon UUID
      if (device.serviceUuids.contains(beaconUuid)) {
        setState(() {
          // Check if the device is already in the list
          if (!_beacons.any((d) => d.id == device.id)) {
            _beacons.add(device);
          }
        });
      }
    }, onError: (error) {
      // Handle scan errors if necessary
      print('Error scanning for devices: $error');
    });
  }

  @override
  void dispose() {
    // Dispose of resources if necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Scanner'),
      ),
      body: _beacons.isEmpty
          ? const Center(child: Text('No beacons found'))
          : ListView.builder(
        itemCount: _beacons.length,
        itemBuilder: (context, index) {
          final device = _beacons[index];
          return ListTile(
            title: Text('Device Name: ${device.name.isEmpty ? 'Unknown' : device.name}'),
            subtitle: Text('Device ID: ${device.id}'),
          );
        },
      ),
    );
  }
}
