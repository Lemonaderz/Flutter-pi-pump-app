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

class VentPage extends StatefulWidget {
  const VentPage({super.key});

  @override
  State<VentPage> createState() => _VentPageState();
}

class _VentPageState extends State<VentPage> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late int displayText;
  int selectedStrength = 0;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pair = appState.current;
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final isTabletLandscape =
        isTablet && mediaQuery.orientation == Orientation.landscape;
    final controlHorizontalPadding =
        isTabletLandscape ? mediaQuery.size.width * 0.25 : 48.0;
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const TopBanner(),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        await appState.reset();
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 60,
                                        alignment: Alignment.topLeft,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 20,
                                          color: Color(0xFFA20202),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BigCard(pair: pair),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return QuestionAlertDialog(
                                                  title: 'How To Use',
                                                  content:
                                                      '1. Click Scan. Wait until it says "Connected".\n'
                                                      '2. Enter a respiratory rate and click Start. Alternatively, use one of the preset buttons.\n'
                                                      '3. If you want to change the strength, click Weak/Strong.\n'
                                                      '4. To stop, click Stop.\n'
                                                      '5. If you have found an issue or bug, click the warning icon in the top right to fill out a report form.',
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 60,
                                            alignment: Alignment.topRight,
                                            child: const Icon(
                                              Icons.help_outline,
                                              size: 24,
                                              color: Color(0xFFA20202),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                    return WarningActionDialog(
                                                    title: "Report Issue",
                                                    content:
                                                        "Go to the form to report an issue?",
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            appState.launchURL(
                                                                'https://forms.gle/spvtjherXz3DNYiJ9'),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              const StadiumBorder(),
                                                        ),
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 60,
                                            alignment: Alignment.topRight,
                                            child: const Icon(
                                              Icons.warning_amber_rounded,
                                              size: 25,
                                              color: Color(0xFFA20202),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                if (appState.currentlyScanning ||
                                    appState.connected) {
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
                                  appState.changeSpeed(
                                      ubiqueDevice.id, displayText);
                                } on FormatException {
                                  context.showCustomAlert('Input Issue',
                                      'Please only input numbers from 0-30.');
                                } catch (e) {
                                  context.showCustomAlert('Not Connected',
                                      'Please connect before modifying respiratory rate.');
                                }
                              },
                              child: const Text('Start'),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                RateButton(
                                  rate: 10,
                                  appState: appState,
                                  onRateApplied: (value) {
                                    textController.text = value.toString();
                                  },
                                ),
                                RateButton(
                                  rate: 16,
                                  appState: appState,
                                  onRateApplied: (value) {
                                    textController.text = value.toString();
                                  },
                                ),
                                RateButton(
                                  rate: 20,
                                  appState: appState,
                                  onRateApplied: (value) {
                                    textController.text = value.toString();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 44),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: controlHorizontalPadding,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        if (appState.connected) {
                                          appState.changeStrength(
                                              ubiqueDevice.id, 1);
                                          setState(() {
                                            selectedStrength = 1;
                                          });
                                        } else {
                                          context.showCustomAlert(
                                              'Not Connected',
                                              'Please connect before modifying respiratory rate.');
                                        }
                                      },
                                      icon: const Icon(Icons.circle, size: 10),
                                      label: const Text('Weak'),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: selectedStrength == 1
                                            ? const Color(0xFFA20202)
                                            : const Color(0xFF28303F),
                                        side: BorderSide(
                                          color: selectedStrength == 1
                                              ? const Color(0xFFA20202)
                                              : const Color(0xFFB8BEC8),
                                          width: 1.5,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0,
                                          vertical: 10.0,
                                        ),
                                        minimumSize: const Size.fromHeight(48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        if (appState.connected) {
                                          appState.changeStrength(
                                              ubiqueDevice.id, 0);
                                          setState(() {
                                            selectedStrength = 0;
                                          });
                                        } else {
                                          context.showCustomAlert(
                                              'Not Connected',
                                              'Please connect before modifying respiratory rate.');
                                        }
                                      },
                                      icon: const Icon(Icons.circle, size: 14),
                                      label: const Text('Strong'),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: selectedStrength == 0
                                            ? const Color(0xFFA20202)
                                            : const Color(0xFF28303F),
                                        side: BorderSide(
                                          color: selectedStrength == 0
                                              ? const Color(0xFFA20202)
                                              : const Color(0xFFB8BEC8),
                                          width: 1.5,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0,
                                          vertical: 10.0,
                                        ),
                                        minimumSize: const Size.fromHeight(48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            ControlButtonColumn(
                              stretchButtons: isTabletLandscape,
                              horizontalPadding: controlHorizontalPadding,
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
                              ],
                            ),
                            const SizedBox(height: 16),
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
    );
  }
}
