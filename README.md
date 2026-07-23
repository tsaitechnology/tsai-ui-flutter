# tsai-ui-flutter

Enterprise Flutter UI library for Android, iOS, and web. The source of truth is
the [Penpot Design System](https://penpot.tsai/#/workspace?team-id=94d08ab2-b712-814a-8008-482d5efb1ac1&file-id=ab506819-5bcf-801f-8008-4e8f605cef78).

[Public documentation](https://tsaitechnology.github.io/tsai-ui-flutter/) ·
[Interactive example](https://tsaitechnology.github.io/tsai-ui-flutter/example/)

## Current status

- A single publishable `tsai_ui` package.
- Complete light and dark colors, typography, spacing, radii, borders, and
  shadows transferred from Penpot.
- Strongly typed semantic tokens exposed through `TsaiThemeTokens`.
- Seven typography widgets covering all 20 valid Inter and JetBrains Mono
  roles.
- 32 button combinations: four variants, four states, and two sizes.
- Buttons with or without an icon, smooth hover transitions, and an animated
  loading indicator.
- Controlled Checkbox, Radio, and Switch components with error, disabled,
  keyboard, focus, and accessible interaction states.
- Generic adaptive Select with a web/desktop menu, Android bottom sheet, iOS
  picker, clear action, keyboard navigation, and open/close events.
- Text, password, phone, OTP, and PIN inputs. Password visibility is opt-in and
  independently configurable from the initial obscured state. Phone formatting
  preserves cursor intent while inserting and deleting mask separators; OTP
  and PIN expose completion callbacks and configurable sequence lengths.
- A `TsaiIcon` adapter and opt-in access to the complete Lucide icon catalog.
- Android, iOS, and web example application for interactive documentation.
- Unit, widget, keyboard, icon, and accessibility tests.

## Installation

Until the package is published to pub.dev, add the Git repository:

```yaml
dependencies:
  tsai_ui:
    git:
      url: https://github.com/tsaitechnology/tsai-ui-flutter.git
      ref: main
```

For reproducible builds, use a release tag or commit SHA instead of `main`.
Complete installation and theming instructions are in the
[public documentation](https://tsaitechnology.github.io/tsai-ui-flutter/installation/).

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

const TsaiHeading(
  'Portfolio',
  size: TsaiHeadingSize.extraLarge,
);

const TsaiBody(
  'Review current positions and recent activity.',
  size: TsaiBodySize.large,
  weight: TsaiTextWeight.regular,
);

TsaiCheckbox(
  value: accepted,
  label: 'Accept terms',
  onChanged: (value) => setState(() => accepted = value!),
);

TsaiInput(
  label: 'Password',
  obscureText: true,
  onChanged: (value) {},
);

TsaiOtpInput(
  length: 6,
  onChanged: (value) {},
  onCompleted: (value) {},
);
```

Components consume semantic tokens only. The reference palette and Penpot
identifiers are not part of the public API. Typography widgets require valid
size and weight combinations, so consumers do not construct `TextStyle`
instances for design-system text.

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
      input/
      select/
      selection/
      typography/
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

## License

Tsai UI is available under the [MIT License](LICENSE).
