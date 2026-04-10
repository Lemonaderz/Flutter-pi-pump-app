import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 50,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          pair,
          style: style,
          semanticsLabel: pair,
        ),
      ),
    );
  }
}