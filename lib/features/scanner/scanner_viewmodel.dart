import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';

enum ScannerStatus { idle, scanning, processing, done, error }

class ScannerState {
  const ScannerState({
    this.status = ScannerStatus.idle,
    this.scanResult,
    this.imagePath,
    this.errorMessage,
  });

  final ScannerStatus status;

  /// Alternativas geradas pelo scan fake (A–E), uma por questão.
  final List<String>? scanResult;

  /// Path local da foto capturada — persistido no Hive para revisão posterior.
  final String? imagePath;

  final String? errorMessage;

  ScannerState copyWith({
    ScannerStatus? status,
    List<String>? scanResult,
    String? imagePath,
    String? errorMessage,
  }) {
    return ScannerState(
      status: status ?? this.status,
      scanResult: scanResult ?? this.scanResult,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ScannerViewModel extends Notifier<ScannerState> {
  @override
  ScannerState build() => const ScannerState();

  /// Inicia o fluxo de scan:
  /// 1. Simula processamento por [AppConstants.fakeScannerDelay].
  /// 2. Gera respostas aleatórias de [AppConstants.alternativas].
  /// 3. Persiste [imagePath] no estado para ser salvo no Hive.
  Future<void> scan(int totalQuestoes, {String? imagePath}) async {
    state = state.copyWith(status: ScannerStatus.processing);

    await Future<void>.delayed(AppConstants.fakeScannerDelay);

    final random = Random();
    final respostas = List<String>.generate(
      totalQuestoes,
      (_) => AppConstants.alternativas[
          random.nextInt(AppConstants.alternativas.length)],
    );

    state = state.copyWith(
      status: ScannerStatus.done,
      scanResult: respostas,
      imagePath: imagePath,
    );
  }

  void reset() => state = const ScannerState();
}

final scannerViewModelProvider =
    NotifierProvider<ScannerViewModel, ScannerState>(ScannerViewModel.new);
