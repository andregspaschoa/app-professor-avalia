import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/score_colors.dart';
import 'model/avaliacao_recente.dart';

/// Tela de detalhe de uma avaliação agrupada — exibida ao tocar em um card
/// na seção "Últimas avaliações" do dashboard.
///
/// Recebe os dados via [GoRouter] extra (Map desserializado de
/// [AvaliacaoRecente.toMap]) e lista todos os alunos corrigidos naquela
/// avaliação. Tocar em um aluno abre [AppRoutes.scanDetail].
class AvaliacaoDetalheScreen extends StatelessWidget {
  const AvaliacaoDetalheScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final avaliacao = AvaliacaoRecente.fromMap(data);

    return Scaffold(
      appBar: AppBar(title: Text(avaliacao.avaliacaoTitulo)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AvaliacaoHeader(avaliacao: avaliacao),
          Expanded(
            child: avaliacao.scans.isEmpty
                ? const Center(child: Text('Nenhum aluno corrigido.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: avaliacao.scans.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _AlunoScanCard(scan: avaliacao.scans[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _AvaliacaoHeader extends StatelessWidget {
  const _AvaliacaoHeader({required this.avaliacao});

  final AvaliacaoRecente avaliacao;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = avaliacao.mediaGeral;
    final mediaColor = ScoreColors.of(context, media, 10.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Escola
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 15,
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  avaliacao.escolaNome,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Turma
          Row(
            children: [
              Icon(
                Icons.class_outlined,
                size: 15,
                color: theme.colorScheme.onSurface.withAlpha(140),
              ),
              const SizedBox(width: 6),
              Text(avaliacao.turmaNome, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          // Chips de stats
          Row(
            children: [
              _StatChip(
                icon: Icons.people_outline_rounded,
                label: '${avaliacao.totalAlunos} alunos',
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.bar_chart_rounded,
                label: 'Média ${media.toStringAsFixed(1)}',
                color: mediaColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: c,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card de aluno ─────────────────────────────────────────────────────────────

class _AlunoScanCard extends StatelessWidget {
  const _AlunoScanCard({required this.scan});

  final Map<String, dynamic> scan;

  @override
  Widget build(BuildContext context) {
    final nome = scan['aluno_nome']?.toString() ?? 'Aluno';
    final nota = (scan['nota_calculada'] as num?)?.toDouble() ?? 0.0;
    final notaMax = (scan['nota_maxima'] as num?)?.toDouble() ?? 10.0;
    final acertos = (scan['acertos'] as num?)?.toInt() ?? 0;
    final total = (scan['total_questoes'] as num?)?.toInt() ?? 0;
    final origem = scan['origem']?.toString() ?? '';
    final createdAt = scan['created_at']?.toString() ?? '';
    final date = DateTime.tryParse(createdAt);
    final dateLabel = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        : '';

    final notaColor = ScoreColors.of(context, nota, notaMax);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: () => context.push(AppRoutes.scanDetail, extra: scan),
        leading: CircleAvatar(
          backgroundColor: notaColor.withAlpha(30),
          child: Text(
            nota.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: notaColor,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(nome),
        subtitle: Text(
          '$acertos/$total acertos${dateLabel.isNotEmpty ? ' · $dateLabel' : ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (origem.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: origem == 'scanner'
                      ? AppColors.primary.withAlpha(30)
                      : AppColors.warning.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  origem,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: origem == 'scanner'
                        ? AppColors.primary
                        : AppColors.warning,
                  ),
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
