import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/hive_setup.dart';
import 'core/theme/app_theme.dart';

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

class ProfessorAvaliaApp extends StatelessWidget {
  const ProfessorAvaliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professor Avalia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // TODO(nav): substituir por GoRouter na feature de navegacao
      home: const Scaffold(
        body: Center(child: Text('Professor Avalia - setup inicial')),
      ),
    );
  }
}
