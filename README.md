# tsai-ui-flutter

Enterprise Flutter UI library for Android, iOS, and web. The source of truth is
the [Penpot Design System](https://penpot.tsai/#/workspace?team-id=94d08ab2-b712-814a-8008-482d5efb1ac1&file-id=ab506819-5bcf-801f-8008-4e8f605cef78).

## Current status

- A single publishable `tsai_ui` package.
- Complete light and dark colors, typography, spacing, radii, borders, and
  shadows transferred from Penpot.
- Strongly typed semantic tokens exposed through `TsaiThemeTokens`.
- 32 button combinations: four variants, four states, and two sizes.
- Buttons with or without an icon, plus a smooth animated loading indicator.
- A `TsaiIcon` adapter and opt-in access to the complete Lucide icon catalog.
- Android, iOS, and web example application for interactive documentation.
- Unit, widget, keyboard, icon, and accessibility tests.

## Usage

```dart
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

MaterialApp(
  theme: TsaiTheme.light(),
  darkTheme: TsaiTheme.dark(),
  home: TsaiButton(
    label: 'Create',
    leadingIcon: const TsaiIcon(LucideIcons.plus, size: 16),
    onPressed: () {},
  ),
);
```

Components consume semantic tokens only. The reference palette and Penpot
identifiers are not part of the public API.

## Structure

```text
lib/
  tsai_ui.dart
  tsai_icons.dart
  src/
    foundation/
      primitives/
      semantic/
      theme/
    components/
      button/
    icons/
example/
  lib/
  web/
test/
  foundation/
  components/
  icons/
doc/
```

Architecture and delivery plans:

- [Architecture](doc/ARCHITECTURE.md)
- [Public API inventory](doc/API_INVENTORY.md)
- [Development, testing, docs, and deployment plan](doc/DEVELOPMENT_PLAN.md)
- [Penpot synchronization](doc/PENPOT_SYNC.md)

## Local development

```bash
flutter pub get
flutter analyze
flutter test
cd example && flutter run -d chrome
```

The package remains private through `publish_to: none`. Remove that setting
only as part of an intentional package release.
