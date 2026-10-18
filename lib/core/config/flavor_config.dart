enum Flavor { development, staging, production }

class FlavorConfig {
  static Flavor? appFlavor;

  static const String _productionBaseUrl = 'https://api.rice_delivery.net.sa';
  static const String _stagingBaseUrl = 'https://api-staging.rice_delivery.net.sa';
  static const String _developmentBaseUrl = 'http://10.116.23.224:8080';

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'rice_delivery Dev';
      case Flavor.staging:
        return 'rice_delivery Staging';
      case Flavor.production:
        return 'rice_delivery';
      default:
        return 'rice_delivery';
    }
  }

  static String get packageName {
    switch (appFlavor) {
      case Flavor.development:
        return 'com.rice_delivery.edu.sa.dev';
      case Flavor.staging:
        return 'com.rice_delivery.edu.sa.staging';
      case Flavor.production:
        return 'com.rice_delivery.edu.sa';
      default:
        return 'com.rice_delivery.edu.sa';
    }
  }

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProduction => appFlavor == Flavor.production;

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return _developmentBaseUrl;
      case Flavor.staging:
        return _stagingBaseUrl;
      case Flavor.production:
        return _productionBaseUrl;
      default:
        return _productionBaseUrl;
    }
  }

  static Map<String, dynamic> get config {
    switch (appFlavor) {
      case Flavor.development:
        return {
          'baseUrl': baseUrl,
          'enableLogging': true,
          'enableDebugMode': true,
          'apiTimeout': 30000,
        };
      case Flavor.staging:
        return {
          'baseUrl': baseUrl,
          'enableLogging': true,
          'enableDebugMode': false,
          'apiTimeout': 30000,
        };
      case Flavor.production:
        return {
          'baseUrl': baseUrl,
          'enableLogging': false,
          'enableDebugMode': false,
          'apiTimeout': 15000,
        };
      default:
        return {
          'baseUrl': baseUrl,
          'enableLogging': false,
          'enableDebugMode': false,
          'apiTimeout': 15000,
        };
    }
  }
}
