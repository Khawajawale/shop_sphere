import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onPressed;

  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(text),
          TextButton(
            onPressed: onPressed,
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}