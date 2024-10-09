import 'dart:async';

import 'package:beacon_scanner/beacon_scanner.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacon Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BeaconScannerPage(),
    );
  }
}

class BeaconScannerPage extends StatefulWidget {
  @override
  _BeaconScannerPageState createState() => _BeaconScannerPageState();
}

class _BeaconScannerPageState extends State<BeaconScannerPage> {
  List<Beacon> _beacons = [];
  BeaconScanner? _beaconScanner; // Declare as nullable
  StreamSubscription? _streamRanging;

  @override
  void initState() {
    super.initState();
    _initBeaconScanning();
  }

  Future<void> _initBeaconScanning() async {
    // Request location and Bluetooth permissions
    await _requestPermissions();

    // Initialize the beacon scanning API
    _beaconScanner = BeaconScanner.instance; // Use named constructor
    bool isInitialized = await _beaconScanner!.initialize(true);
    if (!isInitialized) {
      print('Failed to initialize beacon scanning');
      return;
    }

    // Check if Bluetooth and location services are enabled
    await _checkBluetoothAndLocation();

    // Start scanning for beacons
    _startScanning();
    bool permission = await Permission.bluetoothScan.request().isGranted;
    print('Permission for bluetoothScanning = ${permission}');
  }

  Future<void> _requestPermissions() async {
    // Request location and Bluetooth permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    if(await Permission.bluetoothScan.isDenied) {
      await [
        Permission.location,
        Permission.locationAlways,
        Permission.locationWhenInUse,
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();
    }
      print('Permission for location = ${statuses[Permission.location]}');
      print('Permission for locationAlways = ${statuses[Permission.locationAlways]}');
      print('Permission for locationWhenInUse = ${statuses[Permission.locationWhenInUse]}');
      print('Permission for bluetooth = ${statuses[Permission.bluetooth]}');
      print('Permission for bluetoothScan = ${statuses[Permission.bluetoothScan]}');
      print('Permission for bluetoothConnect = ${statuses[Permission.bluetoothConnect]}');
      print('Permission for bluetoothAdvertise = ${statuses[Permission.bluetoothAdvertise]}');
  }

  Future<void> _checkBluetoothAndLocation() async {
    bool isLocationEnabled = await _beaconScanner!.checkLocationServicesIfEnabled();
    if (!isLocationEnabled) {
      print('Location services are disabled.');
    }
  }

  void _startScanning() {
    _streamRanging = _beaconScanner!.ranging([const Region(identifier:'any', beaconId: null)]).listen((ScanResult result) {
      setState(() {
        _beacons = result.beacons;
        print('App Is Scanning');
      });
    }, onError: (error) {
      print("Error during ranging: $error");
    });
  }

  @override
  void dispose() {
    _streamRanging?.cancel(); // Stop scanning when the widget is disposed
    _beaconScanner!.close(); // Close the beacon scanning API
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Scanner'),
      ),
      body: _beacons.isEmpty
        ? const Center(child: Text('No beacons found.'))
        : ListView.builder(
          itemCount: _beacons.length,
          itemBuilder: (context, index) {
            final beacon = _beacons[index];
            return ListTile(
              title: Text('UUID: ${beacon.id.proximityUUID}'),
              subtitle: Text('Major: ${beacon.id.majorId}, Minor: ${beacon.id.minorId }, RSSI: ${beacon.rssi}'),
            );
          },
        ),
    );
  }
}
