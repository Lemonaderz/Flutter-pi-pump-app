import 'package:flutter/material.dart';

class AppMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppMenuButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
