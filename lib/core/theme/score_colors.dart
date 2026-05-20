import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Retorna a cor correta para exibir uma nota (score), respeitando o
/// tema atual (light/dark) para garantir contraste adequado (WCAG AA).
///
/// Uso:
/// ```dart
/// Text('$nota', style: TextStyle(color: ScoreColors.of(context, nota, 10)));
/// ```
abstract final class ScoreColors {
  /// Retorna a cor do texto/ícone para [nota] de um máximo de [max].
  ///
  /// Thresholds:
  ///   - ≥ 70% → verde (aprovado)
  ///   - ≥ 50% → laranja (recuperação)
  ///   - < 50% → vermelho (reprovado)
  static Color of(BuildContext context, double nota, double max) {
    final pct = max > 0 ? nota / max : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (pct >= 0.7) {
      return isDark ? AppColors.scoreGreenDark : AppColors.scoreGreenLight;
    }
    if (pct >= 0.5) {
      return isDark ? AppColors.scoreOrangeDark : AppColors.scoreOrangeLight;
    }
    return isDark ? AppColors.scoreRedDark : AppColors.scoreRedLight;
  }
}
