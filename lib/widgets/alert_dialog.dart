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
  static const Color _buttonRed = Color(0xFFA20202);

  final String title;
  final String content;

  const CustomAlertDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const warningColor = _buttonRed;

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                color: warningColor,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 10, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: warningColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF202124),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF3C4043),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF5F6368),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionAlertDialog extends StatelessWidget {
  static const Color _buttonRed = Color(0xFFA20202);

  const QuestionAlertDialog({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  List<String> _parseOrderedLines() {
    return content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => RegExp(r'^\d+\.\s').hasMatch(line))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderedLines = _parseOrderedLines();

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                color: _buttonRed,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 10, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: const Icon(
                        Icons.help_outline,
                        color: _buttonRed,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF202124),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (orderedLines.isEmpty)
                            Text(
                              content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF3C4043),
                                height: 1.45,
                              ),
                            )
                          else
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final line in orderedLines)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          child: Text(
                                            line.split('.').first + '.',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: const Color(0xFF3C4043),
                                              height: 1.45,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            line.replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: const Color(0xFF3C4043),
                                              height: 1.45,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF5F6368),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningActionDialog extends StatelessWidget {
  static const Color _buttonRed = Color(0xFFA20202);
  static const double _contentIndent = 44;

  const WarningActionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final String content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                color: _buttonRed,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: _buttonRed,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF202124),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                content,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF3C4043),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF5F6368),
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: _contentIndent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: actions,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
