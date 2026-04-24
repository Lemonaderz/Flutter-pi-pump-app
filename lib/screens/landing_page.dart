import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pulse_page.dart';
import 'vent_page.dart';
import 'laryng_page.dart';
import '../widgets/app_menu_button.dart';
import '../widgets/homepage_footer_wave.dart';
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
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          AppMenuButton(
                            label: 'Pulse App',
                            imagePath: 'assets/images/heart-circle.png',
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
                            imagePath: 'assets/images/lungs-circle.png',
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
                            imagePath: 'assets/images/laryng-circle.png',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyLaryngPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const HomepageFooterWave(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
