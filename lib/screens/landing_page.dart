import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pulse_page.dart';
import 'vent_page.dart';
import 'laryng_page.dart';
import '../widgets/app_menu_button.dart';
import '../widgets/top_banner.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Column(
          children: [
            const TopBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 48.0, left: 24.0, right: 24.0),
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 35),
                      AppMenuButton(
                        label: 'Pulse App',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PulsePage()),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      AppMenuButton(
                        label: 'Vent App',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VentPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      AppMenuButton(
                        label: 'Video Laryngoscope',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyLaryngPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
