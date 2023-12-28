import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      textTheme: const TextTheme(
        bodySmall: TextStyle(),
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
      ).apply(
        fontFamily: GoogleFonts.lato().fontFamily,
        bodyColor: Colors.black,
        displayColor: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.white,
      //useMaterial3: true,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      primaryColorDark: const Color.fromARGB(255, 1, 89, 100),
      textTheme: const TextTheme(
        bodySmall: TextStyle(),
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
      ).apply(
        fontFamily: GoogleFonts.lato().fontFamily,
        bodyColor: Colors.white,
        displayColor: const Color.fromARGB(255, 1, 89, 100),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 13, 5, 48),
      //useMaterial3: true,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 13, 5, 48),
      ));
}
