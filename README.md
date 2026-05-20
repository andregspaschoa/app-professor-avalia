# Professor Avalia

[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.4-0175C2?logo=dart)](https://dart.dev)
[![Coverage](https://img.shields.io/badge/coverage-71.6%25-brightgreen)](#testes)
[![License](https://img.shields.io/badge/license-All%20rights%20reserved-red)](LICENSE)

> App Flutter para professores corrigirem provas de forma rápida — wizard step-by-step, scanner de cartão resposta (fake MVP) e dashboard com estatísticas.

---

## Índice

- [Funcionalidades](#funcionalidades)
- [Stack Técnica](#stack-técnica)
- [Arquitetura](#arquitetura)
- [Decisões de Design](#decisões-de-design)
- [Setup e Execução](#setup-e-execução)
- [Credenciais de Demo](#credenciais-de-demo)
- [CI/CD](#cicd)
- [Licença](#licença)

---

## Funcionalidades

| Feature | Status |
|---|---|
| Splash nativa + animada | ✅ |
| Login fake com sessão persistida | ✅ |
| Wizard: Escola → Turma → Avaliação → Gabarito | ✅ |
| Grid de gabarito estilo cartão resposta | ✅ |
| Scanner fake animado | ✅ |
| Resultado com acertos/erros por cor | ✅ |
| Dashboard com métricas e últimas avaliações | ✅ |
| Detalhe de avaliação com lista de alunos | ✅ |
| Detalhe de scan com foto + gabarito read-only | ✅ |
| Histórico de scans (Hive local) | ✅ |
| Flavors `dev` / `prod` (`AppEnvironment`) | ✅ |
| Transições animadas (fade, slide, bottom-sheet) | ✅ |
| Skeleton loader nas listas | ✅ |
| Dark mode | ✅ |
| Cobertura de testes ≥ 70% | ✅ 71.6% |

---

## Stack Técnica

| Categoria | Package |
|---|---|
| State Management | `flutter_riverpod` + `riverpod_annotation` |
| Navegação | `go_router` |
| HTTP Client | `dio` + interceptors |
| Banco local | `hive_flutter` + `flutter_secure_storage` |
| Serialização | `freezed` + `json_serializable` |
| Testes | `flutter_test` + `mocktail` |
| Câmera / Imagens | `camera` + `image_picker` + `cached_network_image` |
| Animações | `flutter_animate` + `lottie` + `shimmer` |
| Fontes | `google_fonts` (Poppins) |
| Ícone | `flutter_launcher_icons` |
| Splash nativa | `flutter_native_splash` |
| Utils | `connectivity_plus` + `permission_handler` + `intl` |

---

## Arquitetura

**MVVM + Feature-first** — separação clara de responsabilidades sem over-engineering (YAGNI).

```
lib/
├── core/               # Infraestrutura compartilhada
│   ├── theme/          # AppColors, AppTypography, AppTheme, ScoreColors
│   ├── error/          # sealed class Failure
│   ├── network/        # DioClient + interceptors
│   ├── storage/        # HiveSetup
│   ├── config/         # AppEnvironment (flavors dev/prod)
│   ├── constants/      # AppConstants
│   └── router/         # AppRouter, AppRoutes, RouteTransitions
├── features/           # Uma pasta por domínio — MVVM
│   ├── auth/           # model/ · auth_repository · auth_viewmodel · login_screen
│   ├── splash/         # splash_screen
│   ├── home/           # dashboard_repository · dashboard_viewmodel · home_screen
│   ├── wizard/         # wizard_viewmodel · wizard_screen
│   ├── escola/         # model/ · escola_repository · escola_viewmodel · escola_screen
│   ├── turma/          # model/ · turma_repository · turma_viewmodel · turma_screen
│   ├── avaliacao/      # model/ · avaliacao_repository · avaliacao_viewmodel · avaliacao_screen
│   ├── gabarito/       # model/ · gabarito_repository · gabarito_viewmodel · gabarito_screen
│   ├── scanner/        # scanner_viewmodel · scanner_screen · resultado_screen
│   └── dashboard/      # avaliacao_detalhe_screen · scan_detail_screen
└── shared/             # Widgets e utilitários reutilizáveis
    ├── widgets/        # EmptyState, ErrorState, GabaritoGrid, SkeletonLoader
    └── utils/          # AppSnackBar
```

Cada feature segue o padrão MVVM — model em subpasta própria para isolar os arquivos gerados pelo Freezed:

```
feature/
├── model/
│   ├── {feature}_model.dart         # M: classe de dados (Freezed)
│   ├── {feature}_model.freezed.dart # gerado — build_runner
│   └── {feature}_model.g.dart       # gerado — build_runner
├── {feature}_repository.dart        # M: fonte de dados (JSON mock → futuramente API)
├── {feature}_viewmodel.dart         # VM: estado + lógica (@riverpod AsyncNotifier)
└── {feature}_screen.dart            # V: UI pura (ConsumerWidget)
```

> A `View` não contém lógica. O `ViewModel` não conhece widgets. O `Repository` não conhece Riverpod. Separação clara sem over-engineering.

O roteamento segue a mesma filosofia — cada responsabilidade em seu próprio arquivo:

```
core/router/
├── app_router.dart        # GoRouter, ShellRoute, redirect, WizardStepObserver
├── app_routes.dart        # AppRoutes — constantes de path e name
└── route_transitions.dart # fadePage, slideRightPage, slideBottomPage
```

---

## Decisões de Design

### Por que Riverpod e não Provider?
Provider e Riverpod são pacotes **distintos e concorrentes** do mesmo autor. Riverpod é a reescrita moderna com type-safety, code generation (`@riverpod`) e suporte a async nativo. Usamos `flutter_riverpod` + `riverpod_annotation`.

### Por que go_router?
O fluxo wizard requer estado preservado entre steps e navegação tipada. `go_router` é a solução oficial do time Flutter, suporta sub-rotas aninhadas e deep linking.

### Por que gabarito com strings ("A","B","C")?
Usar `[1,2,3,4,5]` é ambíguo e gera bugs silenciosos na comparação de respostas. Strings `["A","B","C","D","E"]` são auto-explicativas e diretamente renderizáveis na UI.

### Por que duas camadas de splash?
Native splash (sistema operacional) aparece antes do Flutter carregar — sem tela branca. A `SplashScreen.dart` animada transita suavemente para o login. O usuário percebe uma experiência contínua e profissional.

### Error handling com `sealed class Failure`
Ao invés de `try/catch` genérico nos ViewModels, repositórios retornam tipos de falha explícitos (`NetworkFailure`, `NotFoundFailure`, etc.). Isso torna o tratamento de erros testável e obriga o tratamento em tempo de compilação (Dart exhaustive switch).

---

## Setup e Execução

### Pré-requisitos
- Flutter 3.41.6+
- Dart 3.11.4+
- Android Studio ou Xcode (para simuladores)

### Instalação
```bash
git clone https://github.com/andregspaschoa/app-professor-avalia.git
cd app-professor-avalia
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Rodar
```bash
# Debug (dados mock)
flutter run

# Release
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

### Testes
```bash
flutter test
flutter test --coverage          # gera coverage/lcov.info
```

### Gerar ícones e splash
```bash
# Coloque a arte em assets/icon/icon.png (1024x1024px)
dart run flutter_launcher_icons

# Coloque o logo em assets/splash/logo.png
dart run flutter_native_splash:create
```

---

## Credenciais de Demo

| Campo | Valor |
|---|---|
| E-mail | `professor_alcantara@demo.com` |
| Senha | `teste@1234` |

---

## CI/CD

GitHub Actions executa em cada push/PR para `main` e `develop`:
- `flutter analyze --fatal-infos`
- `flutter test --coverage`
- Upload de cobertura para Codecov

---

## Licença

All rights reserved © 2026 Gabriel
