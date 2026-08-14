import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../test_utils/load_test_fonts.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  for (final brightness in Brightness.values) {
    testWidgets('matches the ${brightness.name} Penpot component sheet', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_GoldenApp(brightness: brightness));
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey<String>('golden-sheet')),
        matchesGoldenFile('penpot_components_${brightness.name}.png'),
      );
    });
  }
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: brightness == Brightness.dark ? TsaiTheme.dark() : TsaiTheme.light(),
    home: MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: Scaffold(
        body: RepaintBoundary(
          key: const ValueKey<String>('golden-sheet'),
          child: ColoredBox(
            color: brightness == Brightness.dark
                ? TsaiThemeTokens.dark.colors.canvas
                : TsaiThemeTokens.light.colors.canvas,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ToastBackdrop(),
                  const SizedBox(height: 20),
                  TsaiInlineAlert(
                    title: 'Alert title',
                    message: 'Alert message that explains what happened.',
                    onDismiss: () {},
                  ),
                  const SizedBox(height: 20),
                  const TsaiProgressBar(
                    value: 0.6,
                    label: 'Label',
                    labelPosition: TsaiProgressBarLabelPosition.top,
                  ),
                  const SizedBox(height: 20),
                  const TsaiCard(
                    title: 'Card title',
                    trailing: Icon(LucideIcons.ellipsis),
                    child: _GoldenCardContent(),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TsaiSpinner(size: TsaiSpinnerSize.small),
                      SizedBox(width: 16),
                      TsaiSpinner(),
                      SizedBox(width: 16),
                      TsaiSpinner(size: TsaiSpinnerSize.large),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ToastBackdrop extends StatelessWidget {
  const _ToastBackdrop();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 342,
    height: 72,
    child: Stack(
      fit: StackFit.expand,
      children: [
        const Row(
          children: [
            Expanded(child: ColoredBox(color: Color(0xFF805AD5))),
            Expanded(child: ColoredBox(color: Color(0xFF2563EB))),
            Expanded(child: ColoredBox(color: Color(0xFF059669))),
          ],
        ),
        Center(
          child: TsaiToast(
            variant: TsaiToastVariant.undo,
            message: 'Item deleted',
            actionLabel: 'Undo',
            secondsRemaining: 7,
            onAction: () {},
          ),
        ),
      ],
    ),
  );
}

class _GoldenCardContent extends StatelessWidget {
  const _GoldenCardContent();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(tokens.radii.innerMedium),
      ),
      child: const SizedBox(height: 80),
    );
  }
}
