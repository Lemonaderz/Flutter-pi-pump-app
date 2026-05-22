import 'package:flutter/material.dart';

class AppMenuButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const AppMenuButton({
    super.key, 
    required this.label, 
    required this.imagePath,
    required this.onPressed,
    this.buttonHeight,
  });

  static const double _buttonWidth = 260.0;
  static const double _minButtonHeight = 52.0;
  static const double _maxButtonHeight = 180.0;
  static const double _iconHeightFactor = 0.55;
  static const double _iconMinSize = 30.0;
  static const double _iconMaxSize = 92.0;
  static const double _labelTopFactor = 0.75;

  final double? buttonHeight;

  @override
  Widget build(BuildContext context) {
    final resolvedButtonHeight = (buttonHeight ?? MediaQuery.of(context).size.height / 12).clamp(
      _minButtonHeight,
      _maxButtonHeight,
    );
    final iconSize = (resolvedButtonHeight * _iconHeightFactor).clamp(
      _iconMinSize,
      _iconMaxSize,
    );
    final labelTop = resolvedButtonHeight * _labelTopFactor;

    return SizedBox(
      width: _buttonWidth,
      height: resolvedButtonHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 12,
                child: Image.asset(
                  imagePath,
                  height: iconSize,
                  width: iconSize,
                ),
              ),
              Positioned(
                top: labelTop,
                child: SizedBox(
                  width: _buttonWidth,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: const Color(0xFFA20202),
                      fontWeight: FontWeight.w600,
                      fontSize: (resolvedButtonHeight * 0.20).clamp(14.0, 24.0),
                    ),
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
