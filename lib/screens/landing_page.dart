import 'package:flutter/material.dart';
import 'pulse_page.dart';
import 'vent_page.dart';
import 'laryng_page.dart';
import '../widgets/app_menu_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
          children: [
            Column(
              children: [
                Image.asset('assets/images/croppedlogo.png', fit: BoxFit.cover),
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
    );
  }
}
