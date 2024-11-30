import 'package:flutter/material.dart';

Widget wrapWithPadding({required Widget child, double verticalPadding = 8.0}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: verticalPadding),
    child: child,
  );
}