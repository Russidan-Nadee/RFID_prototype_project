enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment currentEnvironment = Environment.development;

  static bool get isDevelopment =>
      currentEnvironment == Environment.development;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProduction => currentEnvironment == Environment.production;

  static void setEnvironment(Environment env) {
    currentEnvironment = env;
  }
}
