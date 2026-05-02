import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/system_ui_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemUiHelper.enableFullscreen();
  runApp(const ProviderScope(child: MyApp()));
}
