import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores SIRH - Modo Claro
  static const Color primaryColorLight = Color(0xFF9D2449);
  static const Color secondaryColorLight = Color(0xFF6C6E6D);
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color surfaceColorLight = Color(0xFFFFFFFF);
  static const Color cardColorLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF5A5A5A);

  // Colores SIRH - Modo Oscuro (mejorados para mejor contraste)
  static const Color primaryColorDark = Color(0xFFFF4D7A);
  static const Color secondaryColorDark = Color(0xFFB0B0B0);
  static const Color backgroundColorDark = Color(0xFF0A0A0A);
  static const Color surfaceColorDark = Color(0xFF1C1C1C);
  static const Color cardColorDark = Color(0xFF2A2A2A);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFCCCCCC); // Colores comunes
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color infoColor = Color(0xFF29B6F6);

  // Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColorLight,
      scaffoldBackgroundColor: backgroundColorLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColorLight,
        secondary: secondaryColorLight,
        surface: surfaceColorLight,
        error: errorColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
          .copyWith(
            bodyLarge: GoogleFonts.poppins(
                fontSize: 16,
                color: textPrimaryLight,
                fontWeight: FontWeight.w500),
            bodyMedium: GoogleFonts.poppins(
                fontSize: 14,
                color: textPrimaryLight,
                fontWeight: FontWeight.w400),
            bodySmall:
                GoogleFonts.poppins(fontSize: 12, color: textSecondaryLight),
            titleLarge: GoogleFonts.poppins(
                fontSize: 22,
                color: textPrimaryLight,
                fontWeight: FontWeight.w600),
            titleMedium: GoogleFonts.poppins(
                fontSize: 18,
                color: textPrimaryLight,
                fontWeight: FontWeight.w600),
            titleSmall: GoogleFonts.poppins(
                fontSize: 16,
                color: textPrimaryLight,
                fontWeight: FontWeight.w500),
          )
          .apply(
            bodyColor: textPrimaryLight,
            displayColor: textPrimaryLight,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColorLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: primaryColorLight),
      ),
      cardTheme: CardThemeData(
        color: cardColorLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLight,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColorLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.poppins(color: textSecondaryLight),
        hintStyle: GoogleFonts.poppins(color: textSecondaryLight),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColorLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColorLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: textPrimaryLight,
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: surfaceColorLight,
        textColor: textPrimaryLight,
        iconColor: primaryColorLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColorDark,
      scaffoldBackgroundColor: backgroundColorDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColorDark,
        secondary: secondaryColorDark,
        surface: surfaceColorDark,
        error: errorColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            bodyLarge: GoogleFonts.poppins(
                fontSize: 16,
                color: textPrimaryDark,
                fontWeight: FontWeight.w500),
            bodyMedium: GoogleFonts.poppins(
                fontSize: 14,
                color: textPrimaryDark,
                fontWeight: FontWeight.w400),
            bodySmall:
                GoogleFonts.poppins(fontSize: 12, color: textSecondaryDark),
            titleLarge: GoogleFonts.poppins(
                fontSize: 22,
                color: textPrimaryDark,
                fontWeight: FontWeight.w600),
            titleMedium: GoogleFonts.poppins(
                fontSize: 18,
                color: textPrimaryDark,
                fontWeight: FontWeight.w600),
            titleSmall: GoogleFonts.poppins(
                fontSize: 16,
                color: textPrimaryDark,
                fontWeight: FontWeight.w500),
          )
          .apply(
            bodyColor: textPrimaryDark,
            displayColor: textPrimaryDark,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColorDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: primaryColorDark),
      ),
      cardTheme: CardThemeData(
        color: cardColorDark,
        elevation: 8,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorDark,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceColorDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColorDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.poppins(color: textSecondaryDark),
        hintStyle: GoogleFonts.poppins(color: textSecondaryDark),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColorDark,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColorDark,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: textPrimaryDark,
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: surfaceColorDark,
        textColor: textPrimaryDark,
        iconColor: primaryColorDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Colores compatibles con el código existente
  static const Color primaryColor = primaryColorLight;
  static const Color secondaryColor = secondaryColorLight;
  static const Color accentColor = secondaryColorLight;
  static const Color backgroundColor = backgroundColorLight;
  static const Color surfaceColor = surfaceColorLight;
  static const Color cardColor = cardColorLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textSecondaryLight;
}
