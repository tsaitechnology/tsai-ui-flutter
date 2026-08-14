# TsaiCard

A 16-pixel-radius base card with an optional title row and arbitrary content.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/ui-blocks/card){ target="_blank" rel="noopener" .md-button }

```dart
const TsaiCard(
  title: 'Portfolio',
  trailing: TsaiIcon(LucideIcons.ellipsis),
  child: PortfolioSummary(),
)
```

The card owns only its surface, border, 16-pixel padding, and optional header.
The `child` remains unrestricted so application-specific content does not leak
into the UI library API.
