import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../test_utils/load_test_fonts.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  testWidgets('matches the Penpot Card frame', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 342,
          child: TsaiCard(
            title: 'Card title',
            trailing: Icon(Icons.more_horiz),
            child: _ContentPlaceholder(),
          ),
        ),
      ),
    );

    final card = find.byType(TsaiCard);
    expect(tester.getSize(card), const Size(342, 148));
    final cardOrigin = tester.getTopLeft(card);
    expect(
      tester.getTopLeft(find.text('Card title')) - cardOrigin,
      const Offset(16, 16),
    );
    expect(
      tester.getSize(find.byType(_ContentPlaceholder)),
      const Size(310, 80),
    );
    expect(
      tester.getTopLeft(find.byType(_ContentPlaceholder)) - cardOrigin,
      const Offset(16, 52),
    );

    final surface = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('tsai-card-surface')),
    );
    final decoration = surface.decoration as BoxDecoration;
    final tokens = TsaiThemeTokens.dark;
    expect(decoration.color, tokens.colors.surface);
    expect(decoration.borderRadius, BorderRadius.circular(tokens.radii.large));
    expect(
      (decoration.border! as Border).top,
      BorderSide(
        color: tokens.colors.borderSubtle,
        width: tokens.borders.hairline,
      ),
    );
  });

  testWidgets('supports arbitrary content without a header', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: SizedBox(
          width: 342,
          child: TsaiCard(child: SizedBox(height: 120)),
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiCard)), const Size(342, 152));
  });

  testWidgets('keeps the trailing slot directional', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 342,
          child: TsaiCard(
            title: 'Card title',
            trailing: Icon(Icons.more_horiz, key: ValueKey('trailing')),
            child: SizedBox(height: 80),
          ),
        ),
      ),
    );

    final cardOrigin = tester.getTopLeft(find.byType(TsaiCard));
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('trailing'))).dx -
          cardOrigin.dx,
      16,
    );
  });
}

class _ContentPlaceholder extends StatelessWidget {
  const _ContentPlaceholder();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: TsaiThemeTokens.of(context).colors.surfaceRaised,
      borderRadius: BorderRadius.circular(
        TsaiThemeTokens.of(context).radii.innerMedium,
      ),
    ),
    child: const SizedBox(height: 80),
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, this.textDirection = TextDirection.ltr});

  final Widget child;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: TsaiTheme.dark(),
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}
