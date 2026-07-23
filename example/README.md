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
    buttons/
      button_demo.dart                   # Embeddable button demo
      button_demo_screen.dart            # Full-page composition
    inputs/
      input_demo.dart                    # Separate Input, Phone, OTP, and PIN demos
      input_demo_screen.dart
    select/
      select_demo.dart                   # Embeddable Select demo
      select_demo_screen.dart
    selection_controls/
      selection_controls_demo.dart       # Separate Checkbox, Radio, and Switch demos
      selection_controls_demo_screen.dart
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
- An entity demo renders the component matrix without creating a
  `MaterialApp`, `Scaffold`, route, or theme state.

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
/#/icons Icons
/#/checkbox Checkbox
/#/radio Radio
/#/switch Switch
/#/select Select
/#/input Input
/#/input-phone Input Phone
/#/input-otp OTP
/#/input-pin PIN
/#/typography/heading TsaiHeading
/#/typography/body TsaiBody
/#/typography/button-text TsaiButtonText
/#/typography/caption TsaiCaption
/#/typography/mono-heading TsaiMonoHeading
/#/typography/mono-body TsaiMonoBody
/#/typography/mono-caption TsaiMonoCaption
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
example layouts. The interactive playground is always the final section.
Inside it, editable public properties and callback output are arranged
vertically above the live component preview. Selection-control lists preserve
the documented 16-pixel list spacing and 24-pixel multiline spacing.

## Adding an entity

1. Add an embeddable `<Entity>Demo` under `features/<entity>/`.
2. Add a thin `<Entity>DemoScreen` that uses `ComponentDemoWindow`.
3. Add the section and route to `ComponentDemoSection` and `CatalogApp`.
4. Cover both direct demo rendering and full-page navigation in tests.
