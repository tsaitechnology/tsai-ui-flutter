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
| `TsaiButton` | Action component | Public |
| `TsaiButtonVariant` | Primary/secondary/outline/ghost | Public |
| `TsaiButtonSize` | Medium/large | Public |
| `TsaiButtonTheme` | Global Flutter-native overrides | Public |
| `TsaiIcon` | Stable icon sizing/color adapter | Public |
| `LucideIcons` | Opt-in icon catalog re-export | External contract |

## Internal

- Penpot token names and reference values;
- button state resolver;
- button content and progress layout;
- example catalog implementation;
- design synchronization scripts to be added later.

No generated Penpot model, router, state-management API, or application service
is exported.
