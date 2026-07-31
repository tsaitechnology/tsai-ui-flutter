# BottomNavBar

A controlled glass bottom-navigation bar with one to four fixed-size
destinations.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/bottom-nav-bar){ target="_blank" rel="noopener" .md-button }

```dart
var selectedIndex = 0;

BottomNavBar(
  items: const [
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.chart_no_axes_column, size: 20),
      label: 'Stats',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.credit_card, size: 20),
      label: 'Cards',
    ),
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.user, size: 20),
      label: 'Profile',
    ),
  ],
  selectedIndex: selectedIndex,
  onSelected: (index) => setState(() => selectedIndex = index),
);
```

## Layout

`items` must contain between one and four destinations. Every destination keeps
the Penpot `80 × 54` pixel size. The centered glass pill changes width with the
item count:

| Items | Pill width |
| ---: | ---: |
| 1 | 88 px |
| 2 | 168 px |
| 3 | 248 px |
| 4 | 328 px |

The extra eight pixels are the four-pixel pill padding on both sides. The
full-width outer bar is 94 pixels high and uses the theme's bottom scrim asset.
It does not add a system safe area.

## State And Semantics

`selectedIndex` is caller-owned. Activating an item calls `onSelected` once
with its index; the caller must rebuild with the new selection. Selected items
expose selected-button semantics. `BottomNavBarItem.semanticLabel` overrides
the visible label for assistive technology when needed.

The selected item uses the semantic accent-glass surface, bright icon, and
accent text roles. Other items use secondary icon and text roles. The pill
uses `surfaceGlass`, the hairline border, pill radius, and `glassBlur`.

Pointer hover does not add a background. Pressed and selected background
changes animate with `motion.interaction` and respect the platform
reduced-motion setting.

On viewports narrower than the four-item pill, item geometry remains fixed and
the centered pill extends symmetrically beyond the viewport instead of
shrinking or overflowing its internal layout.
