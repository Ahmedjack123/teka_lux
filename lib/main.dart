import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/utils/system_ui_helper.dart';
import 'firebase_options.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SupabaseBootstrap.initialize();
  await initDependencies();
  await SystemUiHelper.enableFullscreen();
  runApp(const MyApp());
}
