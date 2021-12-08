import 'package:flutter/material.dart';

void showSnackBar(String content, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
