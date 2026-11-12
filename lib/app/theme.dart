// App-wide Material 3 theme definitions.
// lightTheme and darkTheme are referenced by MaterialApp in app.dart.
// All colours derive from a single seed so the palette is always harmonious.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// The brand seed colour: a deep indigo that works well for both light & dark.
const _seed = Color(0xFF3D5AFE);

TextTheme _buildTextTheme() => TextTheme(
  displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.bold),
  displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.bold),
  titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
  titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
  bodyLarge: GoogleFonts.inter(fontSize: 16),
  bodyMedium: GoogleFonts.inter(fontSize: 14),
  bodySmall: GoogleFonts.inter(fontSize: 12),
  labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
);

/// The light Material 3 theme.
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  ),
  textTheme: _buildTextTheme(),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    backgroundColor: _seed,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _seed,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

/// The dark Material 3 theme, derived from the same seed colour.
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  ),
  textTheme: _buildTextTheme(),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _seed,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
