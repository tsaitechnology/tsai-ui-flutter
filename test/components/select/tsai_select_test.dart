import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  const options = [
    TsaiSelectOption(
      value: 'uy',
      label: 'Uruguay',
      icon: TsaiIcon.emoji('🇺🇾', size: 20),
    ),
    TsaiSelectOption(
      value: 'ar',
      label: 'Argentina',
      icon: TsaiIcon.emoji('🇦🇷', size: 20),
    ),
    TsaiSelectOption(value: 'br', label: 'Brazil', enabled: false),
  ];

  testWidgets('matches the Penpot field hierarchy and dimensions', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          placeholder: 'Country',
          description: 'Description',
          onChanged: _noop,
        ),
      ),
    );

    expect(find.byKey(const ValueKey('tsai-select-layout')), findsOneWidget);
    expect(find.byKey(const ValueKey('tsai-select-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('tsai-select-content')), findsOneWidget);
    expect(find.byKey(const ValueKey('tsai-select-value-row')), findsNothing);
    expect(
      find.byKey(const ValueKey('tsai-select-description')),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('tsai-select-field'))),
      const Size(320, 56),
    );
    expect(find.text('Country'), findsOneWidget);
  });

  testWidgets('opens, selects, closes, and reports each event', (tester) async {
    String? selected;
    var opens = 0;
    var closes = 0;
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          width: 320,
          child: TsaiSelect<String>(
            options: options,
            value: selected,
            placeholder: 'Country',
            onOpen: () => opens++,
            onClose: () => closes++,
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    expect(opens, 1);
    expect(find.text('Uruguay'), findsOneWidget);
    expect(find.text('Argentina'), findsOneWidget);

    await tester.tap(find.text('Argentina'));
    await tester.pumpAndSettle();
    expect(selected, 'ar');
    expect(closes, 1);
    expect(find.text('Argentina'), findsOneWidget);
    expect(find.byKey(const ValueKey('tsai-select-clear')), findsOneWidget);

    await tester.tap(find.byTooltip('Clear selection'));
    await tester.pump();
    expect(selected, isNull);
  });

  testWidgets('disabled select does not open and disabled option is inert', (
    tester,
  ) async {
    String? selected;
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          placeholder: 'Disabled',
          onChanged: null,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    expect(find.text('Uruguay'), findsNothing);

    await _pump(
      tester,
      child: SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: selected,
          onChanged: (value) => selected = value,
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Brazil'));
    await tester.pump();
    expect(selected, isNull);
  });

  testWidgets('supports keyboard opening and focus events', (tester) async {
    final focusEvents = <bool>[];
    await _pump(
      tester,
      child: SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          autofocus: true,
          placeholder: 'Country',
          onFocusChange: focusEvents.add,
          onChanged: _noop,
        ),
      ),
    );
    await tester.pump();
    expect(focusEvents, contains(true));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.text('Uruguay'), findsOneWidget);
  });

  testWidgets('bottom sheet presentation supports Android-style selection', (
    tester,
  ) async {
    String? selected;
    await _pump(
      tester,
      child: SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          presentation: TsaiSelectPresentation.bottomSheet,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('tsai-select-bottom-sheet')),
      findsOneWidget,
    );

    await tester.tap(find.text('Uruguay'));
    await tester.pumpAndSettle();
    expect(selected, 'uy');
  });

  testWidgets('Cupertino presentation supports iOS-style selection', (
    tester,
  ) async {
    String? selected;
    await _pump(
      tester,
      child: SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          presentation: TsaiSelectPresentation.cupertinoPicker,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('tsai-select-cupertino-picker')),
      findsOneWidget,
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(selected, 'uy');
  });

  testWidgets('renders error and selected icon', (tester) async {
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: 'uy',
          placeholder: 'Country',
          description: 'Ignored',
          errorText: 'Required',
          onChanged: _noop,
        ),
      ),
    );

    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Ignored'), findsNothing);
    expect(find.text('🇺🇾'), findsOneWidget);
    final decoration =
        tester
                .widget<AnimatedContainer>(
                  find.byKey(const ValueKey('tsai-select-field')),
                )
                .decoration
            as BoxDecoration;
    expect(
      (decoration.border! as Border).top.color,
      TsaiThemeTokens.dark.colors.negative,
    );
  });

  testWidgets('exposes a labeled expanded semantic state', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          placeholder: 'Country',
          semanticLabel: 'Country selector',
          onChanged: _noop,
        ),
      ),
    );

    expect(find.bySemanticsLabel('Country selector'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tsai-select-field')));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Country selector'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('moves placeholder above a selected value', (tester) async {
    String? selected;
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          width: 320,
          child: TsaiSelect<String>(
            options: options,
            value: selected,
            placeholder: 'Country',
            onChanged: (value) => setState(() => selected = value),
          ),
        ),
      ),
    );

    expect(
      _alignment(tester, 'tsai-select-placeholder-position'),
      AlignmentDirectional.centerStart,
    );
    expect(
      tester
          .widget<AnimatedAlign>(
            find.byKey(const ValueKey('tsai-select-placeholder-position')),
          )
          .duration,
      const Duration(milliseconds: 210),
    );
    expect(_selectBorder(tester).top.width, 1);

    final field = find.byKey(const ValueKey('tsai-select-field'));
    await tester.tapAt(tester.getTopLeft(field) + const Offset(8, 8));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uruguay'));
    await tester.pumpAndSettle();

    expect(selected, 'uy');
    expect(
      _alignment(tester, 'tsai-select-placeholder-position'),
      const AlignmentDirectional(-1, -0.45),
    );
    expect(
      _alignment(tester, 'tsai-select-value-position'),
      const AlignmentDirectional(-1, 0.45),
    );
    expect(_selectBorder(tester).top.width, 1);
  });

  testWidgets('fades in only the first selected value', (tester) async {
    String? selected;
    late StateSetter update;
    await _pump(
      tester,
      child: StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return SizedBox(
            width: 320,
            child: TsaiSelect<String>(
              options: options,
              value: selected,
              placeholder: 'Country',
              onChanged: (value) => setState(() => selected = value),
            ),
          );
        },
      ),
    );

    update(() => selected = 'uy');
    await tester.pump();
    expect(_valueOpacity(tester).opacity, 0);

    await tester.pump();
    expect(_valueOpacity(tester).opacity, 1);
    await tester.pump(const Duration(milliseconds: 210));

    update(() => selected = 'ar');
    await tester.pump();
    expect(find.text('Argentina'), findsOneWidget);
    expect(_valueOpacity(tester).opacity, 1);
  });

  testWidgets('keeps selected value centered without a labeled placeholder', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: 'uy',
          placeholder: 'Country',
          labeledPlaceholder: false,
          onChanged: _noop,
        ),
      ),
    );

    expect(
      _alignment(tester, 'tsai-select-value-position'),
      AlignmentDirectional.centerStart,
    );
  });

  testWidgets('renders an empty field when placeholder and value are null', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const SizedBox(
        width: 320,
        child: TsaiSelect<String>(
          options: options,
          value: null,
          onChanged: _noop,
        ),
      ),
    );

    expect(find.byKey(const ValueKey('tsai-select-placeholder')), findsNothing);
    expect(find.byKey(const ValueKey('tsai-select-value')), findsNothing);
  });
}

void _noop(String? value) {}

AlignmentGeometry _alignment(WidgetTester tester, String key) =>
    tester.widget<AnimatedAlign>(find.byKey(ValueKey<String>(key))).alignment;

AnimatedOpacity _valueOpacity(WidgetTester tester) =>
    tester.widget<AnimatedOpacity>(
      find.byKey(const ValueKey<String>('tsai-select-value-opacity')),
    );

Border _selectBorder(WidgetTester tester) {
  final decoration =
      tester
              .widget<AnimatedContainer>(
                find.byKey(const ValueKey('tsai-select-field')),
              )
              .decoration
          as BoxDecoration;
  return decoration.border! as Border;
}

Future<void> _pump(WidgetTester tester, {required Widget child}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
