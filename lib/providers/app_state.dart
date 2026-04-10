import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';

late DiscoveredDevice ubiqueDevice;
String scanning = 'Scanning...';

class MyAppState extends ChangeNotifier {
  // Some state management stuff
  bool _connected = false;

  bool get connected => _connected;

  bool celsius = false;
  bool stopScanning = false;
  bool currentlyScanning = false;
  bool requestedPermissions = false;
  bool stopCheck = false;

  // Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("00000001-710e-4a5b-8d75-3e5b444bc3cf");

  final Uuid characteristicUuid =
      Uuid.parse("00000003-710e-4a5b-8d75-3e5b444bc3cf");
  final Uuid strengthUuid = Uuid.parse("00000004-710e-4a5b-8d75-3e5b444bc3cf");
  String current = "Ready";
  List<Uuid> discoveredCharacteristic = [];

  Future<void> requestPermission() async {
    if (!requestedPermissions) {
      await [
        Permission.locationWhenInUse,
        Permission.nearbyWifiDevices,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetooth
      ].request();
      print("perms requested");
      requestedPermissions = true;
    }
  }

  void connect() async {
    await Future.delayed(const Duration(seconds: 7));
    current = "Connected";
  }

  void getNext(var data) {
    if (scanning == 'Scanning....') {
      scanning = 'Scanning';
      current = scanning;
    } else {
      current = data;
    }

    notifyListeners();
  }

  Future<void> readDeviceInformation(
      Uuid service, Uuid characteristicToRead, String deviceId) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: service,
        characteristicId: characteristicToRead,
        deviceId: deviceId);
    await flutterReactiveBle.readCharacteristic(characteristic);
  }

  void changeStrength(String deviceId, int strength) async {
    if (_connected) {
      flutterReactiveBle.discoverAllServices(deviceId);
      await flutterReactiveBle.getDiscoveredServices(deviceId);
      // for (Service service in services)
      // {
      //   print(service.characteristics);
      // }

      try {
        flutterReactiveBle.discoverAllServices(deviceId);
        final writeCharacteristic = QualifiedCharacteristic(
            serviceId: serviceUuid,
            characteristicId: strengthUuid,
            deviceId: deviceId);
        print(strength);
        flutterReactiveBle.writeCharacteristicWithResponse(writeCharacteristic,
            value: [strength]);
      } catch (e) {
        current = e.toString();
        print(e);
      }
    }
  }

  void changeSpeed(String deviceId, int speed) async {
    if (_connected) {
      try {
        final writeCharacteristic = QualifiedCharacteristic(
            serviceId: serviceUuid,
            characteristicId: characteristicUuid,
            deviceId: deviceId);
        print(writeCharacteristic);
        print(speed);
        await flutterReactiveBle.writeCharacteristicWithResponse(
          writeCharacteristic,
          value: [speed],
        );
      } catch (e) {
        current = e.toString();
        print("error");
      }
    }

    notifyListeners();
  }

  //To set report issues URL
  void launchURL(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  void discoverPiServices(String deviceId) async {
    getNext('Connecting');
    await Future.delayed(const Duration(seconds: 1));
    _scanStream.cancel();

    stopScanning = true;
    await Future.delayed(const Duration(seconds: 7));
    getNext("Connected");
    _connected = true;
  }

  void startScan() async {
    scanning = "$scanning.";
    getNext(scanning);
    await Future.delayed(const Duration(seconds: 1));
    if (!stopScanning) {
      startScan();
    }
  }

  void discoverDevices() {
    startScan();
    currentlyScanning = true;
    List<String> mList = ['Thermometer'];
    try {
      _scanStream = flutterReactiveBle.scanForDevices(
          withServices: [],
          scanMode: ScanMode.lowLatency).listen((device) async {
        print('scanning');
        if (mList.contains(device.name)) {
          await Future.delayed(const Duration(seconds: 1));
          ubiqueDevice = device;

          flutterReactiveBle
              .connectToDevice(
            id: device.id,
            servicesWithCharacteristicsToDiscover: {
              serviceUuid: [characteristicUuid, strengthUuid]
            },
            connectionTimeout: const Duration(seconds: 1),
          )
              .listen((connectionState) async {
            if (connectionState.connectionState ==
                DeviceConnectionState.disconnected) {
              _scanStream.cancel();
              print("disconnected");
              discoverDevices();
            } else {
              print(connectionState.connectionState);
              if (connectionState.connectionState ==
                  DeviceConnectionState.disconnected) {
                flutterReactiveBle.connectToDevice(
                  id: device.id,
                  servicesWithCharacteristicsToDiscover: {
                    serviceUuid: [characteristicUuid, strengthUuid]
                  },
                  connectionTimeout: const Duration(seconds: 1),
                );

                print("id");
              }

              _scanStream.cancel();
              stopScanning = true;
              currentlyScanning = false;
              // flutterReactiveBle.getDiscoveredServices(device.id);

              // List<Characteristic> characteristicIds = new List<Characteristic>.empty(growable: true);
              // List<Service> services = await flutterReactiveBle.getDiscoveredServices(device.id);
              // for (Service d in services)
              // {
              //   for (Characteristic c in d.characteristics)
              //   {
              //     characteristicIds.add(c);
              //   }
              // }
              // for(Characteristic c in characteristicIds)
              // {
              //   print(c);
              // }
              getNext('Connecting');

              discoverPiServices(device.id);
              await Future.delayed(const Duration(seconds: 3));
              flutterReactiveBle.discoverAllServices(device.id);
              flutterReactiveBle.getDiscoveredServices(device.id);

              print("$device");
            }
          }, onError: (Object error) {
            // Handle a possible error
          });
        }
      }, onError: (Object e) {
        print("error: $e");
      });
    } catch (e) {
      print(e);
    }
  }

  void reset() async {
    print("reset");
    try {
      _scanStream.cancel();
    } catch (e) {
      print(e);
    }

    stopScanning = true;
    if (_connected) {
      changeSpeed(ubiqueDevice.id, -1);
    } else {
      try {
        await Future.delayed(const Duration(seconds: 7));
        changeSpeed(ubiqueDevice.id, -1);
      } catch (exception) {
        print(exception);
      }
    }
  }

  void runCheck(WebViewController webview) async {
    if (!stopCheck) {
      if ("SIM3D" != await WiFiForIoTPlugin.getSSID()) {
        current = "Not Connected";
      } else {
        if (current == "Not Connected") {
          await Future.delayed(const Duration(seconds: 3));
          webview.reload();
          await Future.delayed(const Duration(seconds: 1));
          webview.reload();
        }
        current = "Connected";
      }

      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}