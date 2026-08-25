# BottomNavBar

A controlled glass bottom-navigation bar with one to five responsive
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
    BottomNavBarItem(
      icon: TsaiIcon(LucideIcons.settings, size: 20),
      label: 'Settings',
    ),
  ],
  selectedIndex: selectedIndex,
  onSelected: (index) => setState(() => selectedIndex = index),
);
```

## Layout

`items` must contain between one and five destinations. The component first
uses `80 × 54` destinations when they fit:

| Items | Preferred pill |
| ---: | ---: |
| 1 | 88 px |
| 2 | 168 px |
| 3 | 248 px |
| 4 | 328 px |
| 5 | 408 px |

The extra eight pixels are the four-pixel pill padding on both sides. When the
preferred width does not fit with 16-pixel outer margins, the pill uses the
available parent width minus 32 pixels and every destination receives an equal
share of its content width. The same sizing rule applies to all variants from
one to five destinations.

The full-width outer bar is 94 pixels high and uses the theme's bottom scrim
asset. It does not add a system safe area. Width is resolved from parent layout
constraints rather than the global screen size.

## App Shell Integration

Keep the bar outside individual pages and overlay it at the application-shell
level. This lets every page use the full viewport and scroll underneath the
scrim. `PageWithTopBar` applies the same overlay model independently at the top
of each page.

[Open composed app example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/app-examples/two-pages){ target="_blank" rel="noopener" .md-button }

```dart
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bottomContentInset = 94 + MediaQuery.paddingOf(context).bottom;
    // Flutter reports the on-screen keyboard as viewInsets on both iOS and
    // Android. Read it here, above Scaffold.body, then hide the overlay bar
    // while the keyboard is open so it does not cover the focused field.
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final pages = [
      PageWithTopBar(
        heading: 'Home',
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomContentInset),
          child: const HomeContent(),
        ),
      ),
      PageWithTopBar(
        heading: 'Cards',
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomContentInset),
          child: const CardsContent(),
        ),
      ),
      PageWithTopBar(
        heading: 'Profile',
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomContentInset),
          child: const ProfileContent(),
        ),
      ),
    ];

    return Scaffold(
      // Keep the default true so form pages can still resize/scroll away from
      // the keyboard. Only the navigation overlay is suppressed below.
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(index: selectedIndex, children: pages),
          if (!keyboardVisible)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: BottomNavBar(
                  items: const [
                    BottomNavBarItem(
                      icon: TsaiIcon(LucideIcons.house, size: 20),
                      label: 'Home',
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

The terminal body padding is page content, not part of BottomNavBar layout. It
allows the final content to scroll above the overlay when necessary while
still rendering behind it during normal scrolling.

### Keyboard

Bottom navigation must not sit on top of the keyboard and cover the focused
field. Prefer this shell-owned pattern:

1. Own the app `Scaffold` in the shell. Leave
   `resizeToAvoidBottomInset` at its default `true` so form pages can still
   resize and scroll the focused input into view.
2. Detect the keyboard in that shell `State.build` with
   `MediaQuery.viewInsetsOf(context).bottom > 0`. That context sits above the
   Scaffold body, so it still sees the real keyboard inset. (Scaffold removes
   `viewInsets` from the MediaQuery it passes into its body.)
3. Omit the BottomNavBar overlay while the keyboard is open. When the keyboard
   closes, show the bar again.

Do not solve this by setting `resizeToAvoidBottomInset: false` on the shell
unless you intentionally want the keyboard to cover page content too. That
flag stops the body from resizing; it does not make an overlay at `bottom: 0`
stay under the keyboard by itself, and it often leaves form fields harder to
reach.

If the bar is wired through `Scaffold.bottomNavigationBar` instead of a
`Stack` overlay, use the same visibility check:

```dart
bottomNavigationBar: keyboardVisible ? null : const AppBottomNav(),
```

If the navigation shell must live inside another Scaffold's body (for
example, a catalog host), ambient `viewInsets` are already zero and the body
may not rebuild on keyboard changes. In that case observe metrics instead:

```dart
class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  var keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final next =
        MediaQueryData.fromView(View.of(context)).viewInsets.bottom > 0;
    if (next != keyboardVisible) {
      setState(() => keyboardVisible = next);
    }
  }
}
```

Flutter unifies iOS and Android here: both platforms expose keyboard coverage
as `viewInsets`, even though the native soft-input policies differ. Keep
Android on `adjustResize` (Flutter's default activity setting) so `viewInsets`
update correctly.

Keep this shell inside the application's root Navigator route. Dialogs and
modal bottom sheets pushed onto that Navigator then render above the complete
shell, including BottomNavBar. With nested branch Navigators, present global
modals through the root Navigator. Do not place the bar after the Navigator
using `MaterialApp.builder`, because that can paint it above modal routes.

The library intentionally does not provide an app-shell widget. Page
selection, route stacks, state restoration, keyboard shell policy, and modal
ownership are application architecture concerns. Applications using a router
can implement the same layering in its shell-route facility instead of
`IndexedStack`.

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

The preferred and fit modes use the same semantics and interaction behavior.
