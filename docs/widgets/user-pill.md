# UserPill

`UserPill` composes the public `Avatar` with a single-line user name inside the
40-pixel token-backed glass pill used by `HomeTopBar`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/avatars/user-pill){ target="_blank" rel="noopener" .md-button }

```dart
UserPill(
  name: 'Ilona T.',
  initials: 'IT',
  avatarUrl: avatarUrl,
  semanticLabel: 'Open profile',
  onPressed: openProfile,
)
```

`onPressed` is optional. The pill remains a display-only composition when the
callback is null.
