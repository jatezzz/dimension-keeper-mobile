import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(BuildContext? context, Object error) {
    // Log the error
    print("Error: $error");

    // Show error message
    if (context == null){
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $error")),
    );
  }
}