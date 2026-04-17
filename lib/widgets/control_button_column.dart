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
    this.stretchButtons = true,
    this.horizontalPadding = _defaultHorizontalPadding,
    this.bottomPadding = 0,
  });

  final List<ControlButtonItem> primaryButtons;
  final bool stretchButtons;
  final double horizontalPadding;
  final double bottomPadding;

  static const double _defaultHorizontalPadding = 48.0;
  static const double _regularSpacing = 8.0;
  static const double _desktopWidthFactor = 0.5;
  static const double _primaryButtonMinHeight = 52.0;
  static const double _buttonBorderRadius = 14.0;
  static const Color _buttonBackgroundColor = Colors.white;
  static const Color _buttonTextColor = Color(0xFFA20202);
  static const EdgeInsets _primaryButtonPadding = EdgeInsets.symmetric(
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
        final buttons = _buildButtons(
          primaryButtons,
          minHeight: _primaryButtonMinHeight,
          padding: _primaryButtonPadding,
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            bottomPadding,
          ),
          child: Center(
            child: stretchButtons
                ? SizedBox(
                    width: buttonWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buttons,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: buttons,
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildButtons(
    List<ControlButtonItem> buttons, {
    required double minHeight,
    required EdgeInsets padding,
  }) {
    return [
      for (var index = 0; index < buttons.length; index++) ...[
        ElevatedButton(
          onPressed: buttons[index].onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonBackgroundColor,
            foregroundColor: _buttonTextColor,
            minimumSize: Size.fromHeight(minHeight),
            padding: padding,
            elevation: 4,
            shadowColor: Colors.black26,
            surfaceTintColor: Colors.transparent,
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
