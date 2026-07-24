# Public API Inventory

Canonical import:

```dart
import 'package:tsai_ui/tsai_ui.dart';
```

Optional icon import:

```dart
import 'package:tsai_ui/tsai_icons.dart';
```

## Stable candidates

| Declaration | Purpose | Compatibility |
| --- | --- | --- |
| `TsaiTheme` | Installs light/dark themes | Public |
| `TsaiThemeTokens` | Complete semantic schema | Public |
| `TsaiColorTokens` | Semantic color roles | Public |
| `TsaiTypographyTokens` | Typography roles | Public |
| `TsaiSpacingTokens` | Spacing scale | Public |
| `TsaiRadiusTokens` | Radius scale | Public |
| `TsaiBorderTokens` | Border widths | Public |
| `TsaiShadowTokens` | Theme-aware shadows | Public |
| `TsaiMotionTokens` | Semantic interaction durations | Public |
| `TsaiText` | Sealed base for typography widgets | Public |
| `TsaiHeading` | Four Inter heading roles | Public |
| `TsaiBody` | Four Inter body roles | Public |
| `TsaiButtonText` | Two Inter button-label roles | Public |
| `TsaiCaption` | Four Inter caption roles | Public |
| `TsaiMonoHeading` | Two JetBrains Mono heading roles | Public |
| `TsaiMonoBody` | Two JetBrains Mono body roles | Public |
| `TsaiMonoCaption` | Two JetBrains Mono caption roles | Public |
| Typography size and weight enums | Restrict widgets to valid Penpot roles | Public |
| `TsaiButton` | Action component | Public |
| `TsaiButtonVariant` | Primary/secondary/outline/ghost | Public |
| `TsaiButtonSize` | Medium/large | Public |
| `TsaiButtonTheme` | Global Flutter-native overrides | Public |
| `TsaiCheckbox` | Controlled checkbox with tristate and error support | Public |
| `TsaiRadio<T>` | Controlled generic radio button | Public |
| `TsaiSwitch` | Controlled boolean switch | Public |
| `TsaiControlLabelPosition` | Label placement for selection controls | Public |
| `TsaiSelect<T>` | Controlled generic adaptive select | Public |
| `TsaiSelectOption<T>` | Immutable select option with an optional composed `TsaiIcon` | Public |
| `TsaiSelectPresentation` | Adaptive/menu/Android/iOS presentation policy | Public |
| `TsaiInput` | Text and opt-in password/visibility input | Public |
| `TsaiPhoneInput` | Country-code and masked national-number input | Public |
| `TsaiPhoneInputFormatter` | Cursor-aware phone mask formatter | Public |
| `TsaiOtpInput` | Cell-based one-time-password input | Public |
| `TsaiPinInput` | Dot-based PIN input | Public |
| `TsaiIcon` | Stable IconData, emoji, and custom-widget sizing/color adapter | Public |
| `LucideIcons` | Opt-in icon catalog re-export | External contract |

## Internal

- Penpot token names and reference values;
- button state resolver;
- button content and progress layout;
- input field/content/action frames;
- code-input editable overlay and state resolver;
- example catalog implementation;
- design synchronization scripts to be added later.

No generated Penpot model, router, state-management API, or application service
is exported.

## Pending compatibility impact

- `TsaiIcon(IconData)` remains source compatible.
- `TsaiIcon.emoji` and `TsaiIcon.custom` are additive public constructors.
- `TsaiButton.leadingIcon` is narrowed from `Widget?` to `TsaiIcon?`.
- `TsaiSelectOption.leading` is replaced by `TsaiSelectOption.icon` with type
  `TsaiIcon?`.

The icon-slot changes are breaking and require a minor release while the
package is on the `0.x` version line.
