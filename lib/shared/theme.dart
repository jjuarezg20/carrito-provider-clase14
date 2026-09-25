import 'package:flutter/material.dart';

const Color kNavy = Color(0xFF1F3864);
const Color kAccent = Color(0xFFB03A2E);
const Color kNavySoft = Color(0xFFE7ECF5);
const Color kInk = Color(0xFF202B3C);
const Color kMuted = Color(0xFF68758A);

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
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF7F8FA),
      foregroundColor: kInk,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    dividerColor: const Color(0xFFE7EAF0),
    textTheme: base.textTheme.apply(bodyColor: kInk, displayColor: kInk),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kNavy,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFDDE2EA),
        disabledForegroundColor: const Color(0xFF7B8492),
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE7EAF0)),
      ),
    ),
  );
}
