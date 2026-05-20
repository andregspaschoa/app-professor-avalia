/// Ambiente de execução do app.
///
/// Uso:
/// ```bash
/// flutter run  --dart-define=FLAVOR=dev   # padrão
/// flutter run  --dart-define=FLAVOR=prod
/// flutter build apk --dart-define=FLAVOR=prod --release
/// ```
enum Flavor { dev, prod }

abstract final class AppEnvironment {
  static const String _flavorValue =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static final Flavor flavor = Flavor.values.byName(_flavorValue);

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;

  static String get apiBaseUrl => switch (flavor) {
        Flavor.dev => 'https://api-dev.professor-avalia.dev',
        Flavor.prod => 'https://api.professor-avalia.com',
      };

  static String get appName => switch (flavor) {
        Flavor.dev => 'Professor Avalia (Dev)',
        Flavor.prod => 'Professor Avalia',
      };
}
