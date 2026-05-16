import 'package:hive_flutter/hive_flutter.dart';

/// Inicialização e acesso centralizado ao Hive.
///
/// Chame [HiveSetup.init()] em main() antes de runApp().
/// Para adicionar novos adapters: registre aqui e gere com hive_generator.
abstract final class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Adapters serão registrados aqui conforme features forem adicionadas.
    // Exemplo: Hive.registerAdapter(ScanResultAdapter());
    await _openBoxes();
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<dynamic>('scans');
    await Hive.openBox<dynamic>('session');
  }
}
