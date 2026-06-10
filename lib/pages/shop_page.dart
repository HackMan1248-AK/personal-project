import "package:flutter/material.dart";
import "package:ClassViz/util/bottom_app_bar.dart";

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop Page")),
      bottomNavigationBar: myAppBar().bottomAppBar(context),
    );
  }
}
