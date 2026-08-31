# tsai-ui-flutter

Enterprise Flutter UI library for Android, iOS, and web. The source of truth is
the [Penpot Design System](https://penpot.tsai/#/workspace?team-id=94d08ab2-b712-814a-8008-482d5efb1ac1&file-id=ab506819-5bcf-801f-8008-4e8f605cef78).

[Public documentation](https://tsaitechnology.github.io/tsai-ui-flutter/) ·
[Interactive example](https://tsaitechnology.github.io/tsai-ui-flutter/example/)

The library is being prepared for its stable `1.0.0` release.

## Installation

Add the package from pub.dev:

```yaml
dependencies:
  tsai_ui: ^0.6.13
```

Or run:

```bash
flutter pub add tsai_ui
```

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

const TsaiTextHeading(
  'Portfolio',
  size: TsaiHeadingSize.extraLarge,
);

const TsaiTextBody(
  'Review current positions and recent activity.',
  size: TsaiBodySize.large,
  weight: TsaiTextWeight.regular,
);

const TsaiTitle(
  'Portfolio',
  subtitle: 'Main account',
);

TsaiCheckbox(
  value: accepted,
  label: 'Accept terms',
  onChanged: (value) => setState(() => accepted = value!),
);

TsaiLink(
  label: 'View details',
  trailingIcon: const TsaiIcon(LucideIcons.chevron_right, size: 16),
  onPressed: () {},
);

TsaiTabs(
  sections: const [
    TsaiTabSection(tab: Text('Overview'), content: OverviewSection()),
    TsaiTabSection(tab: Text('Activity'), content: ActivitySection()),
  ],
);

BottomNavBar(
  items: const [
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.credit_card, size: 20),
      label: 'Cards',
    ),
  ],
  selectedIndex: selectedIndex,
  onSelected: (index) => setState(() => selectedIndex = index),
);

TsaiList(
  title: 'Transactions',
  headerTrailingIcon: const TsaiIcon(LucideIcons.search),
  items: const [
    TsaiListItem(
      icon: TsaiIcon(LucideIcons.coffee, size: 20),
      content: TsaiTextBody(
        'Blue Bottle',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.medium,
      ),
      trailing: TsaiTextMonoBody(
        '-\$4.50',
        size: TsaiBodySize.medium,
      ),
    ),
  ],
);

TsaiInput(
  placeholder: 'Promo code',
  showClearButton: false,
  trailingAction: TsaiButton(
    label: 'Apply',
    size: TsaiButtonSize.medium,
    variant: TsaiButtonVariant.secondary,
    onPressed: () {},
  ),
);

TsaiTextarea(
  placeholder: 'Note for the bank',
  description: 'Optional',
  maxLength: 500,
);

final date = await showTsaiDatePicker(context: context);
final range = await showTsaiDateRangePicker(context: context);
final time = await showTsaiTimePicker(context: context, minuteStep: 5);

TsaiSearchInput(
  hintText: 'Search assets',
  onChanged: (value) {},
);

const TsaiCryptoIcon(
  TsaiCryptoAsset.btc,
  semanticLabel: 'Bitcoin',
);

TsaiOtpInput(
  length: 6,
  onChanged: (value) {},
  onCompleted: (value) {},
);
```

Component colors, reusable scrim gradients, typography, spacing, radii,
borders, shadows, effects, and motion consume semantic tokens. Fixed component
geometry remains private until Penpot defines corresponding sizing tokens.
Reference palette values and Penpot identifiers are not part of the public API.

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
      bottom_nav_bar/
      bottom_sheet/
      button/
      effects/
      input/
      link/
      modal_dialog/
      select/
      selection/
      tabs/
      top_bar/
      typography/
      ui_blocks/
    icons/
example/
  lib/
  web/
test/
  foundation/
  components/
  icons/
docs/                    # Public documentation site
doc/                     # Architecture and engineering records
```

Project documentation:

- [Architecture](doc/ARCHITECTURE.md)
- [Public API inventory](doc/API_INVENTORY.md)
- [Development and release readiness](doc/DEVELOPMENT_PLAN.md)
- [Penpot synchronization](doc/PENPOT_SYNC.md)
- [Publishing and release automation](doc/PUBLISHING.md)

## Local development

```bash
flutter pub get
flutter analyze
flutter test
(cd example && flutter test)
cd example && flutter run -d chrome
```

## License

Tsai UI is available under the [MIT License](LICENSE).
