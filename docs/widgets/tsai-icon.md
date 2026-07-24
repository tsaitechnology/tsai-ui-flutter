# TsaiIcon

A stable square adapter for Lucide glyphs, emoji, SVG, PNG, or other custom
Flutter widgets.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/icons){ target="_blank" rel="noopener" .md-button }

```dart
import 'package:tsai_ui/tsai_icons.dart';

const TsaiIcon(
  LucideIcons.settings,
  size: 20,
  semanticLabel: 'Settings',
)

const TsaiIcon.emoji('🇺🇾', size: 20)

TsaiIcon.custom(
  Image.asset('assets/brand-mark.png'),
  size: 20,
  semanticLabel: 'Brand',
)
```

`TsaiIcon` inherits color from the nearest `IconTheme` unless `color` is set.
Custom widgets receive the resolved size and color through `IconTheme`; widgets
such as `Image` or `SvgPicture` should configure tinting themselves when needed.
Add `semanticLabel` to standalone meaningful icons; omit it for decorative icons
that accompany a visible label.
