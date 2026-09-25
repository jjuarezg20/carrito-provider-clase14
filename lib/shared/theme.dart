import 'package:flutter/material.dart';

const Color kNavy = Color(0xFF243D75);
const Color kAccent = Color(0xFFA74335);
const Color kCanvas = Color(0xFFF7F8FC);
const Color kBackdrop = Color(0xFFE7EAF0);
const Color kLine = Color(0xFFE2E5EB);
const Color kInk = Color(0xFF252A33);
const Color kMuted = Color(0xFF69717F);
const Color kGreen = Color(0xFF3E7D45);

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kNavy,
      primary: kNavy,
      secondary: kAccent,
      surface: Colors.white,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: kCanvas,
    textTheme: base.textTheme.apply(bodyColor: kInk, displayColor: kInk),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kNavy,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE1E3E8),
        disabledForegroundColor: const Color(0xFF7E8490),
        minimumSize: const Size(48, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
