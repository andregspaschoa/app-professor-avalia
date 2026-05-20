import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/score_colors.dart';
import '../auth/auth_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';
import '../dashboard/model/avaliacao_recente.dart';
import '../dashboard/model/dashboard_stats.dart';
import '../wizard/wizard_viewmodel.dart';

/// Tela inicial pós-login — Dashboard do professor.
///
/// Exibe métricas calculadas dos scans salvos no Hive e o histórico
/// das últimas correções. Cada card de scan é tappável e abre
/// [AppRoutes.scanDetail] para revisão (cenário de contestação de nota).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final professor = ref.watch(authViewModelProvider).valueOrNull;
    final firstName = professor?.nome.split(' ').first ?? 'Professor';
    final stats = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $firstName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Atualizar dashboard',
            onPressed: () =>
                ref.read(dashboardViewModelProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair da conta',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 4),
          // ── Métricas ────────────────────────────────────────────────────────
          _MetricsSection(stats: stats),
          const SizedBox(height: 24),
          // ── Últimas avaliações ───────────────────────────────────────────────
          _AvaliacaoSection(avaliacoes: stats.avaliacoesRecentes),
          const SizedBox(height: 24),
          // ── Ação principal ──────────────────────────────────────────────────
          FilledButton.icon(
            icon: const Icon(Icons.quiz_rounded),
            label: const Text('Corrigir avaliação'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () {
              ref.read(wizardViewModelProvider.notifier).reset();
              context.push(AppRoutes.wizardEscola);
            },
          ),
        ],
      ),
    );
  }
}

// ── Seção de métricas ─────────────────────────────────────────────────────────

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final mediaFormatada = stats.mediaTurma.toStringAsFixed(1);
    final questao = stats.questaoCritica != null
        ? 'Q${stats.questaoCritica}'
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            _MetricCard(
              icon: Icons.check_circle_outline_rounded,
              label: 'Corrigidos',
              value: '${stats.totalCorrigidos}',
              color: Colors.green,
            ).animate(delay: 0.ms).fadeIn(duration: 250.ms).slideY(begin: 0.15, curve: Curves.easeOut),
            _MetricCard(
              icon: Icons.bar_chart_rounded,
              label: 'Média geral',
              value: stats.totalCorrigidos > 0 ? mediaFormatada : '—',
              color: Colors.blue,
            ).animate(delay: 70.ms).fadeIn(duration: 250.ms).slideY(begin: 0.15, curve: Curves.easeOut),
            _MetricCard(
              icon: Icons.warning_amber_rounded,
              label: 'Questão crítica',
              value: questao,
              color: Colors.orange,
            ).animate(delay: 140.ms).fadeIn(duration: 250.ms).slideY(begin: 0.15, curve: Curves.easeOut),
            _MetricCard(
              icon: Icons.history_rounded,
              label: 'Últimos scans',
              value: '${stats.scansRecentes.length}',
              color: Colors.purple,
            ).animate(delay: 210.ms).fadeIn(duration: 250.ms).slideY(begin: 0.15, curve: Curves.easeOut),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Seção de avaliações recentes ─────────────────────────────────────────────

class _AvaliacaoSection extends StatelessWidget {
  const _AvaliacaoSection({required this.avaliacoes});
  final List<AvaliacaoRecente> avaliacoes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimas avaliações',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (avaliacoes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Nenhuma avaliação corrigida ainda.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(120),
                    ),
              ),
            ),
          )
        else
          ...List.generate(
            avaliacoes.length,
            (i) => _AvaliacaoCard(avaliacao: avaliacoes[i])
                .animate(delay: (100 + 60 * i.clamp(0, 5)).ms)
                .fadeIn(duration: 280.ms)
                .slideY(begin: 0.1, curve: Curves.easeOut),
          ),
      ],
    );
  }
}

class _AvaliacaoCard extends StatelessWidget {
  const _AvaliacaoCard({required this.avaliacao});
  final AvaliacaoRecente avaliacao;

  Color _mediaColor(BuildContext context, double media) =>
      ScoreColors.of(context, media, 10.0);

  @override
  Widget build(BuildContext context) {
    final media = avaliacao.mediaGeral;
    final mediaColor = _mediaColor(context, media);
    final date = avaliacao.dataUltimaCorrecao;
    final dateLabel = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => context.push(
          AppRoutes.avaliacaoDetalhe,
          extra: avaliacao.toMap(),
        ),
        leading: CircleAvatar(
          backgroundColor: mediaColor.withAlpha(30),
          child: Text(
            media.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: mediaColor,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          avaliacao.avaliacaoTitulo,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${avaliacao.escolaNome} · ${avaliacao.turmaNome}\n'
          '${avaliacao.totalAlunos} alunos${dateLabel.isNotEmpty ? ' · $dateLabel' : ''}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
