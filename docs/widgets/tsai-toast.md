# TsaiToast

A compact 48-pixel glass notification in the Undo, Action, and Info
compositions defined in Penpot.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/feedback/toast){ target="_blank" rel="noopener" .md-button }

```dart
await showTsaiToast(
  context: context,
  variant: TsaiToastVariant.undo,
  message: 'Item deleted',
  actionLabel: 'Undo',
  onAction: restoreItem,
);
```

`TsaiToast` is the visual surface. `showTsaiToast` presents it as a
non-blocking overlay, animates the undo countdown, auto-dismisses after five
seconds, and returns `TsaiToastDismissReason`. Presenting a new Toast replaces
any Toast already on screen.

The overlay is centered horizontally and sits 12 pixels above overlapping
chrome. Pass `bottomClearance: BottomNavBar.barHeightOf(context)` when a
bottom navigation bar overlays the screen, matching the Penpot Toast screens.

Use `info` for a message with dismissal only and `action` for an action plus
close control. Embed `TsaiToast` directly only when the host already owns
placement, such as a catalog preview.
