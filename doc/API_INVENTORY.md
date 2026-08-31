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
| `TsaiColorTokens` | Semantic color roles, including danger actions/content, Skeleton surfaces, status accents/surfaces/borders, glass surfaces, modal scrim, and background glow | Public |
| `TsaiGradientTokens` | Theme-aware top and bottom scrim assets | Public |
| `TsaiTypographyTokens` | Typography roles | Public |
| `TsaiSpacingTokens` | Spacing scale | Public |
| `TsaiRadiusTokens` | Radius scale including the 20-pixel card radius and 32-pixel sheet radius | Public |
| `TsaiBorderTokens` | Border widths | Public |
| `TsaiShadowTokens` | Theme-aware shadows | Public |
| `TsaiEffectTokens` | Semantic backdrop and image effects | Public |
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
| `TsaiButtonTone` | Standard/danger semantic color treatment | Public |
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
| `TsaiSelectPresentation` | Compatibility presentation flag; options always open in a bottom sheet | Public |
| `TsaiInput` | Text and opt-in password/visibility input | Public |
| `TsaiTextarea` | Multiline text field with optional character counter | Public |
| `TsaiTextareaMetaRow` | Helper copy and optional counter under a textarea | Public |
| `TsaiSearchInput` | Compact search field with native editing, submission, focus, and clear behavior | Public |
| `TsaiPhoneInput` | Country-code and masked national-number input | Public |
| `TsaiPhoneInputFormatter` | Cursor-aware phone mask formatter | Public |
| `TsaiOtpInput` | Cell-based one-time-password input | Public |
| `TsaiPinInput` | Dot-based PIN input | Public |
| `TsaiIcon` | Stable IconData, emoji, and custom-widget sizing/color adapter | Public |
| `TsaiCryptoAsset` | Fifteen cryptocurrency assets mirrored from the Penpot pack | Public |
| `TsaiCryptoIcon` | Scalable full-color cryptocurrency artwork in a stable square slot | Public |
| `HitIcon` | Fixed 32-pixel interaction field with a centered 24-pixel icon | Public |
| `CircleIcon` | Token-backed 40-pixel circle with a centered 20-pixel icon | Public |
| `Avatar` | Fixed 32-pixel image-provider avatar with initials fallback | Public |
| `TsaiSectionHeader` | Compact section label with an optional trailing icon slot | Public |
| `TsaiEmptyState` | Centered icon, message, description, and optional action composition | Public |
| `TsaiGlow` | Decorative theme-aware blurred accent background | Public |
| `TsaiListItem` | Composable row with active, icon, content, trailing, chevron, and activation support | Public |
| `TsaiList` | Section header, list-item collection, and optional bottom-button composition | Public |
| `UserPill` | User name and network-avatar summary with initials fallback | Public |
| `HomeTopBarAction` | Circular home-bar icon action with an optional status indicator | Public |
| `HomeTopBar` | Home-page top bar with leading and trailing widget lists | Public |
| `PageTopBarAction` | Compact icon action for secondary-page top bars | Public |
| `PageTopBar` | Glass secondary-page bar with widget edge slots and a centered text title | Public |
| `PageWithTopBar` | Full-height scroll composition that promotes its heading beneath a pinned overlay bar | Public |
| `PageWithSearchTopBar` | Scroll composition with a pinned 112-pixel glass app bar and search field | Public |
| `BottomNavBarItem` | Immutable icon, label, and optional semantic label for a bottom destination | Public |
| `BottomNavBar` | Controlled one-to-five destination glass bottom-navigation bar | Public |
| `BottomNavBar.barHeightOf` | Theme-resolved 94-pixel overlay bar height | Public |
| `TsaiBottomSheetSize` | Content, half, and full sheet sizing policies | Public |
| `TsaiBottomSheet` | Content-sized by default; composable rounded sheet surface with glow, app bar, content, and actions | Public |
| `showTsaiBottomSheet<T>` | Theme-aware modal route for `TsaiBottomSheet` | Public |
| `TsaiModalDialogActionsLayout` | Row and stacked dialog action arrangements | Public |
| `TsaiModalDialog` | Compact icon, message, and action dialog surface | Public |
| `showTsaiModalDialog<T>` | Theme-aware modal route for `TsaiModalDialog` | Public |
| `TsaiToastVariant` | Undo, action, and informational Toast compositions | Public |
| `TsaiToastDismissReason` | Timeout, dismiss, and action results from `showTsaiToast` | Public |
| `TsaiToast` | Compact glass notification with action, dismissal, or countdown affordances | Public |
| `showTsaiToast` | Theme-aware non-blocking overlay for `TsaiToast` | Public |
| `TsaiInlineAlertTone` | Info, success, error, and warning alert tones | Public |
| `TsaiInlineAlert` | Token-backed inline status message with optional title and dismiss control | Public |
| `TsaiProgressBarState` | Default, success, and error progress states | Public |
| `TsaiProgressBarLabelPosition` | Left, right, top, and both-label progress layouts | Public |
| `TsaiProgressBar` | Determinate four-pixel progress track with Penpot label arrangements | Public |
| `TsaiSpinnerSize` | 16, 24, and 32-pixel spinner sizes | Public |
| `TsaiSpinner` | Animated accent loading indicator | Public |
| `TsaiSkeletonSize` | Small, medium, and large placeholder sizes | Public |
| `TsaiSkeletonText` | Flexible-width text loading placeholder | Public |
| `TsaiSkeletonAvatar` | Circular avatar loading placeholder | Public |
| `TsaiSkeletonCard` | Flexible-width card loading placeholder | Public |
| `TsaiCard` | Token-backed card surface with optional header and arbitrary content | Public |
| `TsaiPageIndicator` | Page dots with one active pill | Public |
| `TsaiNumericKeypad` | Four-row numeric pad with decimal, integer, and PIN modes | Public |
| `TsaiKeypadMode` | Decimal, integer, and PIN bottom-left key treatments | Public |
| `TsaiActionTile` | Home quick-action tile | Public |
| `TsaiActionTileVariant` | Circle, card, and ghost plates | Public |
| `TsaiSlider` | Single-thumb continuous slider | Public |
| `TsaiStepper` | Pill quantity control | Public |
| `TsaiCalendarKind` | Date, date range, month, or year picker | Public |
| `TsaiCalendarView` | Day, month, and year grids | Public |
| `TsaiCalendarDayCell` | 44-pixel calendar day with range-band states | Public |
| `TsaiCalendarDayCellState` | Empty, standard, today, selected, range, disabled | Public |
| `TsaiCalendarHeader` | Chevrons plus tappable month and year | Public |
| `TsaiCalendarWeekdays` | Monday-first weekday labels | Public |
| `TsaiCalendarMonth` | Header, weekdays, and 6-week grid | Public |
| `TsaiPickerTile` | 108×44 month or year tile | Public |
| `TsaiPickerTileState` | Standard, current, selected, range, disabled | Public |
| `TsaiPeriodGrid` | 3×4 month or year grid | Public |
| `TsaiCalendarPicker` | Day / month / year drill-down body | Public |
| `showTsaiDatePicker` | Content-sized sheet for one day | Public |
| `showTsaiDateRangePicker` | Content-sized sheet for a day-to-day range | Public |
| `showTsaiMonthPicker` | Content-sized sheet for a month | Public |
| `showTsaiYearPicker` | Content-sized sheet for a year | Public |
| `TsaiDateField` | Input-styled field that opens the date sheet | Public |
| `TsaiDateRangeField` | Input-styled field that opens the range sheet | Public |
| `TsaiTimeField` | Input-styled field that opens the time sheet | Public |
| `TsaiMonthField` | Input-styled field that opens the month sheet | Public |
| `TsaiYearField` | Input-styled field that opens the year sheet | Public |
| `TsaiTimeColon` | 12-pixel colon with 12-pixel gaps | Public |
| `TsaiTimeWheelColumn` | Single hour or minute wheel | Public |
| `TsaiTimeWheel` | 342×220 hour and minute wheels | Public |
| `TsaiTimePicker` | Wheel time-of-day picker | Public |
| `showTsaiTimePicker` | Bottom sheet with deferred Cancel / Apply | Public |
| `TsaiBankCard` | Dark payment-card face with optional overlays | Public |
| `TsaiAmountDisplay` | Caption, amount, and subtitle stack | Public |
| `TsaiAmountAlignment` | Start and center amount stacks | Public |
| `TsaiDivider` | Hairline separator | Public |
| `TsaiAccordion` | Expandable title and body row | Public |
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
- bottom-navigation item geometry, glass pill, and destination state rendering;
- large circular icon surfaces used by empty states;
- example catalog implementation.

No generated Penpot model, router, state-management API, or application service
is exported.

The color-token contract exposes only `accentSuccess` and `accentError`; no
compatibility aliases or migration shims are part of the public surface.
