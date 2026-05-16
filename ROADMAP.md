# Roadmap — Professor Avalia

> Cronograma de desenvolvimento orientado a commits atômicos e entregáveis testáveis.
> Convenção de commits: `feat:`, `fix:`, `test:`, `chore:`, `refactor:`

---

## ✅ Fase 0 — Fundação do Projeto _(concluída)_

| # | Feature | Execução | Commit |
|---|---|---|---|
| 0.1 | Repositório e CI | Criar repo GitHub, `.gitignore`, `.github/workflows/ci.yml` com `flutter analyze` + `flutter test` | `chore: setup inicial do repositório e CI/CD` |
| 0.2 | Estrutura de pastas | Criar `lib/core/`, `lib/features/`, `lib/shared/`, pastas de assets | `chore: estrutura de pastas e pubspec.yaml` |
| 0.3 | Dependências | Adicionar todos os pacotes no `pubspec.yaml`, rodar `flutter pub get`, validar ausência de conflitos | `chore: adicionar dependências do projeto` |
| 0.4 | Core / Theme | Implementar `AppColors`, `AppTypography`, `AppTheme` (light + dark), testar visualmente em `main.dart` | `feat: core theme — AppColors, AppTypography, AppTheme` |
| 0.5 | Core / Error | Implementar `sealed class Failure` com subclasses (Network, NotFound, Auth, Parse, Unexpected, Validation) | `feat: core error — sealed class Failure` |
| 0.6 | Core / Network | Implementar `DioClient` com `_LogInterceptor` e `_ErrorInterceptor` | `feat: core network — DioClient com interceptors` |
| 0.7 | Core / Storage | Implementar `HiveSetup.init()` abrindo boxes `scans` e `session`; `AppConstants` | `feat: core storage — HiveSetup e AppConstants` |
| 0.8 | Shared Widgets | Implementar `EmptyStateWidget` e `ErrorStateWidget` reutilizáveis | `feat: shared widgets — EmptyState e ErrorState` |
| 0.9 | Ícone e Splash nativa | Colocar arte em `assets/icon/`, configurar `flutter_launcher_icons` e `flutter_native_splash`, rodar os generators, testar no emulador Android | `chore: ícone adaptativo e splash nativa (#0D0D2B)` |

---

## ✅ Fase 1 — Splash Animada + Navegação Base _(concluída)_

| # | Feature | Execução | Commit |
|---|---|---|---|
| 1.1 | `SplashScreen` animada | Criar `lib/features/splash/splash_screen.dart` com fade-in + scale do logo usando `AnimationController`. Ao final (1.5s), navegar para `/login`. Testar manualmente no emulador — verificar transição suave da splash nativa para a animada | `feat: splash — SplashScreen animada com fade + scale` |
| 1.2 | `go_router` base | Criar `lib/core/router/app_router.dart` com `GoRouter`; definir rotas `/splash`, `/login`, `/wizard`. Substituir `MaterialApp.home` por `MaterialApp.router`. Testar navegação entre as rotas no emulador | `feat: navigation — go_router com rotas base` |

---

## Fase 2 — Autenticação Fake

| # | Feature | Execução | Commit |
|---|---|---|---|
| 2.1 | `auth_model` | Criar `lib/features/auth/auth_model.dart` com `@freezed` (`ProfessorModel`: id, nome, email, escolaIds, turmaIds). Rodar `build_runner`. Verificar arquivo `.g.dart` e `.freezed.dart` gerados | `feat: auth — ProfessorModel (Freezed)` |
| 2.2 | `auth_repository` | Criar `lib/features/auth/auth_repository.dart`. Implementar `login(email, senha)` que lê `assets/mock/professores.json`, valida credenciais e retorna `Result<ProfessorModel, Failure>`. Testar com `professor_alcantara@demo.com` / `teste@1234` | `feat: auth — AuthRepository com mock JSON` |
| 2.3 | `auth_viewmodel` | Criar `lib/features/auth/auth_viewmodel.dart` com `@riverpod AsyncNotifier`. Estado: `unauthenticated | loading | authenticated | error`. Persistir `professor_id` no `FlutterSecureStorage`. Testar unitariamente com `mocktail` | `feat: auth — AuthViewModel (Riverpod AsyncNotifier)` |
| 2.4 | `LoginScreen` | Criar `lib/features/auth/login_screen.dart`. Layout: logo, campo e-mail, campo senha (toggle visibilidade), botão "Entrar" grande. Loading fake 800ms. Redirecionar para `/wizard` ao autenticar. Testar manualmente no emulador — dark mode e teclado | `feat: auth — LoginScreen com UX de loading` |
| 2.5 | Sessão persistida | No `app_router.dart`, adicionar `redirect` para verificar se já existe sessão no `FlutterSecureStorage`. Se existir, pular login e ir direto ao wizard. Testar hot restart com e sem sessão salva | `feat: auth — redirect automático por sessão persistida` |
| 2.6 | Testes unitários Auth | Escrever `test/unit/auth_repository_test.dart` e `test/unit/auth_viewmodel_test.dart` com `mocktail`. Cobrir fluxo de sucesso, credenciais inválidas e falha de parse | `test: auth — repositório e viewmodel` |

