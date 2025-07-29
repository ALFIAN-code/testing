class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(milliseconds: 10000),
    this.receiveTimeout = const Duration(milliseconds: 10000),
    this.headers = const <String, String>{'Content-Type': 'application/json'},
  });

  factory ApiConfig.defaultConfig() =>
      const ApiConfig(baseUrl: 'https://be.wmsrj.sindika.co.id/api/v1');

  factory ApiConfig.development() => const ApiConfig(
    baseUrl: 'https://be.wmsrj.sindika.co.id/api/v1',
  );

  factory ApiConfig.production() =>
      const ApiConfig(baseUrl: 'https://be.wmsrj.sindika.co.id/api/v1');

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, dynamic> headers;
}
