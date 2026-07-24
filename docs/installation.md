# Installation

## Pub.dev

Add Tsai UI to your application:

```yaml
dependencies:
  flutter:
    sdk: flutter
  tsai_ui: ^0.1.4
```

Then resolve dependencies:

```bash
flutter pub get
```

Alternatively, let Flutter update `pubspec.yaml`:

```bash
flutter pub add tsai_ui
```

## Local development

When the package and consuming app are in the same workspace:

```yaml
dependencies:
  tsai_ui:
    path: ../tsai-ui-flutter
```

## Imports

The main library exports themes, tokens, and widgets:

```dart
import 'package:tsai_ui/tsai_ui.dart';
```

The optional icon entrypoint also exports the Lucide catalog:

```dart
import 'package:tsai_ui/tsai_icons.dart';
```

Install `TsaiTheme.light()` and `TsaiTheme.dark()` before rendering a Tsai
widget. See [Theming](theming.md) for a complete setup.
