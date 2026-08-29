# Tsai UI component catalog

The example application is both a visual catalog and the source of reusable
component demos for future interactive documentation.

## Architecture

```text
lib/
  main.dart                              # Flutter entrypoint only
  catalog_app.dart                       # Theme state and named routes
  demo/
    component_demo_window.dart           # Shared chrome, navigation, theme UI
    component_playground.dart            # Shared preview and parameter controls
  features/
    app_examples/
      multi_screen_app_example.dart       # Complete multi-screen app shell
    bottom_nav_bar/
      bottom_nav_bar_demo.dart            # Configurable navigation playground
      bottom_nav_bar_demo_screen.dart
    buttons/
      button_demo.dart                   # Embeddable button demo
      button_demo_screen.dart            # Full-page composition
    avatars/
      avatar_demo_screen.dart             # Avatar and UserPill playgrounds
    icons/
      icon_demo_screen.dart               # Icon playgrounds
    inputs/
      input_demo.dart                    # Separate Input, Phone, OTP, and PIN demos
      input_demo_screen.dart
    links/
      link_demo.dart                     # Embeddable Link demo
      link_demo_screen.dart              # Full-page composition
    select/
      select_demo.dart                   # Embeddable Select demo
      select_demo_screen.dart
    selection_controls/
      selection_controls_demo.dart       # Separate Checkbox, Radio, and Switch demos
      selection_controls_demo_screen.dart
    tabs/
      tabs_demo.dart                      # Configurable tabs playground
      tabs_demo_screen.dart               # Full-page composition
    ui_blocks/
      ui_blocks_demo.dart                 # UI-block playgrounds
      ui_blocks_demo_screen.dart
    typography/
      typography_demo.dart               # Embeddable typography demo
      typography_demo_screen.dart        # Full-page composition
```

The dependency direction is:

```text
CatalogApp
  -> entity demo screen
    -> ComponentDemoWindow
    -> entity demo
      -> tsai_ui
```

### Responsibilities

- `CatalogApp` owns `ThemeMode`, installs `TsaiTheme`, and maps routes to entity
  screens.
- `ComponentDemoWindow` owns the common scaffold, entity navigation, and theme
  switch UI. It does not know how an entity demo is implemented.
- An entity screen only composes its demo with `ComponentDemoWindow`.
- An entity demo renders one configurable playground without creating a
  `MaterialApp`, `Scaffold`, route, or theme state.
- An app example composes several library components into a stateful screen
  shell. It has no component playground and remains internal to the catalog.

This separation keeps the same demo usable as a complete catalog page or as an
embedded interactive-documentation block.

## Rendering

Run the complete catalog:

```bash
flutter run -d chrome
```

Render one full entity page by opening its route:

```text
/          Typography
/#/buttons Buttons on Flutter web
/#/links Links
/#/tabs Tabs playground
/#/bottom-nav-bar Bottom Nav Bar playground
/#/app-examples/multi-screen Complete multi-screen app example
/#/icons/tsai-icon TsaiIcon
/#/icons/hit-icon HitIcon
/#/icons/circle-icon CircleIcon
/#/avatars/avatar Avatar
/#/avatars/user-pill UserPill
/#/checkbox Checkbox
/#/radio Radio
/#/switch Switch
/#/select Select
/#/input Input
/#/input-phone Input Phone
/#/input-otp OTP
/#/input-pin PIN
/#/ui-blocks/section-header Section Header
/#/ui-blocks/empty-state Empty State
/#/ui-blocks/list-item List Item
/#/ui-blocks/list List
/#/typography/heading TsaiTextHeading
/#/typography/body TsaiTextBody
/#/typography/button-text TsaiTextButton
/#/typography/caption TsaiTextCaption
/#/typography/mono-heading TsaiTextMonoHeading
/#/typography/mono-body TsaiTextMonoBody
/#/typography/mono-caption TsaiTextMonoCaption
/#/charts/mini-tabs TsaiMiniTabs
/#/charts/line-chart TsaiLineChart
/#/charts/bar-chart TsaiBarChart
```

The widget-specific routes are stable deep links used by the public
documentation. Flutter web hash routing allows them to open directly when the
catalog is hosted below the GitHub Pages `/example/` path.

Embed only one entity demo in another themed Flutter surface:

```dart
import 'package:tsai_ui_example/features/buttons/button_demo.dart';

SizedBox(
  height: 720,
  child: ButtonDemo(
    controller: documentationScrollController,
  ),
);
```

Every component page starts with the canonical Penpot variant board and Penpot
example layouts. Where a playground is applicable, it is the final section.
Inside it, editable public properties and callback output are arranged
vertically above the live component preview. Selection-control lists preserve
the documented 16-pixel list spacing and 24-pixel multiline spacing.

## Adding an entity

1. Add an embeddable `<Entity>Demo` under `features/<entity>/`.
2. Add a thin `<Entity>DemoScreen` that uses `ComponentDemoWindow`.
3. Add the section and route to `ComponentDemoSection` and `CatalogApp`.
4. Cover both direct demo rendering and full-page navigation in tests.