---

## Fase 3 — Wizard: Escola → Turma → Avaliação

| # | Feature | Execução | Commit |
|---|---|---|---|
| 3.1 | `WizardViewModel` | Criar `lib/features/wizard/wizard_viewmodel.dart` com `@riverpod Notifier`. Gerenciar estado global do wizard: `escolaId`, `turmaId`, `avaliacaoId`, `step` (1–5). Expor métodos `setEscola`, `setTurma`, `setAvaliacao`, `reset` | `feat: wizard — WizardViewModel com estado global` |
| 3.2 | `WizardScreen` (shell) | Criar `lib/features/wizard/wizard_screen.dart` como `ShellRoute` do go_router. Exibir barra de progresso de steps no topo (step 1/5, 2/5…). Testar navegação forward/backward entre sub-rotas | `feat: wizard — WizardScreen shell com progress indicator` |
| 3.3 | `escola_model` + `escola_repository` | Criar `EscolaModel` (freezed) e `EscolaRepository` lendo `assets/mock/escolas.json`. Filtrar pelo `professor.escolaIds`. Testar unitariamente | `feat: escola — model, repository e filtro por professor` |
| 3.4 | `EscolaViewModel` + `EscolaScreen` | Criar viewmodel com `@riverpod` e tela de seleção com cards grandes (nome da escola, município, UF). Loading state, empty state e error state. Ao selecionar, chamar `WizardViewModel.setEscola` e navegar para próximo step | `feat: escola — EscolaScreen com cards grandes` |
| 3.5 | `turma_model` + `turma_repository` | Criar `TurmaModel` (freezed) e `TurmaRepository`. Filtrar turmas pelo `escolaId` selecionado no wizard **e** pelas turmas do professor. Testar filtro com múltiplos cenários | `feat: turma — model, repository e duplo filtro` |
| 3.6 | `TurmaViewModel` + `TurmaScreen` | Card exibe série, turno e total de alunos. Mesmo padrão de estados. Ao selecionar, atualizar wizard e navegar | `feat: turma — TurmaScreen com dados da turma` |
| 3.7 | `avaliacao_model` + `avaliacao_repository` | Criar `AvaliacaoModel` (freezed: disciplina, bimestre, tipo, status, gabarito `List<String>`). Filtrar por `turmaId`. Testar parse do gabarito (strings A–E) | `feat: avaliacao — model, repository e gabarito List<String>` |
| 3.8 | `AvaliacaoViewModel` + `AvaliacaoScreen` | Card exibe disciplina, bimestre, status (chip colorido). Ao selecionar, navegar para tela de detalhes da avaliação | `feat: avaliacao — AvaliacaoScreen com status chip` |
| 3.9 | Tela de Detalhes da Avaliação | Criar `AvaliacaoDetailScreen` com resumo (escola, turma, avaliação selecionadas), botão grande "Inserir Respostas" e botão secundário "Ver Dashboard". Testar fluxo completo escola → turma → avaliação → detalhe | `feat: avaliacao — AvaliacaoDetailScreen com resumo do wizard` |
| 3.10 | Testes unitários Wizard | Escrever testes para `WizardViewModel`, `EscolaRepository`, `TurmaRepository`, `AvaliacaoRepository`. Cobrir filtros e transições de estado | `test: wizard — repositórios e viewmodels (escola, turma, avaliacao)` |

---

## Fase 4 — Gabarito (Grid Cartão Resposta)

