import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(BuildContext? context, Object error) {
    print("Error: $error");

    if (context == null){
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $error")),
    );
  }
}