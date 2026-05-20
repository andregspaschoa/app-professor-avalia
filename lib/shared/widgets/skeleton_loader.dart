import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loader genérico para listas de cards.
///
/// Uso — substitua apenas o branch `loading:` nos widgets `AsyncValue.when`:
/// ```dart
/// loading: () => const SkeletonListView(),
/// ```
///
/// OCP: apenas o branch de carregamento é substituído; os branches de dados
/// e erro permanecem intocados.
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}

/// Um único item placeholder que imita a estrutura de um ListTile com chip.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF2D2D4A) : const Color(0xFFE0E0E0);
    final highlightColor =
        isDark ? const Color(0xFF4A4A72) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: _SkeletonCardBody(fillColor: baseColor),
    );
  }
}

class _SkeletonCardBody extends StatelessWidget {
  const _SkeletonCardBody({required this.fillColor});

  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: fillColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            // Text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 180,
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chip placeholder
            Container(
              width: 56,
              height: 26,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
