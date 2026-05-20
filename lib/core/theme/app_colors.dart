import 'package:flutter/material.dart';

/// Paleta de cores do Professor Avalia.
/// Sempre use estes tokens — nunca cores hardcoded no código de UI.
abstract final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3A86FF);
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF06D6A0);

  // ── Background ────────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0D0D2B); // Matches splash screen
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16163C);
  static const Color cardDark = Color(0xFF1F1F4E);

  // ── Feedback ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF06D6A0);
  static const Color error = Color(0xFFEF233C);
  static const Color warning = Color(0xFFFFB703);

  // ── Texto ─────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ── Gabarito ──────────────────────────────────────────────────────────────
  static const Color correctAnswer = Color(0xFF06D6A0);
  static const Color wrongAnswer = Color(0xFFEF233C);
  static const Color selectedAnswer = Color(0xFF3A86FF);
  static const Color unselectedAnswer = Color(0xFFE2E8F0);

  // ── Score (nota) — light mode (texto escuro sobre fundo claro ≥4.5:1) ─────
  static const Color scoreGreenLight = Color(0xFF2E7D32); // ~9.6:1 on #FFF
  static const Color scoreOrangeLight = Color(0xFFBF360C); // ~8.5:1 on #FFF
  static const Color scoreRedLight = Color(0xFFC62828); // ~9.1:1 on #FFF

  // ── Score (nota) — dark mode (texto claro sobre fundo escuro ≥4.5:1) ─────
  static const Color scoreGreenDark = Color(0xFFA5D6A7); // ~6.9:1 on cardDark
  static const Color scoreOrangeDark = Color(0xFFFFCC80); // ~9.1:1 on cardDark
  static const Color scoreRedDark = Color(0xFFEF9A9A); // ~5.8:1 on cardDark

  // ── SnackBar ──────────────────────────────────────────────────────────────
  static const Color snackSuccessBg = Color(0xFF1B5E20);
  static const Color snackSuccessFg = Color(0xFFC8E6C9);
  static const Color snackErrorBg = Color(0xFFB71C1C);
  static const Color snackErrorFg = Color(0xFFFFCDD2);
  static const Color snackInfoBg = Color(0xFF0D47A1);
  static const Color snackInfoFg = Color(0xFFBBDEFB);

  // ── Status Chips — light mode ─────────────────────────────────────────────
  static const Color chipSuccessBgLight = Color(0xFFE8F5E9);
  static const Color chipSuccessTextLight = Color(0xFF1B5E20);
  static const Color chipWarningBgLight = Color(0xFFFFF8E1);
  static const Color chipWarningTextLight = Color(0xFFE65100);
  static const Color chipInfoBgLight = Color(0xFFE3F2FD);
  static const Color chipInfoTextLight = Color(0xFF0D47A1);

  // ── Status Chips — dark mode ──────────────────────────────────────────────
  static const Color chipSuccessBgDark = Color(0xFF1B5E20);
  static const Color chipSuccessTextDark = Color(0xFFA5D6A7);
  static const Color chipWarningBgDark = Color(0xFF4E342E);
  static const Color chipWarningTextDark = Color(0xFFFFCC80);
  static const Color chipInfoBgDark = Color(0xFF1A237E);
  static const Color chipInfoTextDark = Color(0xFF90CAF9);
}
