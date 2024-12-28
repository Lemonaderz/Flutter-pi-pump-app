import 'dart:async';
import 'dart:convert';
import 'package:flash/flash_helper.dart';
import 'package:flutter/services.dart'; 
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gif/gif.dart';
import 'package:flash/flash.dart';
import 'package:url_launcher/url_launcher.dart';

late DiscoveredDevice _ubiqueDevice;
String scanning = 'Scanning...';
int _fps = 5;
void main() {
  runApp(MaterialApp(
    home: LandingPage(), 
    theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
  ));
  
}
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          children: [
            SizedBox(height: 45),
            Image.asset('assets/images/croppedlogo.png',fit: BoxFit.cover),
            SizedBox(height: 75),
            SizedBox(height: 150, width: 150, child:ElevatedButton(
          child: const Text('Pulse App'),
          onPressed: () {
            Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PulseApp()),
          );
          },
          
        ))
            ,SizedBox(height: 75),
        SizedBox(
          height: 150,
          width: 150,
          child:
        ElevatedButton(
          child: const Text('Vent App'),
          onPressed: () {
            Navigator.push(
              
    context,
    
    MaterialPageRoute(builder: (context) => const VentApp()),
          );
          },
        ), )
        ],)
        
        
        
      ),
    );
  }
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pulse App',
        home: MyHomePage(title: "Actuator Control"),
         theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        )
      ),
    );
  }
}

class VentApp extends StatelessWidget {
  const VentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vent App',
        home: MyVentPage(title: "Actuator Control"),
         theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        )
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Some state management stuff
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
  bool celsius = false;
  bool stop_scanning = false;
  bool currentlyScanning = false;
  bool requested_permissions = false;
// Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
  late StreamSubscription _connect;
// These are the UUIDs of your device

  final Uuid serviceUuid = Uuid.parse("00000001-710e-4a5b-8d75-3e5b444bc3cf");
  
  final Uuid characteristicUuid = Uuid.parse("00000003-710e-4a5b-8d75-3e5b444bc3cf");
  final Uuid strengthUuid = Uuid.parse("00000004-710e-4a5b-8d75-3e5b444bc3cf");
  String current = "Ready";
  List<Uuid> discoveredCharacteristic = [];   

