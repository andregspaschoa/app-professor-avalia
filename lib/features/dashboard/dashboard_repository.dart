import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'model/avaliacao_recente.dart';
import 'model/dashboard_stats.dart';

/// Repositório que computa métricas a partir dos scans persistidos no Hive.
///
/// Regras de negócio:
/// - [DashboardStats.mediaTurma]: média aritmética das notas calculadas.
/// - [DashboardStats.questaoCritica]: questão (1-based) com maior número de
///   respostas divergentes do gabarito entre todos os scans salvos.
/// - [DashboardStats.scansRecentes]: até 20 registros, do mais recente ao
///   mais antigo, usando o campo `created_at`.
class DashboardRepository {
  const DashboardRepository();

  /// Calcula e retorna as estatísticas do dashboard.
  ///
  /// Não lança exceções — retorna [DashboardStats.empty] se o box estiver
  /// vazio ou inacessível.
  DashboardStats load() {
    try {
      final box = Hive.box<dynamic>(AppConstants.hiveBoxScans);
      if (box.isEmpty) return DashboardStats.empty;

      final allScans = box.values
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      if (allScans.isEmpty) return DashboardStats.empty;

      // ── Média da turma ────────────────────────────────────────────────────
      final notas = allScans
          .map((s) => (s['nota_calculada'] as num?)?.toDouble() ?? 0.0)
          .toList();
      final media = notas.reduce((a, b) => a + b) / notas.length;

      // ── Questão crítica (mais erros) ──────────────────────────────────────
      final errorCounts = <int, int>{};
      for (final scan in allScans) {
        final respostas = (scan['respostas_aluno'] as List?)
            ?.map((e) => e.toString())
            .toList();
        final gabarito = (scan['gabarito'] as List?)
            ?.map((e) => e.toString())
            .toList();

        if (respostas == null || gabarito == null) continue;
        final limit =
            respostas.length < gabarito.length ? respostas.length : gabarito.length;

        for (var i = 0; i < limit; i++) {
          if (respostas[i] != gabarito[i]) {
            errorCounts[i + 1] = (errorCounts[i + 1] ?? 0) + 1;
          }
        }
      }

      int? questaoCritica;
      if (errorCounts.isNotEmpty) {
        questaoCritica =
            errorCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      }

      // ── Scans recentes (últimos 20, mais recente primeiro) ────────────────
      final sorted = List<Map<String, dynamic>>.from(allScans)
        ..sort((a, b) {
          final da = DateTime.tryParse(a['created_at']?.toString() ?? '');
          final db = DateTime.tryParse(b['created_at']?.toString() ?? '');
          if (da == null || db == null) return 0;
          return db.compareTo(da);
        });
      final recentes = sorted.take(20).toList();

      // ── Avaliações recentes (agrupar por avaliacao_id, top 10) ────────────
      final grupos = <String, List<Map<String, dynamic>>>{};
      for (final scan in allScans) {
        final id = scan['avaliacao_id']?.toString() ?? 'desconhecida';
        grupos.putIfAbsent(id, () => []).add(scan);
      }

      final avaliacoes = grupos.entries.map((entry) {
        final scansDoGrupo = List<Map<String, dynamic>>.from(entry.value)
          ..sort((a, b) {
            final da = DateTime.tryParse(a['created_at']?.toString() ?? '');
            final db = DateTime.tryParse(b['created_at']?.toString() ?? '');
            if (da == null || db == null) return 0;
            return db.compareTo(da);
          });
        final primeiro = scansDoGrupo.first;
        final mediaGrupo = scansDoGrupo
                .map((s) => (s['nota_calculada'] as num?)?.toDouble() ?? 0.0)
                .reduce((a, b) => a + b) /
            scansDoGrupo.length;
        return AvaliacaoRecente(
          avaliacaoId: entry.key,
          avaliacaoTitulo:
              primeiro['avaliacao_titulo']?.toString() ?? '?',
          escolaNome: primeiro['escola_nome']?.toString() ?? '?',
          turmaNome: primeiro['turma_nome']?.toString() ?? '?',
          totalAlunos: scansDoGrupo.length,
          mediaGeral: mediaGrupo,
          dataUltimaCorrecao: DateTime.tryParse(
            primeiro['created_at']?.toString() ?? '',
          ),
          scans: scansDoGrupo,
        );
      }).toList()
        ..sort((a, b) {
          if (a.dataUltimaCorrecao == null) return 1;
          if (b.dataUltimaCorrecao == null) return -1;
          return b.dataUltimaCorrecao!.compareTo(a.dataUltimaCorrecao!);
        });

      return DashboardStats(
        totalCorrigidos: allScans.length,
        mediaTurma: media,
        questaoCritica: questaoCritica,
        scansRecentes: recentes,
        avaliacoesRecentes: avaliacoes.take(10).toList(),
      );
    } catch (_) {
      return DashboardStats.empty;
    }
  }
}
