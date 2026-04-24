import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/swipe_back_wrapper.dart';
import '../widgets/top_banner.dart';

class MyLaryngPage extends StatefulWidget {
  const MyLaryngPage({super.key});

  @override
  State<MyLaryngPage> createState() => _MyLaryngPageState();
}

class _MyLaryngPageState extends State<MyLaryngPage> {
  late final WebViewController _controller;
  late final MyAppState _appState;
  bool _isAppStateInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.0.1:8081'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAppStateInitialized) {
      _appState = context.read<MyAppState>();
      _isAppStateInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _appState.stopCheck = false;
        _appState.runCheck(_controller);
      });
    }
  }

  @override
  void dispose() {
    _appState.stopCheck = true;
    super.dispose();
  }

  void intiWifi() async {}

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SwipeBackWrapper(
          onBack: () async {
            appState.stopCheck = true;
            Navigator.pop(context);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              const padding = 20.0;
              final maxWidth = constraints.maxWidth - padding * 2;
              final maxHeight = constraints.maxHeight - 150; // estimate for image and buttons
              final squareSize = maxWidth < maxHeight ? maxWidth : maxHeight;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TopBanner(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          width: squareSize,
                          height: squareSize,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                          ),
                          child: WebViewWidget(controller: _controller),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.showCustomAlert(
                              'Connection Guide',
                              'Please connect to the SIM3D Wifi network.\n\nThe Wifi password is: \n\nsim3d123\n\nPlease allow some time for the SIM3D wifi to appear after Laryngoscope startup',
                            );
                          },
                          child: const Text('How to connect'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            appState.stopCheck = true;
                            Navigator.pop(context);
                          },
                          child: const Text('Back'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
