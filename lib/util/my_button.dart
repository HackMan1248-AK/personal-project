import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
      onPressed: onPressed,
      color: colorScheme.primary,
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontFamily: "Press Start 2P",
        ),
      ),
    );
  }
}
