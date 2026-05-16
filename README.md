# Professor Avalia

![Flutter](https://img.shields.io/badge/Flutter-3.41.6-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11.4-0175C2?logo=dart)
![CI](https://github.com/andregspaschoa/app-professor-avalia/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)

> App Flutter para professores corrigirem provas de forma rápida — wizard step-by-step, scanner de cartão resposta (fake MVP) e dashboard com estatísticas.

---

## Funcionalidades

| Feature | Status |
|---|---|
| Splash nativa + animada | 🔜 |
| Login fake com sessão persistida | 🔜 |
| Wizard: Escola → Turma → Avaliação | 🔜 |
| Grid de gabarito estilo cartão resposta | 🔜 |
| Scanner fake animado | 🔜 |
| Resultado com acertos/erros por cor | 🔜 |
| Dashboard com estatísticas mockadas | 🔜 |
| Histórico de scans (Hive local) | 🔜 |
| Dark mode | 🔜 |

---

## Stack Técnica

| Categoria | Package |
|---|---|
| State Management | `flutter_riverpod` + `riverpod_annotation` |
| Navegação | `go_router` |
| HTTP Client | `dio` + interceptors |
| Banco local | `hive_flutter` |
| Serialização | `freezed` + `json_serializable` |
| Testes | `flutter_test` + `mocktail` |
| Imagens | `image_picker` + `cached_network_image` |
| Animações | `lottie` |
| Fontes | `google_fonts` (Poppins) |
| Ícone | `flutter_launcher_icons` |
| Splash nativa | `flutter_native_splash` |

---

## Arquitetura

**MVVM + Feature-first** com equilíbrio entre clean architecture e YAGNI.

```
lib/
├── core/               # Infraestrutura compartilhada
│   ├── theme/          # AppColors, AppTypography, AppTheme
│   ├── error/          # Failures (sealed class)
│   ├── network/        # DioClient + interceptors
│   ├── storage/        # HiveSetup
│   └── constants/      # AppConstants
├── features/           # Uma pasta por domínio
│   ├── auth/           # Login fake + sessão
│   ├── wizard/         # Orquestra o fluxo step-by-step
│   ├── escola/
│   ├── turma/
│   ├── avaliacao/
│   ├── gabarito/       # Grid de respostas
│   ├── scanner/        # Scanner fake animado
│   └── dashboard/
└── shared/             # Widgets e utilitários reutilizáveis
```

Cada feature segue a estrutura:
```
feature/
├── data/         # Implementação: datasource (JSON mock) + repository impl
├── domain/       # Contratos: models (freezed) + interface do repository
└── presentation/ # UI: screen + ViewModel (Riverpod AsyncNotifier)
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
- Build check

---

## Licença

MIT © 2025 André Paschoa


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
