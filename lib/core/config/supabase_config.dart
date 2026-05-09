import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ciitrkesjdhwzzysmpjn.supabase.co',
  );
  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_74Ivj2la7QRL-zeMg2RYNg_fve29VEO',
  );
  static const authRedirectUrl = 'teka-luxe://auth-callback';

  static bool get isConfigured {
    return url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
  }

  static void ensureConfigured() {
    if (isConfigured) {
      return;
    }

    throw StateError(
      'Supabase is not configured. Run with '
      '--dart-define=SUPABASE_URL=<url> '
      '--dart-define=SUPABASE_ANON_KEY=<anon-key>.',
    );
  }
}

class SupabaseBootstrap {
  const SupabaseBootstrap._();

  static Future<void> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
      debug: kDebugMode,
    );
  }
}
