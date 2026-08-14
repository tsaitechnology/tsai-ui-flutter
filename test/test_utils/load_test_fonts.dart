import 'package:flutter/services.dart';

Future<void> loadTsaiTestFonts() async {
  await (FontLoader(
    'packages/tsai_ui/Inter',
  )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  await (FontLoader(
    'packages/tsai_ui/JetBrains Mono',
  )..addFont(rootBundle.load('assets/fonts/JetBrainsMono.ttf'))).load();
  await (FontLoader('packages/flutter_lucide/lucide')..addFont(
        rootBundle.load('packages/flutter_lucide/lib/fonts/lucide.ttf'),
      ))
      .load();
}
