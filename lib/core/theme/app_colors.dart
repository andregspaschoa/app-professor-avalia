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
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);
  static const Color cardDark = Color(0xFF0F3460);

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
}
