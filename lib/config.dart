class Config {
  static final String apiUrl = const bool.fromEnvironment('dart.vm.product') ||
      const bool.fromEnvironment(
          'PROD_SERVER') // flutter run --dart-define=PROD_SERVER=true
      ? "https://skr.sspg.pl/" // Prod
      : const String.fromEnvironment('DEV_API', defaultValue: "http://127.0.0.1:3000/"); // Local

  static final bool useMockData = false;
  //const bool.fromEnvironment('MOCK'); // flutter run --dart-define=MOCK=true
}