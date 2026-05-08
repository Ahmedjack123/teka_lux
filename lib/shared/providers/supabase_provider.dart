import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';

final supabaseConfiguredProvider = Provider<bool>((ref) {
  return SupabaseConfig.isConfigured;
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  SupabaseConfig.ensureConfigured();
  return Supabase.instance.client;
});

final supabaseClientOrNullProvider = Provider<SupabaseClient?>((ref) {
  if (!SupabaseConfig.isConfigured) {
    return null;
  }

  return Supabase.instance.client;
});
