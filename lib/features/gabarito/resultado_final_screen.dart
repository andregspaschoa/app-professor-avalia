import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/score_colors.dart';
import '../../shared/utils/app_snack_bar.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';
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
                onPressed: () async {
                  // Persiste alunos corrigidos manualmente (não salvos via scanner).
                  await _salvarManuais(
                    gabState: gabState,
                    wizardState: wizardState,
                    gabarito: gabarito,
                    pesoPorQuestao: pesoPorQuestao,
                    notaMaxima: notaMaxima,
                  );
                  if (!context.mounted) return;
                  // Captura o messenger antes de navegar — ele vive acima do
                  // router e persiste após context.go().
                  final messenger = ScaffoldMessenger.of(context);
                  context.go(AppRoutes.home);
                  ref.read(dashboardViewModelProvider.notifier).refresh();
                  messenger.showSnackBar(
                    AppSnackBar.buildSuccess('Resultados salvos com sucesso!'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Persiste no Hive as correções dos alunos que foram feitas manualmente
/// (não passaram pelo scanner + "Salvar"). Identifica pelo [GabaritoState.savedAlunoIds].
Future<void> _salvarManuais({
  required GabaritoState gabState,
  required WizardState wizardState,
  required List<String> gabarito,
  required double pesoPorQuestao,
  required double notaMaxima,
}) async {
  final unsaved =
      gabState.alunos.where((a) => !gabState.savedAlunoIds.contains(a.id));
  if (unsaved.isEmpty) return;

  try {
    final box = Hive.box<dynamic>(AppConstants.hiveBoxScans);
    for (final aluno in unsaved) {
      final respostas = gabState.respostas[aluno.id] ?? [];
      int acertos = 0;
      final limit =
          respostas.length < gabarito.length ? respostas.length : gabarito.length;
      for (var i = 0; i < limit; i++) {
        if (respostas[i] != null && respostas[i] == gabarito[i]) acertos++;
      }
      await box.add({
        'aluno_id': aluno.id,
        'aluno_nome': aluno.nome,
        'avaliacao_id': wizardState.avaliacaoId,
        'avaliacao_titulo': wizardState.avaliacaoTitulo,
        'turma_id': wizardState.turmaId,
        'turma_nome': wizardState.turmaNome,
        'escola_id': wizardState.escolaId,
        'escola_nome': wizardState.escolaNome,
        'respostas_aluno': respostas,
        'gabarito': gabarito,
        'acertos': acertos,
        'nota_calculada': acertos * pesoPorQuestao,
        'nota_maxima': notaMaxima,
        'total_questoes': gabarito.length,
        'image_path': null,
        'status': 'corrigida',
        'origem': 'manual',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  } catch (_) {
    // Hive inacessível (ex.: ambiente de teste) — ignora silenciosamente.
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

  Color _mediaColor(BuildContext context) =>
      ScoreColors.of(context, media, notaMaxima);

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
                color: _mediaColor(context),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
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
                color: color.withAlpha(200),
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

  Color _chipColor(BuildContext context) =>
      ScoreColors.of(context, resultado.nota, resultado.notaMaxima);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _chipColor(context);
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
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            resultado.nota.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
