import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SystemUiHelper {
  const SystemUiHelper._();

  static Future<void> enableFullscreen() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000),
        systemNavigationBarColor: Color(0x00000000),
        systemNavigationBarDividerColor: Color(0x00000000),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    await _hideSystemBars();

    SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
      if (!systemOverlaysAreVisible) {
        return;
      }

      await Future<void>.delayed(const Duration(milliseconds: 800));
      await _hideSystemBars();
    });
  }

  static Future<void> _hideSystemBars() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }

    return SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }
}
