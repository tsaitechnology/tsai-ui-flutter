import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('Avatar keeps 32-pixel geometry and renders initials', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const Avatar(initials: 'IT', semanticLabel: 'Ilona T.'),
    );

    expect(tester.getSize(find.byType(Avatar)), const Size.square(32));
    expect(find.text('IT'), findsOneWidget);
    expect(find.bySemanticsLabel('Ilona T.'), findsOneWidget);
    final fallback = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(Avatar),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(fallback.color, TsaiThemeTokens.dark.colors.borderStrong);
  });

  testWidgets('UserPill composes Avatar and invokes its action', (
    tester,
  ) async {
    var presses = 0;
    await _pump(
      tester,
      child: UserPill(
        name: 'Ilona T.',
        initials: 'IT',
        semanticLabel: 'Open profile',
        onPressed: () => presses++,
      ),
    );

    expect(find.byType(Avatar), findsOneWidget);
    expect(tester.getSize(find.byType(UserPill)).height, 40);
    expect(tester.getSize(find.byType(UserPill)).width, lessThan(300));
    expect(find.text('Ilona T.'), findsOneWidget);
    expect(find.bySemanticsLabel('Open profile'), findsOneWidget);

    await tester.tap(find.byType(UserPill));
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('Avatar renders an ImageProvider and keeps a circular 32 slot', (
    tester,
  ) async {
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
      '+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    await _pump(
      tester,
      child: SizedBox(
        width: 300,
        height: 40,
        child: Avatar(initials: 'IT', image: MemoryImage(bytes)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(
      tester.getSize(
        find.descendant(
          of: find.byType(Avatar),
          matching: find.byType(ClipOval),
        ),
      ),
      const Size.square(32),
    );
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
