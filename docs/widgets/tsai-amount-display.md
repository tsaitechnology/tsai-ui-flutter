# TsaiAmountDisplay

A hugging caption / value / sub-line stack with `spacing.6`. The value uses
Mono Heading XL. Alignment is start (Home) or center (Transfer).

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/amount-display){ target="_blank" rel="noopener" .md-button }

```dart
const TsaiAmountDisplay(
  alignment: TsaiAmountAlignment.start,
  caption: 'Total balance',
  value: r'$24,562.80',
  subtitle: '+2.2% this month',
)
```

Caption and subtitle are optional. Color overrides are available when the
stack sits on an indigo card.
