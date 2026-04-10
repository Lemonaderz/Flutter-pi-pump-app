import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import 'alert_dialog.dart';

class RateButton extends StatelessWidget {
  final int rate;
  final MyAppState appState;

  const RateButton({super.key, required this.rate, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (appState.connected) {
          appState.changeSpeed(ubiqueDevice.id, rate);
        } else {
          context.showCustomAlert('Not Connected', 'Please connect before modifying heart rate.');
        }
      },
      child: Text('$rate'),
    );
  }
}