# Tsai UI

Tsai UI is a Flutter component library for Android, iOS, and web. It provides
typed light and dark themes, semantic design tokens, typography, form controls,
selection controls, buttons, and Lucide-compatible icons.

[Install Tsai UI](installation.md){ .md-button .md-button--primary }
[Open the component catalog](https://tsaitechnology.github.io/tsai-ui-flutter/example/){ target="_blank" rel="noopener" .md-button }

## Package guarantees

- Components consume semantic `TsaiThemeTokens` instead of raw palette values.
- Light and dark token sets share one strongly typed schema.
- Controlled inputs expose state changes through Flutter callbacks.
- Focus, keyboard, pointer, semantics, and reduced-motion behavior are built in.
- The public package is available under the [MIT License](license.md).

## Minimal example

```dart
import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() => runApp(
  MaterialApp(
    theme: TsaiTheme.light(),
    darkTheme: TsaiTheme.dark(),
    home: Scaffold(
      body: Center(
        child: TsaiButton(
          label: 'Continue',
          onPressed: () {},
        ),
      ),
    ),
  ),
);
```

See the [widget index](widgets/index.md) for component-specific usage and live
examples.
