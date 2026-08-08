# TsaiBottomSheet

A rounded, glow-backed bottom-sheet surface with half and full Penpot heights,
a centered app bar, composable content and actions, and an optional close
button.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/bottom-sheet){ target="_blank" rel="noopener" .md-button }

```dart
final result = await showTsaiBottomSheet<bool>(
  context: context,
  title: 'Confirm transfer',
  size: TsaiBottomSheetSize.half,
  child: const TransferSummary(),
  secondaryAction: Builder(
    builder: (context) => TsaiButton(
      label: 'Cancel',
      variant: TsaiButtonVariant.secondary,
      onPressed: () => Navigator.pop(context, false),
    ),
  ),
  primaryAction: Builder(
    builder: (context) => TsaiButton(
      label: 'Confirm',
      onPressed: () => Navigator.pop(context, true),
    ),
  ),
);
```

Use `TsaiBottomSheet` directly when another route or scaffold already owns the
overlay. `showTsaiBottomSheet` installs the theme-aware modal barrier, clamps
the design height to the viewport, supports drag and outside dismissal, and
returns the value passed to `Navigator.pop`.
