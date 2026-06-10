import "package:flutter/material.dart";

void dialogBox(String cred, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        cred,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      alignment: Alignment.center,
    ),
  );
}