| # | Feature | Execução | Commit |
|---|---|---|---|
| 4.1 | `gabarito_model` | Criar `GabaritoModel` (freezed) e `RespostaAlunoModel` com campo `respostas: List<String?>` (null = não respondida). Testar serialização | `feat: gabarito — GabaritoModel e RespostaAlunoModel (Freezed)` |
| 4.2 | `GabaritoGrid` widget | Criar `lib/shared/widgets/gabarito_grid.dart`. Grid de questões × alternativas (A B C D E). Toque rápido seleciona alternativa com animação de seleção (cor `selectedAnswer`). Toque duplo desfaz. Testar em isolamento com `WidgetTest` | `feat: gabarito — GabaritoGrid widget com seleção rápida` |
| 4.3 | `aluno_model` + `aluno_repository` | Criar `AlunoModel` (freezed: matrícula, nome, dataNasc, ativo) e `AlunoRepository` lendo `assets/mock/alunos.json`, filtrado por `turmaId`. Testar filtro de alunos ativos | `feat: gabarito — AlunoModel e AlunoRepository` |
| 4.4 | `GabaritoViewModel` | Gerenciar lista de alunos, aluno atual, respostas preenchidas. Métodos: `setResposta(questao, alternativa)`, `proximoAluno`, `alunoAnterior`, `isCompleto`. Testar todas as transições | `feat: gabarito — GabaritoViewModel com navegação entre alunos` |
| 4.5 | `GabaritoScreen` | Tela principal: header com nome do aluno e progresso (aluno 3/25), `GabaritoGrid` central, botões "Anterior" / "Próximo" / "Escanear". Testar manualmente fluxo de preenchimento para 3 alunos | `feat: gabarito — GabaritoScreen com navegação entre alunos` |
| 4.6 | Testes widget GabaritoGrid | Cobrir: seleção de alternativa, deselect, navegação entre alunos, indicador de progresso | `test: gabarito — widget GabaritoGrid e GabaritoScreen` |

---

## Fase 5 — Scanner Fake Animado

| # | Feature | Execução | Commit |
|---|---|---|---|
| 5.1 | `ScannerScreen` (câmera overlay) | Criar `lib/features/scanner/scanner_screen.dart`. Layout: fundo escuro, viewfinder animado (bordas piscantes com `AnimatedContainer`), botão FAB "Escanear". Testar animação no emulador | `feat: scanner — ScannerScreen com overlay animado` |
| 5.2 | Fluxo de scan fake | Ao pressionar FAB: (1) `image_picker` abre câmera/galeria, (2) overlay "Processando respostas..." com `CircularProgressIndicator` por 2.5s, (3) gera respostas aleatórias (simulando OCR), (4) navega para resultado. Testar fluxo completo | `feat: scanner — fluxo fake com image_picker e delay simulado` |
| 5.3 | `scanner_viewmodel` | Gerenciar estado: `idle | scanning | processing | done | error`. Expor `scanResult` com respostas geradas. Testar transições de estado com `mocktail` | `feat: scanner — ScannerViewModel com estados de scan` |
| 5.4 | `ResultadoScreen` | Tela pós-scan: score grande no topo (ex: "8.0"), grid de gabarito com acertos em verde / erros em vermelho, botão "Salvar" e "Refazer". Testar renderização com dados mockados | `feat: scanner — ResultadoScreen com score e gabarito colorido` |
| 5.5 | Salvar scan no Hive | Ao confirmar resultado, salvar `Map<String, dynamic>` no box `scans` (aluno, nota, respostas, imagePath, turmaId, avaliacaoId, data). Testar persistência e leitura posterior | `feat: scanner — persistência do scan no Hive` |
| 5.6 | Testes unitários Scanner | Cobrir `ScannerViewModel`: transições de estado, geração de respostas fake, cálculo de nota | `test: scanner — ScannerViewModel` |

---

## Fase 6 — Dashboard com Estatísticas

| # | Feature | Execução | Commit |
|---|---|---|---|
| 6.1 | `dashboard_repository` | Criar `DashboardRepository`. Calcular a partir dos dados do Hive: total corrigidos hoje, média da turma, questão com mais erros, quantidade pendente (alunos da turma sem scan). Testar cálculos com dados mockados | `feat: dashboard — DashboardRepository com métricas do Hive` |
| 6.2 | `DashboardViewModel` | `@riverpod AsyncNotifier` lendo `DashboardRepository`. Expor `DashboardStats` (freezed). Testar com cenário zero scans e com scans existentes | `feat: dashboard — DashboardViewModel e DashboardStats` |
| 6.3 | `DashboardScreen` — cards de stats | Implementar tela com 4 cards de métricas (total corrigidos, média, questão problemática, pendentes). Layout responsivo com `GridView`. Testar dark mode | `feat: dashboard — DashboardScreen com cards de métricas` |
| 6.4 | Histórico de scans | Seção "Últimos scans" na `DashboardScreen`: `ListView` de cards com nome do aluno, nota (chip colorido) e data. Tap abre `HistoricoDetalheScreen` com foto do cartão e gabarito corrigido | `feat: dashboard — histórico de scans com HistoricoDetalheScreen` |
| 6.5 | Testes unitários Dashboard | Cobrir `DashboardRepository`: média correta, questão com mais erros, total pendente | `test: dashboard — DashboardRepository métricas` |

