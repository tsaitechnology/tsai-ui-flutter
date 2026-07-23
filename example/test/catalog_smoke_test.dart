import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui_example/main.dart';

void main() {
  testWidgets('renders the button catalog', (tester) async {
    await tester.pumpWidget(const CatalogApp());

    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Without icon'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Without icon'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Disabled'),
      400,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Disabled'), findsOneWidget);
  });
}
