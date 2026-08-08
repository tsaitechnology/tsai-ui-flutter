import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_icons.dart';

void main() {
  testWidgets('renders every Penpot crypto asset in the stable icon slot', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Wrap(
          children: [
            for (final asset in TsaiCryptoAsset.values)
              TsaiCryptoIcon(asset, semanticLabel: asset.name),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TsaiCryptoIcon), findsNWidgets(15));
    expect(find.byType(SvgPicture), findsNWidgets(15));
    for (final asset in TsaiCryptoAsset.values) {
      final icon = find.byKey(ValueKey<String>('tsai-crypto-${asset.name}'));
      expect(icon, findsOneWidget);
      expect(tester.getSize(icon), const Size.square(24));
      expect(find.bySemanticsLabel(asset.name), findsOneWidget);
    }
  });

  testWidgets('supports composition without forcing a second circle', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: TsaiIcon.custom(
            TsaiCryptoIcon(TsaiCryptoAsset.btc, size: 32),
            size: 40,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(TsaiIcon).first), const Size.square(40));
    expect(tester.getSize(find.byType(TsaiCryptoIcon)), const Size.square(32));
    expect(find.byType(CircleIcon), findsNothing);
  });
}
