import 'package:flutter/material.dart';

class HomepageFooterWave extends StatelessWidget {
  const HomepageFooterWave({super.key});

  static const double _footerHeight = 96.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _footerHeight,
      width: double.infinity,
      child: CustomPaint(
        painter: _HomepageFooterWavePainter(),
      ),
    );
  }
}

class _HomepageFooterWavePainter extends CustomPainter {
  static const double _circleX = -0.3;
  static const double _circleY = -5.0;
  static const double _circleWidth = 0.9 * 2.1;
  static const double _circleHeight = 2.8 * 2;
  static const double _secondBandYOffset = 0.22;
  static const double _topPaintExtension = 36.0;

  @override
  void paint(Canvas canvas, Size size) {
    final upperBandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF651111),
          const Color(0xFF841818),
          const Color(0xFFA20202),
        ],
        stops: const [0.0, 0.62, 1.0],
      ).createShader(Offset.zero & size);

    final lowerBandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFC24A43),
          const Color(0xFFAE302B),
          const Color(0xFF8F1A1A),
        ],
        stops: const [0.0, 0.68, 1.0],
      ).createShader(Offset.zero & size);

    final fullRectPath = Path()
      ..addRect(
        Rect.fromLTWH(
          0,
          -_topPaintExtension,
          size.width,
          size.height + _topPaintExtension,
        ),
      );

    // Subtract an off-center oval to get the broad "inverse circle" curve.
    final upperCutout = Path()
      ..addOval(
        Rect.fromLTWH(
          size.width * _circleX,
          size.height * _circleY,
          size.width * _circleWidth,
          size.height * _circleHeight,
        ),
      );

    // A slightly lower secondary cutout creates the softer lower band.
    final lowerCutout = Path()
      ..addOval(
        Rect.fromLTWH(
          size.width * _circleX,
          size.height * (_circleY + _secondBandYOffset),
          size.width * _circleWidth,
          size.height * _circleHeight,
        ),
      );

    final upperBandPath = Path.combine(
      PathOperation.difference,
      fullRectPath,
      upperCutout,
    );

    final lowerBandPath = Path.combine(
      PathOperation.difference,
      fullRectPath,
      lowerCutout,
    );

    canvas.drawPath(upperBandPath, upperBandPaint);
    canvas.drawPath(lowerBandPath, lowerBandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