Future<void> requestPermission() async {
  if (!requested_permissions)
  {
    Map<Permission, PermissionStatus> status = await [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetooth
    ].request();
    print("perms requested");
    requested_permissions = true;
  }
  
  


 
}
  void Connect() async
  {
    await Future.delayed(const Duration(seconds: 7));
    current = "Connected";
  }

  void getNext(var data) {
    if (scanning == 'Scanning....')
    {
      scanning ='Scanning';
      current = scanning;
    }
    else{
      current = data;
      if (_connected){
        Connect();
      }
        
    }
  
  
      
    notifyListeners();
  }
  Future<void> readDeviceInformation(Uuid service, Uuid characteristicToRead, String deviceId) async {
    final characteristic = QualifiedCharacteristic(serviceId: service, characteristicId: characteristicToRead, deviceId: deviceId);
    final response = await flutterReactiveBle.readCharacteristic(characteristic);
    print(response);
  }
  
  void changeStrength(String deviceId, int strength) async {
    if (_connected){
      final writeCharacteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: strengthUuid, deviceId: deviceId);
      print(flutterReactiveBle.writeCharacteristicWithResponse(writeCharacteristic, value: [strength]));
    }
  }
  void changeSpeed(String  deviceId, int speed) async {
    if (_connected){
      final writeCharacteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: deviceId); 
      print(writeCharacteristic);
      flutterReactiveBle.writeCharacteristicWithResponse(writeCharacteristic, value: [speed]);
      

    }
    if (speed > 0){
      _fps = 60;
    }
    else {
      _fps = 10;
    }
    
    notifyListeners();
    


  }
  //To set report issues URL
  void _launchURL(String url) async {
  await launch(url);
}




  void discoverPiServices(String deviceId) async {
    await Future.delayed(const Duration(seconds: 1));
    _scanStream.cancel();
    flutterReactiveBle.discoverAllServices(deviceId);
    print("services");
    print(flutterReactiveBle.getDiscoveredServices(deviceId));
    discoveredCharacteristic = [];
    List<Uuid> characteristicIds = [];
    final writeCharacteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: Uuid.parse("00000003-710e-4a5b-8d75-3e5b444bc3cf"), deviceId: deviceId); 
    final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: deviceId);
    print(characteristic);
    await Future.delayed(const Duration(seconds: 3));
    getNext("Connected");
    _connected = true;

    
  }
  void startScan() async{
    scanning = "$scanning.";
    getNext(scanning);
    await Future.delayed(const Duration(seconds: 1));
    if (stop_scanning){

    }
    else{
      startScan();
    }
  }
   void discoverDevices() {
    
    bool permGranted = true;
    startScan();
    currentlyScanning = true;
    List<String> mList = ['Thermometer'];   
    _scanStream = flutterReactiveBle.scanForDevices(   withServices: [], scanMode: ScanMode.lowLatency).listen((device) async {
      print('scanning');
      if (mList.contains(device.name))
      {
        await Future.delayed(const Duration(seconds: 1));
        _ubiqueDevice = device;
        _foundDeviceWaitingToConnect = true;

        flutterReactiveBle.connectToDevice(
        id: device.id,
        servicesWithCharacteristicsToDiscover: {serviceUuid: [characteristicUuid]},
        connectionTimeout: const Duration(seconds: 1),
        ).listen((connectionState) async {
          if (connectionState.connectionState == DeviceConnectionState.disconnected){
            
            _scanStream.cancel();
            print("disconnected");
            discoverDevices();
          }
          else{

            print(connectionState.connectionState);
            if (connectionState.connectionState == DeviceConnectionState.disconnected)
            {
                flutterReactiveBle.connectToDevice(
          id: device.id,
          servicesWithCharacteristicsToDiscover: {serviceUuid: [characteristicUuid]},
          connectionTimeout: const Duration(seconds: 1),
                  );

            }
            _scanStream.cancel();
            stop_scanning = true;
            currentlyScanning = false;
            getNext('Connecting');
            
            discoverPiServices(device.id);
            print("$device");
          }
        }, onError: (Object error) {
          // Handle a possible error
        });
      }       
    }, onError: (Object e) {
      print("error: $e");
    });


  }

  
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  late final GifController backgroundController;
  late int displayText;
  @override
  void initState() {
  super.initState();
  backgroundController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    appState.requestPermission();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/croppedlogo.png',fit: BoxFit.cover,),
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton( 
            onPressed: (){
              
              if (appState.currentlyScanning | appState._connected)
              {
                String title = "Currently Scanning";
                String content = "Already scanning.";
                if (appState._connected)
                {
                  String title = "Already Connected";
                  String content = "Device Already connected. If errors persist please restart the application.";
                }
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text(title),
                              content: Text(content),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              
              }
              else{
                appState.getNext("Beginning");
                appState.discoverDevices();
              }
              

              },
            child: Text('Scan'),
            ),
            SizedBox(
                    width: 240,
                    height:100,
                    child: Gif( 
                        fps: _fps,
                        autostart: Autostart.once,
                        placeholder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        image: AssetImage('assets/images/heartrate.gif'),
                       onFetchCompleted: () {
                        backgroundController.repeat(period: Duration(seconds: 1));
                        
                      },
                    ),
                ),
            SizedBox(
              width: 240, // <-- TextField width

            child: TextField(
              onTapOutside: (event){
                FocusManager.instance.primaryFocus?.unfocus();
              },
                controller: textController,
                 decoration: InputDecoration(labelText: "Enter Heart Rate"),
                 keyboardType: TextInputType.number,
                 inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.digitsOnly],
                 
            ),
            ),

            ElevatedButton( 
            onPressed: (){
              try {
               displayText = int.parse(textController.text);
               appState.changeSpeed(_ubiqueDevice.id, displayText);
              } on FormatException 
              {
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Input Issue'),
                              content: Text('Please only input numbers from 40-120.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              }
              catch(e)
              {
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              
              }
              },
            child: Text('Enter Heart Rate'),
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 40);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child:  Text('40')),
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 60);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('60')),
                    ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 80);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('80')),
                ElevatedButton(
                    onPressed: () {
                     if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 100);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('100')),
                ElevatedButton(
                    onPressed: () {
                     if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 120);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('120')),
              ],
            ), 
            SizedBox(
              width: 400,
              child: 
            ListView(
              shrinkWrap: true, //just set this property
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.none,
              children: <Widget>[
                                  
                    ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 0);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                    },
                    child: Text('Stop')),
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeStrength(_ubiqueDevice.id, 1);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Weak')),
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeStrength(_ubiqueDevice.id, 0);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                    },
                    child: Text('Strong')),
                    
                    
              ],
            ),),
            
            ElevatedButton(
                    onPressed: () {
                      appState._launchURL('https://forms.gle/spvtjherXz3DNYiJ9'); 
                    },
                    child: Text('Report Issue')),
          ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const LandingPage()));
                    },
                    child: Text('Back')),],
        ),
      ),
    );
  }
}

