import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('circle tile keeps the 56-pixel plate width in a wide row', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: SizedBox(
            width: 390,
            child: Row(
              children: [
                TsaiActionTile(
                  icon: const Icon(Icons.send),
                  label: 'Top up',
                  onPressed: () {},
                ),
                TsaiActionTile(
                  icon: const Icon(Icons.wallet),
                  label: 'Cards',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiActionTile).at(0)).width, 56);
    expect(tester.getSize(find.byType(TsaiActionTile).at(1)).width, 56);
    expect(tester.getSize(find.byType(TsaiActionTile).at(0)).height, 80);
  });

  testWidgets('card tile keeps the 84 by 72 plate', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(
          body: Row(
            children: [
              TsaiActionTile(
                variant: TsaiActionTileVariant.card,
                icon: const Icon(Icons.send),
                label: 'Send',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(TsaiActionTile)), const Size(84, 72));
  });
}
