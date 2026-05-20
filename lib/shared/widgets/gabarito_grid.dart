import 'package:flutter/material.dart';

/// Widget de grid interativo para preenchimento e visualização de gabarito.
///
/// Cada linha representa uma questão; as colunas representam as alternativas A–E.
///
/// Parâmetros:
/// - [totalQuestoes]: número de questões da avaliação.
/// - [respostas]: lista de alternativas selecionadas pelo aluno (null = não respondida).
///   O índice corresponde ao número da questão (0-based).
/// - [onSelect]: callback disparado quando o aluno toca em uma alternativa.
///   Recebe a questão (0-based) e a alternativa como String.
///   Ignorado quando [readOnly] for true.
/// - [readOnly]: desabilita seleção; útil na tela de resultado.
/// - [gabarito]: lista com as respostas corretas (mesmo tamanho de [respostas]).
///   Quando fornecido em modo [readOnly], coloriza acertos em verde e erros em vermelho.
/// - [professorGabaritoMode]: quando true, exibe as respostas do gabarito em
///   azül sólido (primary) — usado na tela do gabarito do professor.
class GabaritoGrid extends StatelessWidget {
  const GabaritoGrid({
    super.key,
    required this.totalQuestoes,
    required this.respostas,
    required this.onSelect,
    this.readOnly = false,
    this.gabarito,
    this.professorGabaritoMode = false,
    this.shrinkWrap = false,
  });

  final int totalQuestoes;
  final List<String?> respostas;
  final void Function(int questao, String alternativa) onSelect;
  final bool readOnly;
  final List<String>? gabarito;
  final bool professorGabaritoMode;

  /// Quando [true], o ListView interno usa shrinkWrap + NeverScrollableScrollPhysics.
  /// Use sempre que o GabaritoGrid for filho de outro scroll view (ex: ListView).
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shrinkWrap: shrinkWrap,
      physics:
          shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: totalQuestoes,
      itemBuilder: (context, index) => _QuestaoRow(
        numero: index + 1,
        respostaSelecionada: index < respostas.length ? respostas[index] : null,
        respostaCorreta:
            (gabarito != null && index < gabarito!.length) ? gabarito![index] : null,
        readOnly: readOnly,
        professorGabaritoMode: professorGabaritoMode,
        onSelect: (alt) => onSelect(index, alt),
      ),
    );
  }
}

class _QuestaoRow extends StatelessWidget {
  const _QuestaoRow({
    required this.numero,
    required this.respostaSelecionada,
    required this.onSelect,
    this.respostaCorreta,
    this.readOnly = false,
    this.professorGabaritoMode = false,
  });

  final int numero;
  final String? respostaSelecionada;
  final String? respostaCorreta;
  final bool readOnly;
  final bool professorGabaritoMode;
  final void Function(String alternativa) onSelect;

  static const _alternativas = ['A', 'B', 'C', 'D', 'E'];

  Color? _buttonColor(BuildContext context, String alt) {
    final theme = Theme.of(context);
    if (professorGabaritoMode) {
      // Modo gabarito do professor: resposta correta em azul sólido.
      if (alt == respostaCorreta) return theme.colorScheme.primary;
      return null;
    }
    if (!readOnly || respostaCorreta == null) return null;

    // Aluno respondeu esta célula.
    if (alt == respostaSelecionada) {
      return alt == respostaCorreta
          ? Colors.green.shade600 // acerto
          : theme.colorScheme.error; // erro
    }
    // Aluno errou: mostra a célula correta em verde como referência.
    if (respostaSelecionada != null && alt == respostaCorreta) {
      return Colors.green.shade600;
    }
    // Aluno não respondeu: não destaca nenhuma célula (evita confundir
    // gabarito exibido com resposta correta do aluno).
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$numero',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(140),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _alternativas.map((alt) {
                final isSelected = respostaSelecionada == alt;
                final overrideColor = _buttonColor(context, alt);

                if (readOnly) {
                  return _AltChip(
                    label: alt,
                    selected: respostaSelecionada == alt ||
                        (respostaSelecionada != null &&
                            respostaSelecionada != respostaCorreta &&
                            alt == respostaCorreta),
                    color: overrideColor,
                  );
                }

                return _AltButton(
                  label: alt,
                  selected: professorGabaritoMode
                      ? alt == respostaCorreta
                      : isSelected,
                  onTap: () => onSelect(alt),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AltButton extends StatelessWidget {
  const _AltButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (selected) {
      return FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: const Size(44, 36),
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(44, 36),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
        side: BorderSide(color: theme.colorScheme.outline.withAlpha(120)),
      ),
      child: Text(label),
    );
  }
}

class _AltChip extends StatelessWidget {
  const _AltChip({required this.label, required this.selected, this.color});

  final String label;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = color ??
        (selected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface);
    final fg = color != null
        ? Colors.white
        : (selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface.withAlpha(180));

    return Container(
      width: 44,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(
          color: color ?? theme.colorScheme.outline.withAlpha(80),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: fg,
          fontSize: 13,
        ),
      ),
    );
  }
}
