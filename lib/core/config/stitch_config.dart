class StitchConfig {
  const StitchConfig._();

  static const apiKey = String.fromEnvironment('STITCH_API_KEY');

  static bool get isConfigured => apiKey.isNotEmpty;
}
