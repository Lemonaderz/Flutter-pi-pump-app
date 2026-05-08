import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.actionsAlignment,
    this.contentPadding,
  });

  final String title;
  final String content;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final EdgeInsetsGeometry? contentPadding;

  static const double _tabletBreakpoint = 600.0;
  static const double _tabletTextScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= _tabletBreakpoint;
    final baseTextScale = mediaQuery.textScaler.scale(14) / 14;
    final dialogTextScale =
        isTablet ? baseTextScale * _tabletTextScale : baseTextScale;

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: TextScaler.linear(dialogTextScale),
      ),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(),
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.only(
              left: 24.0,
              top: 16.0,
              right: 24.0,
              bottom: 16.0,
            ),
        title: Text(title),
        content: Text(content),
        contentTextStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(height: 1.5),
        actionsAlignment: actionsAlignment,
        actions:
            actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const CustomAlertDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: title,
      content: content,
    );
  }
}

extension ShowCustomAlert on BuildContext {
  Future<void> showCustomAlert(String title, String content) {
    return showDialog<void>(
      context: this,
      builder: (context) => CustomAlertDialog(title: title, content: content),
    );
  }
}
