import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  static const double _logoXAlignment = 0.4;
  static const double _bannerHeight = 160.0;
  static const double _logoHeight = 90.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _bannerHeight,
      color: const Color(0xFFA20202),
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Align(
          alignment: const Alignment(_logoXAlignment, 0.0),
          child: Image.asset(
            'assets/images/croppedlogo.png',
            fit: BoxFit.contain,
            height: _logoHeight,
          ),
        ),
      ),
    );
  }
}
