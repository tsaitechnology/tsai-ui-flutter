# TsaiTitle

`TsaiTitle` combines a page heading with optional supporting text. It uses the
canonical `headingExtraLarge` and `bodyMedium` typography tokens, primary and
secondary content colors, and `spacing.space4` between the two lines.

[Live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/typography/title){ target="_blank" rel="noopener" .md-button }

```dart
const TsaiTitle(
  'Portfolio',
  subtitle: 'Main account',
)
```

The subtitle is omitted when `subtitle` is null. `TsaiTitle` does not add
horizontal padding; page and container insets belong to the surrounding
layout.

## PageWithTopBar

`PageWithTopBar` uses the same expanded title treatment. Its subtitle is
removed while the primary heading transitions into the pinned top bar.

```dart
PageWithTopBar(
  heading: 'Portfolio',
  subtitle: 'Main account',
  body: const PortfolioContents(),
)
```