---

## Fase 7 — Polimento de UX/UI

| # | Feature | Execução | Commit |
|---|---|---|---|
| 7.1 | Micro animações de transição | Adicionar `CustomTransitionPage` no `go_router` (slide + fade entre steps do wizard). Testar fluxo completo no emulador | `feat: ux — transições animadas no go_router` |
| 7.2 | Loading skeleton | Criar `SkeletonLoader` widget para substituir `CircularProgressIndicator` nos cards de lista. Aplicar em `EscolaScreen`, `TurmaScreen`, `AvaliacaoScreen` | `feat: ux — SkeletonLoader nas telas de lista` |
| 7.3 | Feedback de erros | Implementar `SnackBar` e `AlertDialog` padronizados para `Failure`. Garantir mensagens amigáveis para NetworkFailure, AuthFailure, etc. | `feat: ux — tratamento visual de erros com SnackBar/AlertDialog` |
| 7.4 | Dark mode refinado | Revisar todas as telas em dark mode. Corrigir contraste, sombras e ícones. Testar em emulador com `ThemeMode.dark` forçado | `fix: ux — refinamento visual dark mode em todas as telas` |
| 7.5 | Acessibilidade mínima | Adicionar `Semantics` labels nos botões de ação principal e no `GabaritoGrid`. Testar com TalkBack no Android | `feat: ux — semantics labels para acessibilidade` |

---

## Fase 8 — Flavors e Qualidade Final

| # | Feature | Execução | Commit |
|---|---|---|---|
| 8.1 | Flavors dev/prod | Criar `lib/core/env/app_environment.dart` com `AppFlavor { dev, prod }`. No flavor `dev`: dados mock + logs visíveis. No flavor `prod`: `baseUrl` real + logs desabilitados. Configurar `--dart-define=FLAVOR=dev` nos launch configs do VS Code | `feat: env — flavors dev/prod com AppEnvironment` |
| 8.2 | Cobertura de testes | Rodar `flutter test --coverage`. Abrir `coverage/lcov.info`. Identificar arquivos sem cobertura e escrever testes unitários faltantes. Meta: ≥ 70% de cobertura nas camadas model/repository/viewmodel | `test: cobertura — completar testes unitários críticos` |
| 8.3 | `flutter analyze` zero warnings | Rodar `flutter analyze --fatal-infos`. Corrigir todos os warnings. Garantir que CI passa sem erros | `chore: análise estática — zero warnings no flutter analyze` |
| 8.4 | README final | Atualizar `README.md`: marcar features concluídas com ✅, adicionar GIFs/screenshots do fluxo, documentar variáveis de ambiente e credenciais de demo | `docs: README — features concluídas e screenshots do app` |
| 8.5 | Build de release | Rodar `flutter build apk --release --obfuscate --split-debug-info=build/debug-info`. Validar APK no dispositivo físico. Verificar splash nativa, ícone adaptativo e fluxo completo | `chore: build release — APK validado em dispositivo físico` |
| 8.6 | Tag v1.0.0 | Criar tag `v1.0.0` no Git e push para `main`. Verificar se CI passa no GitHub Actions | `chore: release v1.0.0` |

---

## Resumo das Fases

| Fase | Descrição | Entregável |
|---|---|---|
| ✅ 0 | Fundação | Core completo, ícone, splash nativa |
| 1 | Splash + Roteamento | App navegável ponta a ponta |
| 2 | Auth fake | Login com sessão persistida |
| 3 | Wizard | Fluxo escola → turma → avaliação |
| 4 | Gabarito | Grid de resposta estilo cartão |
| 5 | Scanner | Scanner fake + resultado colorido |
| 6 | Dashboard | Métricas e histórico de scans |
| 7 | Polimento UX | Animações, skeleton, dark mode |
| 8 | Qualidade e Release | Flavors, testes, build APK |
