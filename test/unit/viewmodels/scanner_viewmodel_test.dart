import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/core/constants/app_constants.dart';
import 'package:professor_avalia/features/scanner/scanner_viewmodel.dart';

void main() {
  group('ScannerViewModel — estado inicial', () {
    test('status=idle, scanResult null, imagePath null, errorMessage null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(scannerViewModelProvider);

      expect(state.status, ScannerStatus.idle);
      expect(state.scanResult, isNull);
      expect(state.imagePath, isNull);
      expect(state.errorMessage, isNull);
    });
  });

  group('ScannerViewModel.scan()', () {
    test('processing é definido imediatamente, antes do delay', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Não aguarda — verifica estado síncrono antes do Future.delayed.
      final scanFuture =
          container.read(scannerViewModelProvider.notifier).scan(10);

      expect(
        container.read(scannerViewModelProvider).status,
        ScannerStatus.processing,
      );

      await scanFuture; // aguarda para limpar o estado pendente
    });

    test('scan(10) → done com exatamente 10 alternativas A–E', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(scannerViewModelProvider.notifier).scan(10);

      final state = container.read(scannerViewModelProvider);
      expect(state.status, ScannerStatus.done);
      expect(state.scanResult, hasLength(10));
      expect(
        state.scanResult,
        everyElement(isIn(AppConstants.alternativas)),
      );
    });

    test('scan com imagePath preserva o path no estado final', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container
          .read(scannerViewModelProvider.notifier)
          .scan(5, imagePath: '/tmp/foto.jpg');

      final state = container.read(scannerViewModelProvider);
      expect(state.imagePath, '/tmp/foto.jpg');
      expect(state.scanResult, hasLength(5));
    });
  });

  group('ScannerViewModel.reset()', () {
    test('restaura estado idle após scan concluído', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(scannerViewModelProvider.notifier).scan(3);
      expect(
        container.read(scannerViewModelProvider).status,
        ScannerStatus.done,
      );

      container.read(scannerViewModelProvider.notifier).reset();

      final state = container.read(scannerViewModelProvider);
      expect(state.status, ScannerStatus.idle);
      expect(state.scanResult, isNull);
      expect(state.imagePath, isNull);
    });
  });
}

