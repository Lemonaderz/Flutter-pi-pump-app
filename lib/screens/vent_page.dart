import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/big_card.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/rate_button.dart';

class VentPage extends StatefulWidget {
  const VentPage({super.key});

  @override
  State<VentPage> createState() => _VentPageState();
}

class _VentPageState extends State<VentPage> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late int displayText;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pair = appState.current;
    appState.requestPermission();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/croppedlogo.png', fit: BoxFit.cover),
              const SizedBox(height: 20),
              BigCard(pair: pair),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (appState.currentlyScanning || appState.connected) {
                    var title = 'Currently Scanning';
                    var content = 'Already scanning.';
                    if (appState.connected) {
                      title = 'Already Connected';
                      content = 'Device Already connected. If errors persist please restart the application.';
                    }
                    context.showCustomAlert(title, content);
                  } else {
                    appState.getNext('Beginning');
                    appState.discoverDevices();
                  }
                },
                child: const Text('Scan'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 240,
                height: 100,
                child: Image.asset('assets/images/lung2.webp'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 240,
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Enter Respiratory Rate'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  try {
                    displayText = int.parse(textController.text);
                    appState.changeSpeed(ubiqueDevice.id, displayText);
                  } on FormatException {
                    context.showCustomAlert('Input Issue', 'Please only input numbers from 0-30.');
                  } catch (e) {
                    context.showCustomAlert('Not Connected', 'Please connect before modifying respiratory rate.');
                  }
                },
                child: const Text('Enter Respiratory Rate'),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  RateButton(rate: 10, appState: appState),
                  RateButton(rate: 16, appState: appState),
                  RateButton(rate: 20, appState: appState),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (appState.connected) {
                        appState.changeSpeed(ubiqueDevice.id, 0);
                      } else {
                        context.showCustomAlert('Not Connected', 'Please connect before modifying respiratory rate.');
                      }
                    },
                    child: const Text('Stop'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.connected) {
                        appState.changeStrength(ubiqueDevice.id, 1);
                      } else {
                        context.showCustomAlert('Not Connected', 'Please connect before modifying respiratory rate.');
                      }
                    },
                    child: const Text('Weak'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (appState.connected) {
                        appState.changeStrength(ubiqueDevice.id, 0);
                      } else {
                        context.showCustomAlert('Not Connected', 'Please connect before modifying respiratory rate.');
                      }
                    },
                    child: const Text('Strong'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      appState.launchURL('https://forms.gle/spvtjherXz3DNYiJ9');
                    },
                    child: const Text('Report Issue'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      appState.reset();
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
