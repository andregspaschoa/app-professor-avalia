import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../gabarito/gabarito_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';

/// Tela final do wizard — exibe o resumo das notas de todos os alunos.
///
/// Apresenta uma lista com nome de cada aluno, total de acertos e nota calculada.
/// O botão "Concluir" reseta o wizard e retorna à home.
class ResultadoFinalScreen extends ConsumerWidget {
  const ResultadoFinalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gabState = ref.watch(gabaritoViewModelProvider);
    final wizardState = ref.watch(wizardViewModelProvider);
    final avaliacoes = ref.watch(avaliacaoViewModelProvider).valueOrNull;
    final avaliacao =
        avaliacoes?.where((a) => a.id == wizardState.avaliacaoId).firstOrNull;

    final alunos = gabState.alunos;
    final respostasMap = gabState.respostas;
    final gabarito =
        wizardState.gabaritoConfirmado ?? avaliacao?.gabarito ?? [];
    final pesoPorQuestao = avaliacao?.pesoPorQuestao ?? 1.0;
    final notaMaxima = avaliacao?.notaMaxima ?? 10.0;

    final itens = alunos.map((aluno) {
      final resp = (respostasMap[aluno.id] ?? []);
      int acertos = 0;
      final limit = resp.length < gabarito.length ? resp.length : gabarito.length;
      for (var i = 0; i < limit; i++) {
        if (resp[i] != null && resp[i] == gabarito[i]) acertos++;
      }
      final nota = acertos * pesoPorQuestao;
      return _AlunoResultado(
        nome: aluno.nome,
        acertos: acertos,
        totalQuestoes: gabarito.length,
        nota: nota,
        notaMaxima: notaMaxima,
      );
    }).toList();

    final mediaNotas = itens.isEmpty
        ? 0.0
        : itens.fold(0.0, (sum, i) => sum + i.nota) / itens.length;

    return Scaffold(
      body: Column(
        children: [
          // ── Cabeçalho de resumo ────────────────────────────────────────────
          _ResumoHeader(
            totalAlunos: alunos.length,
            media: mediaNotas,
            notaMaxima: notaMaxima,
            avaliacaoTitulo: avaliacao?.titulo ?? '',
          ),
          // ── Lista de alunos ────────────────────────────────────────────────
          Expanded(
            child: alunos.isEmpty
                ? const Center(child: Text('Nenhum aluno processado.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: itens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, index) =>
                        _AlunoCard(resultado: itens[index]),
                  ),
          ),
          // ── Botão Concluir ─────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                icon: const Icon(Icons.home_rounded),
                label: const Text('Concluir'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () {
                  ref.read(wizardViewModelProvider.notifier).reset();
                  context.go(AppRoutes.home);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Resumo Header ─────────────────────────────────────────────────────────────

class _ResumoHeader extends StatelessWidget {
  const _ResumoHeader({
    required this.totalAlunos,
    required this.media,
    required this.notaMaxima,
    required this.avaliacaoTitulo,
  });

  final int totalAlunos;
  final double media;
  final double notaMaxima;
  final String avaliacaoTitulo;

  Color _mediaColor() {
    final pct = media / notaMaxima;
    if (pct >= 0.7) return Colors.green.shade700;
    if (pct >= 0.5) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avaliacaoTitulo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                avaliacaoTitulo,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          Row(
            children: [
              _StatChip(
                label: 'Alunos corrigidos',
                value: '$totalAlunos',
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              _StatChip(
                label: 'Média da turma',
                value: media.toStringAsFixed(1),
                color: _mediaColor(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Aluno Card ────────────────────────────────────────────────────────────────

class _AlunoResultado {
  const _AlunoResultado({
    required this.nome,
    required this.acertos,
    required this.totalQuestoes,
    required this.nota,
    required this.notaMaxima,
  });

  final String nome;
  final int acertos;
  final int totalQuestoes;
  final double nota;
  final double notaMaxima;
}

class _AlunoCard extends StatelessWidget {
  const _AlunoCard({required this.resultado});

  final _AlunoResultado resultado;

  Color _chipColor() {
    final pct = resultado.nota / resultado.notaMaxima;
    if (pct >= 0.7) return Colors.green.shade600;
    if (pct >= 0.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _chipColor();
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(30),
          child: Text(
            resultado.nome.isNotEmpty ? resultado.nome[0].toUpperCase() : '?',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          resultado.nome,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${resultado.acertos}/${resultado.totalQuestoes} acertos',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(140),
          ),
        ),
        trailing: Chip(
          label: Text(
            resultado.nota.toStringAsFixed(1),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: color.withAlpha(25),
          side: BorderSide(color: color.withAlpha(80)),
        ),
      ),
    );
  }
}
