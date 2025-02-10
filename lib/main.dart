import 'dart:async';
import 'dart:convert';
import 'package:flash/flash_helper.dart';
import 'package:flutter/services.dart'; 
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flash/flash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';


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
            SizedBox(height: 05),
            Image.asset('assets/images/croppedlogo.png',fit: BoxFit.cover),
            SizedBox(height: 65),
            SizedBox(height: 150, width: 150, child:ElevatedButton(
          child: const Text('Pulse App'),
          onPressed: () {
            Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const PulseApp()),
          );
          },style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade50)
          )

          
        ))
            ,SizedBox(height: 25),
        SizedBox(
          height: 150,
          width: 150,
          child:
        ElevatedButton(
          child: const Text('Vent App'),
          onPressed: () {
            Navigator.pushReplacement(
              
    context,
    
    MaterialPageRoute(builder: (context) => const VentApp()),
          );
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade50)
          )
        ), ),

        SizedBox(height: 25),
        SizedBox(height: 150, width: 150, child:ElevatedButton(
          child: const Text('Laryngoscope Video'),
          onPressed: () {
            Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LaryngApp()),
          );
          },style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade50)
          )

          
        ))
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

class LaryngApp extends StatelessWidget {
  const LaryngApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Laryngoscope Video',
        home: MyLaryngPage(title: "Actuator Control"),
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
  bool stop_check = false;
// Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
  late StreamSubscription<ConnectionStateUpdate> _connect;
// These are the UUIDs of your device
  late Stream<ConnectionStateUpdate> _connectionStream;
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
          current = "Connecting";
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
      try{
      final writeCharacteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: deviceId); 
      print(writeCharacteristic);
      flutterReactiveBle.writeCharacteristicWithResponse(writeCharacteristic, value: [speed]);

      }
      catch(e)
      {
        print("error");
      }
      
      

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
    getNext('Connecting');
    await Future.delayed(const Duration(seconds: 1));
    _scanStream.cancel();
   
    stop_scanning = true;
    await Future.delayed(const Duration(seconds: 7));
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
    try{

    
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

              print("id");
              
              


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
    catch(e)
    {
      print(e);
    }


  }
  void reset()
  async {
    print("reset");
    try{
    _scanStream.cancel();
    }
    catch(e)
    {
      print(e);
    }
    
    stop_scanning = true;
    if(_connected)
    {

      changeSpeed(_ubiqueDevice.id, -1);
    }
    else
    {
      try
      {
        await Future.delayed(const Duration(seconds: 7));
        changeSpeed(_ubiqueDevice.id, -1);

      }
      catch(exception)
      {
        print(exception);
        
      }
    }
  }


  void run_check(WebViewController webview) async
  {
    if (!stop_check)
    {
      
    
    if ("SIM3D" != await WiFiForIoTPlugin.getSSID())
    {
      current = "Not Connected";
    }
    else{
      if(current == "Not Connected")
      {
      await Future.delayed(const Duration(seconds: 3));
       webview.reload();
       await Future.delayed(const Duration(seconds: 1));
       webview.reload();
       
      }
      current ="Connected";

    }

    
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    }
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
  late int displayText;
  @override
  void initState() {
  super.initState();
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
                    child: Image.asset('assets/images/heartrate.gif')
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
                      appState.reset();
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
  late int displayText;
  @override
  void initState() {
  super.initState();
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
                      appState.reset();
                    },
                    child: Text('Back')),
          ],
        ),
      ),
    );
  }
}

class MyLaryngPage extends StatefulWidget {
  const MyLaryngPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  State<MyLaryngPage> createState() => _MyLaryngPageState();
}
class _MyLaryngPageState extends State<MyLaryngPage> with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  late VlcPlayerController _videoPlayerController;
  late int displayText;
  late WebViewController _controller;
   bool _isEnabled = false;
  bool _isConnected = false;
  bool _isWiFiAPEnabled = false;
  bool _isWiFiAPSSIDHidden = false;
  bool _isWifiAPSupported = true;
  bool _isWifiEnableOpenSettings = false;
  bool _isWifiDisableOpenSettings = false;
  @override
  void initState() {
    
     _videoPlayerController = VlcPlayerController.network(
      'http://192.168.0.75:8081/',
      hwAcc: HwAcc.disabled,
      options: VlcPlayerOptions(
        http: VlcHttpOptions([  VlcHttpOptions.httpContinuous(true)  
                ],),
        rtp: VlcRtpOptions([VlcRtpOptions.rtpOverRtsp(true)],),
        advanced:  VlcAdvancedOptions([ VlcAdvancedOptions.networkCaching(30)],),
      ),
      
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://192.168.0.1:8081')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.0.1:8081'));
    // #enddocregion webview_controller

  super.initState();
  }
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }

  void intiWifi() async
  {
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    appState.stop_check = false;
    appState.run_check(_controller);
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset('assets/images/croppedlogo.png',fit: BoxFit.fitHeight,),
           SizedBox(height: 10),
            BigCard(pair: pair),
            Expanded( child: Center( child:
             Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              
            ),
          ),
          // child: VlcPlayer(
          //   controller: _videoPlayerController,
          //   aspectRatio: 12 / 9,
          //   placeholder: Center(child: CircularProgressIndicator())) ,
//           child: Mjpeg(
//   stream: 'http://192.168.0.75/', isLive: true, timeout: const Duration(seconds: 60),
// )
        child: WebViewWidget(controller: _controller),
        ), 
            ),
            ),

            ElevatedButton(
                    onPressed: () {
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
                              title: Text('Connection Guide'),
                              content: Text('Please connect to the SIM3D Wifi network.\n\nThe Wifi password is: \n\nsim3d123\n\nPlease allow some time for the SIM3D wifi to appear after Larngoscope startup'),
                              actions: [
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                    child: Text('How to connect'),),
            ElevatedButton(
                    onPressed: () {
                      appState.stop_check = true;
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const LandingPage()));
                    },
                    child: Text('Back')),

            
                    
             ]
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