# TsaiAccordion

An expandable settings or FAQ row. The header is 56 pixels with Body M Medium
and a 20-pixel chevron that rotates when expanded. The body uses Body M Regular
and 16 pixels of bottom padding.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/accordion){ target="_blank" rel="noopener" .md-button }

```dart
TsaiAccordion(
  title: 'How do transfers work?',
  body: 'Transfers between TsaiTech accounts are instant and free.',
  expanded: isOpen,
  showDivider: true,
  onChanged: (value) => setState(() => isOpen = value),
)
```

Set `showDivider` on every stacked row except the last.
