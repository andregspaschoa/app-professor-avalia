import 'package:flutter/material.dart';

/// Placeholder temporário para o step 1 do wizard (Escola).
///
/// Será substituído pela [EscolaScreen] real na feature 3.4.
/// Mantido aqui para permitir teste de navegação do ShellRoute antes
/// da EscolaScreen estar disponível.
class EscolaPlaceholderScreen extends StatelessWidget {
  const EscolaPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded, size: 56),
          SizedBox(height: 16),
          Text('Escola — step 1'),
          SizedBox(height: 8),
          Text('EscolaScreen será implementada na feature 3.4'),
        ],
      ),
    );
  }
}
