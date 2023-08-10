import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color secondaryText = const Color.fromARGB(255, 154, 160, 165);
Color primaryColor = const Color.fromARGB(255, 30, 203, 92);
Color redDiss = const Color.fromARGB(255, 204, 67, 67);
Color greyDark = const Color.fromARGB(255, 44, 42, 42);

ThemeData themedataDark = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  errorColor: redDiss,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(color: Colors.black),
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 14,
        fontFamily:
            GoogleFonts.archivoBlack(textStyle: const TextStyle()).fontFamily),
    headlineMedium: TextStyle(
        fontSize: 20,
        fontFamily:
            GoogleFonts.archivoBlack(textStyle: const TextStyle()).fontFamily),
    headlineSmall: TextStyle(
        fontSize: 15,
        fontFamily: GoogleFonts.inter(
                textStyle: const TextStyle(fontWeight: FontWeight.bold))
            .fontFamily),
    displaySmall: TextStyle(
        fontSize: 14,
        color: primaryColor,
        fontFamily:
            GoogleFonts.archivoBlack(textStyle: const TextStyle()).fontFamily),
    displayMedium: TextStyle(
        fontSize: 15,
        color: secondaryText,
        fontFamily: GoogleFonts.inter(textStyle: const TextStyle()).fontFamily),
    titleLarge: TextStyle(
        fontSize: 20,
        fontFamily: GoogleFonts.inter(textStyle: const TextStyle()).fontFamily),
    titleMedium: TextStyle(
        fontSize: 20,
        color: secondaryText,
        fontFamily: GoogleFonts.inter(textStyle: const TextStyle()).fontFamily),
  ),
);
