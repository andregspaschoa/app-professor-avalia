import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Utilitário para exibir SnackBars padronizados (success / error / info).
///
/// Usa o [ScaffoldMessenger] do contexto fornecido — funciona mesmo após
/// navegação, pois o MessengerState vive acima do router na árvore de widgets.
///
/// Uso:
/// ```dart
/// AppSnackBar.showSuccess(context, 'Salvo com sucesso!');
/// AppSnackBar.showError(context, 'Erro ao salvar.');
/// ```
abstract final class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      AppColors.snackSuccessBg,
      AppColors.snackSuccessFg,
      Icons.check_circle_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      AppColors.snackErrorBg,
      AppColors.snackErrorFg,
      Icons.error_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      AppColors.snackInfoBg,
      AppColors.snackInfoFg,
      Icons.info_rounded,
    );
  }

  /// Constrói um [SnackBar] de sucesso sem exibi-lo.
  ///
  /// Útil quando é preciso capturar o [ScaffoldMessengerState] antes de
  /// navegar e exibir a mensagem após a transição de tela.
  static SnackBar buildSuccess(String message) => _build(
        message,
        AppColors.snackSuccessBg,
        AppColors.snackSuccessFg,
        Icons.check_circle_rounded,
      );

  static SnackBar buildError(String message) => _build(
        message,
        AppColors.snackErrorBg,
        AppColors.snackErrorFg,
        Icons.error_rounded,
      );

  // ── Private ────────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context,
    String message,
    Color bg,
    Color fg,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_build(message, bg, fg, icon));
  }

  static SnackBar _build(
    String message,
    Color bg,
    Color fg,
    IconData icon,
  ) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
