import 'package:flutter/material.dart';

class ControlButtonItem {
  const ControlButtonItem({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

class ControlButtonColumn extends StatelessWidget {
  const ControlButtonColumn({
    super.key,
    required this.primaryButtons,
    required this.secondaryButtons,
  });

  final List<ControlButtonItem> primaryButtons;
  final List<ControlButtonItem> secondaryButtons;

  static const double _horizontalPadding = 38.0;
  static const double _regularSpacing = 8.0;
  static const double _groupSpacing = 16.0;
  static const double _desktopWidthFactor = 0.5;
  static const double _buttonMinHeight = 52.0;
  static const double _buttonBorderRadius = 14.0;
  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth > 600
            ? constraints.maxWidth * _desktopWidthFactor
            : constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Center(
            child: SizedBox(
              width: buttonWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ..._buildButtons(primaryButtons),
                  if (primaryButtons.isNotEmpty && secondaryButtons.isNotEmpty)
                    const SizedBox(height: _groupSpacing),
                  ..._buildButtons(secondaryButtons),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildButtons(List<ControlButtonItem> buttons) {
    return [
      for (var index = 0; index < buttons.length; index++) ...[
        ElevatedButton(
          onPressed: buttons[index].onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(_buttonMinHeight),
            padding: _buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
            ),
          ),
          child: Text(buttons[index].label),
        ),
        if (index < buttons.length - 1) const SizedBox(height: _regularSpacing),
      ],
    ];
  }
}
