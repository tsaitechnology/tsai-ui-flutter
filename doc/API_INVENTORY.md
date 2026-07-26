# Public API Inventory

Canonical import:

```dart
import 'package:tsai_ui/tsai_ui.dart';
```

Optional icon import:

```dart
import 'package:tsai_ui/tsai_icons.dart';
```

## Public surface

| Declaration | Purpose | Exposure |
| --- | --- | --- |
| `TsaiTheme` | Installs light/dark themes | Public |
| `TsaiThemeTokens` | Complete semantic schema | Public |
| `TsaiColorTokens` | Semantic color roles | Public |
| `TsaiTypographyTokens` | Typography roles | Public |
| `TsaiSpacingTokens` | Spacing scale | Public |
| `TsaiRadiusTokens` | Radius scale | Public |
| `TsaiBorderTokens` | Border widths | Public |
| `TsaiShadowTokens` | Theme-aware shadows | Public |
| `TsaiMotionTokens` | Semantic durations and easing curves | Public |
| `TsaiText` | Sealed base for typography widgets | Public |
| `TsaiTextHeading` | Four Inter heading roles | Public |
| `TsaiTextBody` | Four Inter body roles | Public |
| `TsaiTextButton` | Two Inter button-label roles | Public |
| `TsaiTextCaption` | Four Inter caption roles | Public |
| `TsaiTextMonoHeading` | Two JetBrains Mono heading roles | Public |
| `TsaiTextMonoBody` | Two JetBrains Mono body roles | Public |
| `TsaiTextMonoCaption` | Two JetBrains Mono caption roles | Public |
| `TsaiTitle` | Page title with optional supporting text | Public |
| Typography size and weight enums | Restrict widgets to valid Penpot roles | Public |
| `TsaiButton` | Action component | Public |
| `TsaiButtonVariant` | Primary/secondary/outline/ghost | Public |
| `TsaiButtonSize` | Medium/large | Public |
| `TsaiButtonTheme` | Global Flutter-native overrides | Public |
| `TsaiLink` | Compact inline action with optional leading/trailing icons | Public |
| `TsaiTabSection` | Immutable tab-label and content-section pair | Public |
| `TsaiTabBar` | Token-backed controlled tab selector | Public |
| `TsaiTabContent` | Intrinsic or viewport tab content | Public |
| `TsaiTabs` | Internally or externally controlled bar/content composition | Public |
| `TsaiSliverTabBar` | Pinned or floating sliver tab selector | Public |
| `TsaiTabBarFit` | Expanded or horizontally scrollable tab sizing | Public |
| `TsaiTabContentLayout` | Natural-height or bounded viewport content | Public |
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
| `UserPill` | User name and network-avatar summary with initials fallback | Public |
| `HomeTopBarAction` | Circular home-bar icon action with an optional status indicator | Public |
| `HomeTopBar` | Home-page top bar with leading and trailing widget lists | Public |
| `PageTopBarAction` | Compact icon action for secondary-page top bars | Public |
| `PageTopBar` | Secondary-page top bar with widget edge slots and a centered text title | Public |
| `PageWithTopBar` | Scroll-owning page composition that promotes its heading into a pinned top bar | Public |
| `LucideIcons` | Opt-in icon catalog re-export | External contract |

## Internal

- Penpot token names and reference values;
- fixed component geometry not represented by Penpot tokens;
- button state resolver;
- button content and progress layout;
- link state resolver and content layout;
- tabs indicator, intrinsic transition, and sliver delegate;
- input field/content/action frames;
- code-input editable overlay and state resolver;
- top-bar spacing, action frames, avatar loading, and heading transition;
- example catalog implementation.

No generated Penpot model, router, state-management API, or application service
is exported.
