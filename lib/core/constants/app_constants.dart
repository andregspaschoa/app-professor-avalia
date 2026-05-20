// ignore_for_file: constant_identifier_names

/// Constantes globais do aplicativo.
/// Valores de ambiente (base_url, flavor) devem vir de AppEnvironment.
abstract final class AppConstants {
  // ── Hive box names ────────────────────────────────────────────────────────
  static const String hiveBoxScans = 'scans';
  static const String hiveBoxSession = 'session';

  // ── Secure storage keys ──────────────────────────────────────────────────
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyProfessorId = 'professor_id';

  // ── Mock / delays ─────────────────────────────────────────────────────────
  static const Duration fakeNetworkDelay = Duration(milliseconds: 800);
  static const Duration fakeScannerDelay = Duration(milliseconds: 2500);

  // ── Gabarito ──────────────────────────────────────────────────────────────
  static const List<String> alternativas = ['A', 'B', 'C', 'D', 'E'];
}
