# TsaiIcon

A stable square adapter for Lucide or any Flutter `IconData`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/icons){ target="_blank" rel="noopener" .md-button }

```dart
import 'package:tsai_ui/tsai_icons.dart';

const TsaiIcon(
  LucideIcons.settings,
  size: 20,
  semanticLabel: 'Settings',
)
```

`TsaiIcon` inherits color from the nearest `IconTheme` unless `color` is set.
Add `semanticLabel` to standalone meaningful icons; omit it for decorative icons
that accompany a visible label.
