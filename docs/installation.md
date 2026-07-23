# Installation

## Git dependency

Until the package is published to pub.dev, add the Git repository to your
application:

```yaml
dependencies:
  flutter:
    sdk: flutter
  tsai_ui:
    git:
      url: https://github.com/tsaitechnology/tsai-ui-flutter.git
      ref: main
```

Then resolve dependencies:

```bash
flutter pub get
```

For reproducible production builds, replace `main` with a release tag or commit
SHA.

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
