import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import 'alert_dialog.dart';

class RateButton extends StatelessWidget {
  final int rate;
  final MyAppState appState;
  final bool compact;

  const RateButton({
    super.key,
    required this.rate,
    required this.appState,
    this.compact = false,
  });

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
      style: compact
          ? ElevatedButton.styleFrom(
              minimumSize: const Size(52, 36),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
      child: Text('$rate'),
    );
  }
}
