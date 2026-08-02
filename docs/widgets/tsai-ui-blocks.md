# Tsai UI Blocks

Reusable section, empty-state, row, and list compositions backed by semantic
tokens. The components accept widgets in their visual slots so application
typography and business data remain outside the library.

[Section Header example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/ui-blocks/section-header){ target="_blank" rel="noopener" .md-button }
[Empty State example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/ui-blocks/empty-state){ target="_blank" rel="noopener" .md-button }
[List Item example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/ui-blocks/list-item){ target="_blank" rel="noopener" .md-button }
[List example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/ui-blocks/list){ target="_blank" rel="noopener" .md-button }

## Section Header

```dart
const TsaiSectionHeader(
  title: 'Transactions',
  trailingIcon: TsaiIcon(LucideIcons.search, size: 16),
)
```

## Empty State

```dart
TsaiEmptyState(
  icon: const TsaiIcon(LucideIcons.coffee, size: 28),
  title: 'No transactions yet',
  description: 'New transactions will show up here.',
  button: TsaiButton(
    label: 'Add money',
    size: TsaiButtonSize.medium,
    variant: TsaiButtonVariant.secondary,
    onPressed: addMoney,
  ),
)
```

## List Item

`content` is required. `icon`, `trailing`, and the standard chevron are
optional. The caller owns typography and layout inside `content` and
`trailing`. Set `active` to display the selected background and provide
`onTap` when the row is interactive.

```dart
TsaiListItem(
  icon: const TsaiIcon(LucideIcons.coffee, size: 20),
  content: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TsaiTextBody(
        'Blue Bottle',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.medium,
      ),
      TsaiTextCaption(
        'Coffee · Today',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
      ),
    ],
  ),
  trailing: const TsaiTextMonoBody(
    '-\$4.50',
    size: TsaiBodySize.medium,
  ),
  showChevron: true,
  onTap: openTransaction,
)
```

## List

`TsaiList` composes a `TsaiSectionHeader`, ordered `TsaiListItem` widgets, and
an optional bottom button with the Penpot spacing contract.

```dart
TsaiList(
  title: 'Transactions',
  items: transactionItems,
  button: TsaiButton(
    label: 'Show all',
    size: TsaiButtonSize.medium,
    variant: TsaiButtonVariant.outline,
    isExpanded: true,
    onPressed: showAll,
  ),
)
```

The circular icon surface is an internal layout detail. Pass any icon widget
supported by the application; no separate icon-circle API is required.
