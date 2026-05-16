import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/storage/hive_setup.dart';

/// Entry point do app — responsabilidade única: bootstrap.
///
/// Ordem de inicialização:
///   1. Garantir bindings do Flutter
///   2. Travar orientação em portrait
///   3. Inicializar Hive (banco local)
///   4. Executar o app dentro do ProviderScope
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await HiveSetup.init();

  runApp(
    const ProviderScope(
      child: ProfessorAvaliaApp(),
    ),
  );
}

