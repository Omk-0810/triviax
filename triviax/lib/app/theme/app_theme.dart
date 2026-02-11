import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.indigo,
    textTheme: GoogleFonts.outfitTextTheme(),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.indigo,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
