enum AppEnvironment { dev, staging, prod }

class AppConfig {
  const AppConfig._();

  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'AI Vibe Flutter Base',
  );

  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static AppEnvironment get appEnvironment => switch (environment) {
        'prod' || 'production' => AppEnvironment.prod,
        'staging' => AppEnvironment.staging,
        _ => AppEnvironment.dev,
      };

  static bool get isProduction => appEnvironment == AppEnvironment.prod;
}
