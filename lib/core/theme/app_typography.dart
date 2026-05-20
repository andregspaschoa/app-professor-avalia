import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tipografia do app usando Poppins (Google Fonts).
/// Hierarquia: título 24 / subtítulo 18 / corpo 16 / caption 12.
abstract final class AppTypography {
  static TextTheme get _base => GoogleFonts.poppinsTextTheme();

  static TextTheme get lightTextTheme => _base.copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryLight,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
      );

  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
        displayLarge: lightTextTheme.displayLarge!
            .copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: lightTextTheme.headlineMedium!
            .copyWith(color: AppColors.textPrimaryDark),
        titleLarge: lightTextTheme.titleLarge!
            .copyWith(color: AppColors.textPrimaryDark),
        titleMedium: lightTextTheme.titleMedium!
            .copyWith(color: AppColors.textPrimaryDark),
        titleSmall: lightTextTheme.titleSmall!
            .copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: lightTextTheme.bodyLarge!
            .copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: lightTextTheme.bodyMedium!
            .copyWith(color: AppColors.textSecondaryDark),
        labelSmall: lightTextTheme.labelSmall!
            .copyWith(color: AppColors.textSecondaryDark),
        bodySmall: lightTextTheme.bodySmall!
            .copyWith(color: AppColors.textSecondaryDark),
      );
}
