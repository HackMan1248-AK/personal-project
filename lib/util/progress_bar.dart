import "package:flutter/material.dart";

class ProgressBar extends StatelessWidget {
  final Text name;
  final double value;
  final double level;

  const ProgressBar({
    super.key,
    required this.name,
    required this.value,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        name,
        SizedBox(height: MediaQuery.of(context).size.height / 50),
        LinearProgressIndicator(value: value, minHeight: 10, year2023: false),
        SizedBox(height: MediaQuery.of(context).size.height / 20),
      ],
    );
  }
}
