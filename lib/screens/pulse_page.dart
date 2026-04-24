import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/big_card.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/rate_button.dart';
import '../widgets/control_button_column.dart';
import '../widgets/swipe_back_wrapper.dart';
import '../widgets/top_banner.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> with TickerProviderStateMixin {
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
        body: SwipeBackWrapper(
          onBack: () async {
            await appState.reset();
            Navigator.pop(context);
          },
          child: Column(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: IconButton(
                                onPressed: () async {
                                  await appState.reset();
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                                color: const Color(0xFFA20202),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                splashRadius: 18,
                                tooltip: 'Back',
                              ),
                            ),
                          ),
                          BigCard(pair: pair),
                        ],
                      ),
                    ),
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
                      child: Image.asset('assets/images/heartrate.gif'),
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
                            labelText: 'Enter Heart Rate'),
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
                              'Please only input numbers from 40-120.');
                        } catch (e) {
                          context.showCustomAlert('Not Connected',
                              'Please connect before modifying heart rate.');
                        }
                      },
                      child: const Text('Enter Heart Rate'),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        RateButton(rate: 40, appState: appState, compact: true),
                        RateButton(rate: 60, appState: appState, compact: true),
                        RateButton(rate: 80, appState: appState, compact: true),
                        RateButton(
                            rate: 100, appState: appState, compact: true),
                        RateButton(
                            rate: 120, appState: appState, compact: true),
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
                                  'Please connect before modifying heart rate.');
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
                                  'Please connect before modifying heart rate.');
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
                                  'Please connect before modifying heart rate.');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final buttonWidth = constraints.maxWidth > 600 ? constraints.maxWidth * 0.5 : constraints.maxWidth;
                          return Center(
                            child: SizedBox(
                              width: buttonWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      appState.launchURL('https://forms.gle/spvtjherXz3DNYiJ9');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 4.0,
                                      ),
                                    ),
                                    child: const Text('Report Issue'),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await appState.reset();
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