class MyVentPage extends StatefulWidget {
  const MyVentPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  State<MyVentPage> createState() => _MyVentPageState();
}
class _MyVentPageState extends State<MyVentPage> with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  late final GifController backgroundController;
  late int displayText;
  @override
  void initState() {
  super.initState();
  backgroundController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    appState.requestPermission();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/croppedlogo.png',fit: BoxFit.cover,),
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton( 
            onPressed: (){
              
              if (appState.currentlyScanning | appState._connected)
              {
                String title = "Currently Scanning";
                String content = "Already scanning.";
                if (appState._connected)
                {
                  String title = "Already Connected";
                  String content = "Device Already connected. If errors persist please restart the application.";
                }
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text(title),
                              content: Text(content),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              
              }
              else{
                appState.getNext("Beginning");
                appState.discoverDevices();
              }
              

              },
            child: Text('Scan'),
            ),
            SizedBox(
                    width: 240,
                    height:100,
                    child: Image( 

                        image: AssetImage('assets/images/lung2.webp'),
                       
                    ),
                ),
            SizedBox(
              width: 240, // <-- TextField width

            child: TextField(
                controller: textController,
                 decoration: InputDecoration(labelText: "Enter Respiratory Rate"),
                 keyboardType: TextInputType.number,
                 inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.digitsOnly],
                 
            ),
            ),

            ElevatedButton( 
            onPressed: (){
              try {
               displayText = int.parse(textController.text);
               appState.changeSpeed(_ubiqueDevice.id, displayText);
              } on FormatException 
              {
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Input Issue'),
                              content: Text('Please only input numbers from 0-30.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              }
              catch(e)
              {
                context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
              
              }
              },
            child: Text('Enter Respiratory Rate'),
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 10);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before respiratory heart rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('10')),
                ElevatedButton(
                    onPressed: () {
                     if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 16);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('16')),
                ElevatedButton(
                    onPressed: () {
                     if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 20);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('20')),
              ],
            ), 
            SizedBox(
              width: 400,
              child: 
            ListView(
              shrinkWrap: true, //just set this property
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.none,
              children: <Widget>[
                                  
                    ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeSpeed(_ubiqueDevice.id, 0);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                    },
                    child: Text('Apnoea')),
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeStrength(_ubiqueDevice.id, 1);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Shallow')),
                ElevatedButton(
                    onPressed: () {
                      if (appState._connected)
                      {
                        appState.changeStrength(_ubiqueDevice.id, 0);
                      }
                      else
                      {
                        context.showFlash(barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                              title: Text('Not Connected'),
                              content: Text('Please connect before modifying respiratory rate.'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                    },
                    child: Text('Normal')),
                    
                    
              ],
            ),),
            
            ElevatedButton(
                    onPressed: () {
                      appState._launchURL('https://forms.gle/spvtjherXz3DNYiJ9'); 
                    },
                    child: Text('Report Issue')),
           ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const LandingPage()));
                    },
                    child: Text('Back')),
          ],
        ),
      ),
    );
  }
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 50,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          pair,
          style: style,
          semanticsLabel: pair,
      ),
      ),
    );
  }
}