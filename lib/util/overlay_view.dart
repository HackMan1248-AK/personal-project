import 'package:flutter/material.dart';

class BlockOverlay extends StatelessWidget {
  const BlockOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Text(
            "🚫 App is blocked!\nGo back to stay productive.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
