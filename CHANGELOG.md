## Unreleased

### Changed

- Removed the animated country-code width from `TsaiPhoneInput`; the editable
  now takes its measured width in the same layout pass.
- Split the full `TsaiPhoneInput` field hit area at the country divider, so
  taps on the left focus the country code and taps on the right focus the
  national number.
- Added `TsaiIcon.emoji` and `TsaiIcon.custom` for flags, SVG, PNG, and other
  custom widget sources.
- Changed reusable icon slots to accept composed `TsaiIcon` widgets.
- Replaced `TsaiSelectOption.leading` with the typed
  `TsaiSelectOption.icon` property.
- Added a country Select example with emoji flags.

## 0.1.3 - 2026-07-23

### Features

- refine form fields and playground ([09c6901](https://github.com/tsaitechnology/tsai-ui-flutter/commit/09c6901864b6f7911450293249f10b3139dc4abb))

## 0.1.2 - 2026-07-23

### Maintenance

- deploy pages only for releases ([4aa7fdf](https://github.com/tsaitechnology/tsai-ui-flutter/commit/4aa7fdfab22113ebc163c55edd6d95a01e4d805e))
- rename release entry workflow ([0f1c25d](https://github.com/tsaitechnology/tsai-ui-flutter/commit/0f1c25d4e19539ed2c8e041896fa886f9681deef))
- select semantic version increment ([b9ecf26](https://github.com/tsaitechnology/tsai-ui-flutter/commit/b9ecf2666c2abb0c505e3937de1c4981815a2932))
- use Tsai controls in playgrounds ([dbc953c](https://github.com/tsaitechnology/tsai-ui-flutter/commit/dbc953c61cf795e01e2e38b26338ba6bf52ab70c))

## 0.1.1 - 2026-07-23

### Features

- automate release metadata ([bcfb0f0](https://github.com/tsaitechnology/tsai-ui-flutter/commit/bcfb0f03ebddddfd2054eed4aa2616262efd5aa3))

### Documentation

- expand pub.dev example ([eae5351](https://github.com/tsaitechnology/tsai-ui-flutter/commit/eae5351525c401b295e95b861cd0dde7ab15f734))

### Maintenance

- Clarify pub.dev event configuration ([edb19f0](https://github.com/tsaitechnology/tsai-ui-flutter/commit/edb19f0904b4c801066ca966d902dcede16047fd))

## 0.1.0 - 2026-07-23

- Added public Markdown documentation with one page and live example link per
  widget, plus installation, theming, accessibility, and license guidance.
- Added a GitHub Pages workflow that publishes generated MkDocs HTML together
  with the Flutter web example under `/example/`.
- Added stable deep links for every typography widget and a dedicated
  `TsaiIcon` example page.
- Changed the project license to MIT.
- Added Checkbox, Radio, Switch, Select, Input, Input Phone, Input OTP, and
  Input PIN components and interactive catalog pages.
- Added cursor-aware phone masking and completion events for phone, OTP, and
  PIN input.
- Added adaptive Select presentation for web/desktop, Android, and iOS.
- Added configurable 4/6 digit OTP and PIN examples, responsive OTP cells, and
  a dedicated playground page for every component.
- Aligned catalog variant boards and list examples with Penpot, and expanded
  playgrounds to edit component properties above a live preview.
- Added typed light and dark design token sets sourced from Penpot.
- Added theme installation helpers and bundled typography.
- Added primary, secondary, outline, and ghost buttons in two sizes.
- Added loading, disabled, pointer, focus, and keyboard behavior.
- Matched the size-specific icon gap and added a smooth animated spinner.
- Added token-driven hover and state color transitions with reduced-motion support.
- Added typed widgets for all 20 Inter and JetBrains Mono typography roles.
- Added Typography and Buttons views to the interactive example catalog.
- Added a Lucide icon adapter and interactive example catalog.
