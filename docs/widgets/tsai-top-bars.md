# Tsai top bars

Token-backed top bars for home and secondary pages, plus a page composition
that moves its heading into a pinned bar when scrolling starts.

[HomeTopBar example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/top-bars/home){ target="_blank" rel="noopener" .md-button }
[PageTopBar example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/top-bars/page){ target="_blank" rel="noopener" .md-button }
[PageWithTopBar example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/top-bars/page-layout){ target="_blank" rel="noopener" .md-button }
[PageWithSearchTopBar example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/top-bars/page-search-layout){ target="_blank" rel="noopener" .md-button }

## Home top bar

`HomeTopBar` is 76 pixels high and accepts lists of widgets at both directional
edges. Items in each list use the Penpot eight-pixel gap. Its background uses
the theme's reusable top scrim asset, while the reusable `UserPill` and
`HomeTopBarAction` use token-backed glass surfaces and backdrop blur.

Place the bar above the page scroll view in a `Stack`. Give the scrollable a
76-pixel leading content inset instead of reserving a separate layout row for
the bar. The content then starts below the bar at rest and scrolls underneath
its scrim and glass controls.

```dart
Stack(
  fit: StackFit.expand,
  children: [
    SingleChildScrollView(
      padding: const EdgeInsets.only(top: 76),
      child: const HomeContents(),
    ),
    const PositionedDirectional(
      top: 0,
      start: 0,
      end: 0,
      child: HomeTopBar(/* ... */),
    ),
  ],
)
```

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

`UserPill` composes the public 32-pixel `Avatar`. It displays `initials` while the
image is loading and when the URL is absent, empty, or fails. `onPressed` is
optional, so the pill can be display-only.

`HomeTopBarAction.showIndicator` is a generic attention state. It is not tied
to notifications and can be used by any home action.

## Page top bar

`PageTopBar` is 56 pixels high and fills the available width. Its leading,
title, and trailing content uses symmetric one-two-one tracks. Showing or
hiding the title therefore does not resize the bar or move either action list.
The bar uses the token-backed translucent canvas surface and background blur,
so scrolling content remains visible without competing with its controls.

```dart
PageTopBar(
  leading: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.arrow_left),
      semanticLabel: 'Back',
      onPressed: Navigator.of(context).pop,
    ),
  ],
  title: 'Card details',
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

`title` accepts text and applies the Penpot large-body text style. `leading`
and `trailing` are external widget lists; they can contain actions, text, or
another compact composition. The bar uses a symmetric one-two-one track layout
to keep the title geometrically centered and clip each track inside its own
bounds.

Both action types require a `TsaiIcon` and semantic label. Set `onPressed` to
null for a disabled action.

## Scroll-owning page

`PageWithTopBar` keeps `PageTopBar` pinned above one full-height
`SingleChildScrollView`. A leading inset inside that scroll document places the
expanded heading below the bar at rest. The heading and body then move under
the bar as one document. At rest, the bar has no background or backdrop blur;
its glass surface appears after the scroll offset becomes positive.
Its `heading` and optional `subtitle` are text values, so the title area cannot
be replaced with an unrelated widget.
After any positive scroll offset, the expanded `TsaiTitle` is replaced by a
moving primary heading while the subtitle is removed. The heading moves into
the centered title position as its typography animates from `headingExtraLarge`
to `bodyLargeMedium`. Returning to offset zero completes the reverse movement
before restoring `TsaiTitle`. Motion uses the token-backed ease-in-out curve
and becomes immediate when reduced motion is enabled.

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
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.ellipsis),
      semanticLabel: 'More',
      onPressed: openMenu,
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

## Scroll page with search

`PageWithSearchTopBar` pins the Penpot scroll-state composition: a 56-pixel
`PageTopBar`, an eight-pixel gap, a 40-pixel `TsaiSearchInput`, and an
eight-pixel lower inset inside one 112-pixel glass header. The owned document
starts with a 120-pixel inset and scrolls underneath that header.

```dart
PageWithSearchTopBar(
  title: 'Card details',
  search: TsaiSearchInput(
    controller: searchController,
    onChanged: filterCards,
  ),
  leading: [
    PageTopBarAction(
      icon: const TsaiIcon(LucideIcons.arrow_left),
      semanticLabel: 'Back',
      onPressed: Navigator.of(context).pop,
    ),
  ],
  body: const CardDetailsContent(),
)
```

The `search` slot is typed as `TsaiSearchInput`, preserving the design geometry
while leaving query ownership with the caller. As with `PageWithTopBar`, the
body must have finite intrinsic height and must not contain another unbounded
primary scroll view.

## Safe areas

The 76- and 56-pixel values are the visual component heights from Penpot.
`HomeTopBar`, `PageTopBar`, `PageWithTopBar`, and `PageWithSearchTopBar` do not add a system safe area.
Place the composition inside `SafeArea` when the screen can extend under system
status regions.
