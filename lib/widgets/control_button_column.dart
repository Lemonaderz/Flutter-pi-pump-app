import 'package:flutter/material.dart';

class ControlButtonItem {
  const ControlButtonItem({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
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
  static const double _regularSpacing = 14.0;
  static const double _primaryButtonMinHeight = 48.0;
  static const double _buttonBorderRadius = 9.0;
  static const double _compactButtonWidth = 148.0;
  static const Color _buttonBackgroundColor = Color(0xFFF1F3F6);
  static const Color _buttonTextColor = Color(0xFF28303F);
  static const EdgeInsets _primaryButtonPadding = EdgeInsets.symmetric(
    horizontal: 14.0,
    vertical: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttons = _buildButtons(
          primaryButtons,
          minHeight: _primaryButtonMinHeight,
          padding: _primaryButtonPadding,
          stretchButtons: stretchButtons,
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
                    width: double.infinity,
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
    required bool stretchButtons,
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
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
            ),
          ),
          child: SizedBox(
            width: stretchButtons ? double.infinity : _compactButtonWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (buttons[index].icon != null) ...[
                  Icon(buttons[index].icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  buttons[index].label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (index < buttons.length - 1) const SizedBox(height: _regularSpacing),
      ],
    ];
  }
}
