import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../shared/widgets/gabarito_grid.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../scanner/scanner_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';

/// Step 5 do wizard — professor confirma/edita o gabarito antes de iniciar
/// a correção aluno a aluno.
///
/// Pré-carrega as respostas de [AvaliacaoModel.gabarito] e permite que o
/// professor altere qualquer resposta tocando nos botões (toggle).
/// Ao confirmar, salva o gabarito em [WizardViewModel] e avança para step 6.
class GabaritoProfessorScreen extends ConsumerStatefulWidget {
  const GabaritoProfessorScreen({super.key});

  @override
  ConsumerState<GabaritoProfessorScreen> createState() =>
      _GabaritoProfessorScreenState();
}

class _GabaritoProfessorScreenState
    extends ConsumerState<GabaritoProfessorScreen> {
  // Gabarito editado localmente pelo professor (inicializado no build).
  late List<String?> _respostas;
  bool _initialized = false;

  void _toggle(int questao, String alternativa) {
    setState(() {
      while (_respostas.length <= questao) {
        _respostas.add(null);
      }
      _respostas[questao] =
          _respostas[questao] == alternativa ? null : alternativa;
    });
  }

  void _confirmar(List<String> respostasCompletas) {
    ref
        .read(wizardViewModelProvider.notifier)
        .setGabarito(respostasCompletas);
    context.push(AppRoutes.wizardGabarito);
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardViewModelProvider);
    final avaliacoes = ref.watch(avaliacaoViewModelProvider).valueOrNull;
    final avaliacao =
        avaliacoes?.where((a) => a.id == wizardState.avaliacaoId).firstOrNull;

    if (avaliacao == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Inicializa _respostas vazio (uma vez).
    if (!_initialized) {
      _respostas = List<String?>.filled(avaliacao.totalQuestoes, null);
      _initialized = true;
    }

    // Aplica resultado de scan quando o professor escaneia o próprio cartão.
    // A guarda step == 5 evita interferência com scans de alunos (step 6)
    // enquanto esta tela ainda está montada na pilha do navigator.
    ref.listen<ScannerState>(scannerViewModelProvider, (prev, next) {
      if (!mounted) return;
      if (next.status == ScannerStatus.done &&
          (next.scanResult?.isNotEmpty ?? false) &&
          ref.read(wizardViewModelProvider).step == 5) {
        final scan = next.scanResult!;
        final total = avaliacao.totalQuestoes;
        setState(() {
          _respostas = List<String?>.generate(
            total, (i) => i < scan.length ? scan[i] : null);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ref.read(scannerViewModelProvider.notifier).reset();
        });
      }
    });

    final totalQuestoes = avaliacao.totalQuestoes;
    final respostasCompletas = List<String>.generate(
      totalQuestoes,
      (i) => i < _respostas.length ? (_respostas[i] ?? '') : '',
    );
    final todasRespondidas = respostasCompletas.every((r) => r.isNotEmpty);

    return Column(
      children: [
        // ── Header informativo ───────────────────────────────────────────────
        _GabaritoHeader(
          titulo: avaliacao.titulo,
          disciplina: avaliacao.disciplina,
          totalQuestoes: totalQuestoes,
        ),
        // ── Grid interativo — professor seleciona as respostas corretas ──────
        Expanded(
          child: GabaritoGrid(
            totalQuestoes: totalQuestoes,
            respostas: _respostas,
            gabarito: respostasCompletas,
            professorGabaritoMode: true,
            onSelect: _toggle,
          ),
        ),
        // ── Botão Confirmar ──────────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.document_scanner_rounded),
                  label: const Text('Escanear cartão do professor'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: () {
                    ref.read(scannerViewModelProvider.notifier).reset();
                    context.push(AppRoutes.scanner);
                  },
                ),
                const SizedBox(height: 8),
                if (!todasRespondidas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Preencha todas as $totalQuestoes questões para continuar.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                FilledButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Confirmar e iniciar correção'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed:
                      todasRespondidas ? () => _confirmar(respostasCompletas) : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _GabaritoHeader extends StatelessWidget {
  const _GabaritoHeader({
    required this.titulo,
    required this.disciplina,
    required this.totalQuestoes,
  });

  final String titulo;
  final String disciplina;
  final int totalQuestoes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.subject_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withAlpha(140)),
              const SizedBox(width: 4),
              Text(
                disciplina,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.format_list_numbered_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withAlpha(140)),
              const SizedBox(width: 4),
              Text(
                '$totalQuestoes questões',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Selecione a resposta correta de cada questão.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
