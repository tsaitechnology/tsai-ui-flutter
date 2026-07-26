# Tsai top bars

Token-backed top bars for home and secondary pages, plus a page composition
that moves its heading into a pinned bar when scrolling starts.

[Live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/top-bars){ target="_blank" rel="noopener" .md-button }

## Home top bar

`HomeTopBar` is 64 pixels high and accepts lists of widgets at both directional
edges. Items in each list use the Penpot eight-pixel gap.

```dart
HomeTopBar(
  leading: [
    UserPill(
      name: user.displayName,
      initials: user.initials,
      avatarUrl: user.avatarUrl,
      semanticLabel: 'Open profile',
      onPressed: openProfile,
    ),
  ],
  trailing: [
    HomeTopBarAction(
      icon: const TsaiIcon(LucideIcons.scan_line),
      semanticLabel: 'Scan',
      onPressed: scan,
    ),
    HomeTopBarAction(
      icon: const TsaiIcon(LucideIcons.bell),
      semanticLabel: 'Notifications',
      showIndicator: hasUnreadNotifications,
      onPressed: openNotifications,
    ),
  ],
)
```

`UserPill` renders a 32-pixel network avatar. It displays `initials` while the
image is loading and when the URL is absent, empty, or fails. `onPressed` is
optional, so the pill can be display-only.

`HomeTopBarAction.showIndicator` is a generic attention state. It is not tied
to notifications and can be used by any home action.

## Page top bar

`PageTopBar` is 56 pixels high and fills the available width. Its leading,
center, and trailing layers are positioned independently. Showing or hiding
the title therefore does not resize the bar or move either action list.

```dart
PageTopBar(
  leading: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.arrow_left),
      semanticLabel: 'Back',
      onPressed: Navigator.of(context).pop,
    ),
  ],
  title: const Text('Card details'),
  trailing: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.plus),
      semanticLabel: 'Add',
      onPressed: addCard,
    ),
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.ellipsis),
      semanticLabel: 'More',
      onPressed: openMenu,
    ),
  ],
)
```

The title slot accepts any widget and supplies the Penpot large-body text style
through `DefaultTextStyle`. Both action types require a `TsaiIcon` and semantic
label. Set `onPressed` to null for a disabled action.

## Scroll-owning page

`PageWithTopBar` keeps `PageTopBar` pinned and owns one
`SingleChildScrollView`. The expanded heading and body move as one document.
After any positive scroll offset, the single heading instance moves from its
expanded position into the centered title slot while its typography animates
from `headingExtraLarge` to `bodyLargeMedium`. Returning to offset zero reverses
the same movement. Motion uses `TsaiMotionTokens` and becomes immediate when
reduced motion is enabled.

```dart
PageWithTopBar(
  heading: 'Portfolio',
  subtitle: 'Main account',
  leading: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.arrow_left),
      semanticLabel: 'Back',
      onPressed: Navigator.of(context).pop,
    ),
  ],
  trailing: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.plus),
      semanticLabel: 'Add position',
      onPressed: addPosition,
    ),
  ],
  body: const PortfolioContents(),
)
```

The `body` must have finite intrinsic height. Do not pass a primary `ListView`
or another unbounded scroll view; build rows or sections directly so the
heading and content share the owned scroll position.

Pass `controller` to observe or change the position. When it is omitted,
`PageWithTopBar` creates and disposes its own controller. `physics` customizes
the owned scrollable.

## Safe areas

The 64- and 56-pixel values are the visual component heights from Penpot.
`HomeTopBar`, `PageTopBar`, and `PageWithTopBar` do not add a system safe area.
Place the composition inside `SafeArea` when the screen can extend under system
status regions.
