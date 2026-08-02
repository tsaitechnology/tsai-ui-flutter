# Avatar

`Avatar` is the fixed 32-pixel avatar from the Penpot Icons page. It displays
initials on the strong-border color token while a network image is absent,
loading, or unavailable.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/avatars/avatar){ target="_blank" rel="noopener" .md-button }

```dart
const Avatar(
  initials: 'IT',
  image: NetworkImage(avatarUrl),
  semanticLabel: 'Ilona T.',
)
```

`image` accepts any `ImageProvider`, including network, asset, memory, and file
providers. `imageUrl` remains available as a network-image convenience. When
the image is absent, loading, or fails, the avatar displays `initials`.
