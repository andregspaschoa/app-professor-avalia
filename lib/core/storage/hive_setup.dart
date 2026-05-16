import 'package:hive_flutter/hive_flutter.dart';

/// Inicialização e acesso centralizado ao Hive.
///
/// Chame [HiveSetup.init()] em main() antes de runApp().
/// Para adicionar novos adapters: registre aqui e gere com hive_generator.
abstract final class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Dados armazenados como Map<String, dynamic> — sem hive_generator.
    // Motivo: hive_generator usa source_gen ^1.0.0, incompatível com
    // freezed que usa source_gen ^2.0.0. Decisão YAGNI para o MVP.
    // Para migrar para adapters tipados: substituir Hive por Isar.
    await _openBoxes();
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<dynamic>('scans');
    await Hive.openBox<dynamic>('session');
  }
}
