import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const CustomAlertDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: const BorderSide(),
      ),
      contentPadding: const EdgeInsets.only(
        left: 24.0,
        top: 16.0,
        right: 24.0,
        bottom: 16.0,
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
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
