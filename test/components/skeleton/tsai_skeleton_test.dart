import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('renders all placeholder sizes in both themes', (tester) async {
    for (final theme in [TsaiTheme.light(), TsaiTheme.dark()]) {
      for (final size in TsaiSkeletonSize.values) {
        await _pump(
          tester,
          theme: theme,
          child: SizedBox(
            width: 342,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TsaiSkeletonText(size: size, animate: false),
                TsaiSkeletonAvatar(size: size, animate: false),
                TsaiSkeletonCard(size: size, animate: false),
              ],
            ),
          ),
        );

        final surfaces = tester
            .widgetList<SizedBox>(
              find.byKey(const ValueKey<String>('tsai-skeleton-surface')),
            )
            .toList();
        expect(surfaces[0].height, switch (size) {
          TsaiSkeletonSize.small => 8,
          TsaiSkeletonSize.medium => 12,
          TsaiSkeletonSize.large => 16,
        });
        expect(surfaces[1].width, switch (size) {
          TsaiSkeletonSize.small => 32,
          TsaiSkeletonSize.medium => 40,
          TsaiSkeletonSize.large => 48,
        });
        expect(surfaces[2].height, switch (size) {
          TsaiSkeletonSize.small => 64,
          TsaiSkeletonSize.medium => 96,
          TsaiSkeletonSize.large => 160,
        });
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('animates shimmer and honors reduced motion', (tester) async {
    await _pump(tester, child: const TsaiSkeletonText());
    final shimmer = find.byKey(const ValueKey<String>('tsai-skeleton-shimmer'));
    expect(shimmer, findsOneWidget);
    final first = _gradient(tester, shimmer).begin;
    await tester.pump(const Duration(milliseconds: 200));
    expect(_gradient(tester, shimmer).begin, isNot(first));

    await _pump(
      tester,
      disableAnimations: true,
      child: const TsaiSkeletonText(),
    );
    expect(shimmer, findsNothing);
  });

  testWidgets('exposes only an explicitly supplied loading label', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: const TsaiSkeletonAvatar(
        animate: false,
        semanticLabel: 'Loading profile image',
      ),
    );

    expect(find.bySemanticsLabel('Loading profile image'), findsOneWidget);
    semantics.dispose();
  });
}

LinearGradient _gradient(WidgetTester tester, Finder finder) =>
    (tester.widget<DecoratedBox>(finder).decoration as BoxDecoration).gradient!
        as LinearGradient;

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
  bool disableAnimations = false,
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme ?? TsaiTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);
