import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> glass = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 30,
      spreadRadius: 2,
      offset: const Offset(0, 15),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: Colors.deepPurple.withValues(alpha: 0.25),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
  ];
}