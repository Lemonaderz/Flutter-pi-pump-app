import 'dart:math' as math;

import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  static const double _bannerHeight = 160.0;
  static const double _logoHeight = 90.0;
  static const double _minTopPadding = 48.0;
  static const double _topPaddingFactor = 0.08;
  static const double _minHorizontalPadding = 12.0;
  static const double _horizontalPaddingFactor = 0.04;
  static const double _logoXOffsetFactor = 0.06;
  static const double _minLogoXOffset = 16.0;
  static const double _maxLogoXOffset = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _bannerHeight,
      color: const Color(0xFFA20202),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = math.max(
            _minTopPadding,
            constraints.maxHeight * _topPaddingFactor,
          );
          final horizontalPadding = math.max(
            _minHorizontalPadding,
            constraints.maxWidth * _horizontalPaddingFactor,
          );
          final logoXOffset = math.min(
            _maxLogoXOffset,
            math.max(
              _minLogoXOffset,
              constraints.maxWidth * _logoXOffsetFactor,
            ),
          );

          return Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: Transform.translate(
              offset: Offset(logoXOffset, 0),
              child: Image.asset(
                'assets/images/croppedlogo.png',
                fit: BoxFit.contain,
                height: _logoHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}
