// File: lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeProvider = Provider<ThemeData>((ref) {
  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE87A9B), // Rosa acento/texto principal
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFFFB7C5), // Rosa dominante primario
      onPrimaryContainer: Color(0xFF5A4A66),
      secondary: Color(0xFFFFD6E0), // Rosa secundario
      onSecondary: Color(0xFF5A4A66),
      secondaryContainer: Color(0xFFE6D5F0), // Lavanda
      onSecondaryContainer: Color(0xFF5A4A66),
      surface: Color(0xFFFFF0F5), // Fondos rosa claro
      onSurface: Color(0xFF5A4A66), // Texto oscuro
      error: Color(0xFFFFAAA5), // Rojo/coral suave
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF0F5),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Esquinas redondeadas 16px
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFFFFD6E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFFFFD6E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFFE87A9B), width: 2),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Botones 20px
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.quicksandTextTheme(baseTheme.textTheme),
  );
});

final employeeThemeProvider = Provider<ThemeData>((ref) {
  final baseTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB7C5), // Rosa dominante primario para empleados
      onPrimary: Color(0xFF2D2040),
      primaryContainer: Color(0xFF3D2850),
      onPrimaryContainer: Color(0xFFFFB7C5),
      secondary: Color(0xFFFFD6E0),
      onSecondary: Color(0xFF2D2040),
      surface: Color(0xFF3D2850), // Superficie oscura
      onSurface: Colors.white, // Texto claro
      background: Color(0xFF2D2040), // Fondo oscuro
      onBackground: Color(0xFFFFB7C5),
      error: Color(0xFFFFAAA5),
      onError: Color(0xFF2D2040),
    ),
    scaffoldBackgroundColor: const Color(0xFF2D2040),
    cardTheme: CardThemeData(
      color: const Color(0xFF3D2850),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2040),
      labelStyle: const TextStyle(color: Color(0xFFFFB7C5)),
      hintStyle: TextStyle(color: const Color(0xFFFFB7C5).withOpacity(0.6)),
      prefixIconColor: const Color(0xFFFFB7C5),
      suffixIconColor: const Color(0xFFFFB7C5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFFFFB7C5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFFFFB7C5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFB7C5),
        foregroundColor: const Color(0xFF2D2040),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.quicksandTextTheme(baseTheme.textTheme),
  );
});

