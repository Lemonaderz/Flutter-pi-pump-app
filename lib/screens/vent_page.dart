import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/big_card.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/rate_button.dart';
import '../widgets/control_button_column.dart';
import '../widgets/top_banner.dart';

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TopBanner(),
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
                            content =
                                'Device Already connected. If errors persist please restart the application.';
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
                        decoration: const InputDecoration(
                            labelText: 'Enter Respiratory Rate'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          displayText = int.parse(textController.text);
                          appState.changeSpeed(ubiqueDevice.id, displayText);
                        } on FormatException {
                          context.showCustomAlert('Input Issue',
                              'Please only input numbers from 0-30.');
                        } catch (e) {
                          context.showCustomAlert('Not Connected',
                              'Please connect before modifying respiratory rate.');
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
                    ControlButtonColumn(
                      stretchButtons: false,
                      primaryButtons: [
                        ControlButtonItem(
                          label: 'Stop',
                          icon: Icons.stop_outlined,
                          onPressed: () {
                            if (appState.connected) {
                              appState.changeSpeed(ubiqueDevice.id, 0);
                            } else {
                              context.showCustomAlert('Not Connected',
                                  'Please connect before modifying respiratory rate.');
                            }
                          },
                        ),
                        ControlButtonItem(
                          label: 'Weak',
                          icon: Icons.remove_outlined,
                          onPressed: () {
                            if (appState.connected) {
                              appState.changeStrength(ubiqueDevice.id, 1);
                            } else {
                              context.showCustomAlert('Not Connected',
                                  'Please connect before modifying respiratory rate.');
                            }
                          },
                        ),
                        ControlButtonItem(
                          label: 'Strong',
                          icon: Icons.add_outlined,
                          onPressed: () {
                            if (appState.connected) {
                              appState.changeStrength(ubiqueDevice.id, 0);
                            } else {
                              context.showCustomAlert('Not Connected',
                                  'Please connect before modifying respiratory rate.');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 20.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonWidth = constraints.maxWidth > 600
                        ? constraints.maxWidth * 0.5
                        : constraints.maxWidth;
                    return Center(
                      child: SizedBox(
                        width: buttonWidth,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                appState.reset();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4.0,
                                ),
                              ),
                              child: const Text('Back'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                appState.launchURL(
                                    'https://forms.gle/spvtjherXz3DNYiJ9');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4.0,
                                ),
                              ),
                              child: const Text('Report Issue'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
