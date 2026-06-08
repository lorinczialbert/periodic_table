import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Background palette ──────────────────────────────────────────────────────
  static const Color bgDark     = Color(0xFF07090F);
  static const Color bgSurface  = Color(0xFF0F1320);
  static const Color bgCard     = Color(0xFF161C2E);
  static const Color bgElevated = Color(0xFF1E2540);

  // ── Text palette ─────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFEAEEFF);
  static const Color textSecondary = Color(0xFF8891AC);
  static const Color textTertiary  = Color(0xFF4A5270);

  // ── Accent ───────────────────────────────────────────────────────────────────
  static const Color accentCyan   = Color(0xFF00D4FF);
  static const Color accentPurple = Color(0xFF7C6AFF);

  // ── Category colours (vivid, dark-background friendly) ───────────────────────
  static const Color catAlkali        = Color(0xFFFF6B6B);
  static const Color catAlkalineEarth = Color(0xFFFF9F43);
  static const Color catTransition    = Color(0xFF339AF0);
  static const Color catPostTransition= Color(0xFF51CF66);
  static const Color catMetalloid     = Color(0xFFFFD43B);
  static const Color catNonmetal      = Color(0xFF74C0FC);
  static const Color catHalogen       = Color(0xFFCC5DE8);
  static const Color catNobleGas      = Color(0xFF20C997);
  static const Color catLanthanide    = Color(0xFFF783AC);
  static const Color catActinide      = Color(0xFFFF922B);
  static const Color catUnknown       = Color(0xFF868E96);

  // ── Theme ────────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary:   accentCyan,
        secondary: accentPurple,
        surface:   bgCard,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgSurface,
        selectedItemColor: accentCyan,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: accentCyan,
        unselectedLabelColor: textSecondary,
        indicatorColor: accentCyan,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textTertiary),
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).copyWith(
        bodyMedium: GoogleFonts.spaceGrotesk(color: textPrimary),
        bodySmall:  GoogleFonts.spaceGrotesk(color: textSecondary),
      ),
      dividerColor: bgElevated,
    );
  }
}
