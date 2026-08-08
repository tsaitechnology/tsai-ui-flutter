# TsaiSearchInput

A compact 40-pixel search field with search keyboard submission, focus styling,
an optional clear action, disabled styling, and controller or initial-value
ownership.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input-search){ target="_blank" rel="noopener" .md-button }

```dart
TsaiSearchInput(
  placeholder: 'Search assets',
  semanticLabel: 'Asset search',
  onChanged: (query) => setState(() => searchQuery = query),
  onSubmitted: runSearch,
)
```

Do not provide both `controller` and `initialValue`. The clear action is shown
only for a non-empty enabled field and returns keyboard focus to the editable.
The component uses `TextInputAction.search` and preserves native text-field
keyboard and screen-reader behavior.
