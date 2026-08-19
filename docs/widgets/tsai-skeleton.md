# Tsai Skeleton

Text, avatar, and card loading placeholders in small, medium, and large sizes.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/feedback/skeleton){ target="_blank" rel="noopener" .md-button }

```dart
Row(
  children: [
    const TsaiSkeletonAvatar(size: TsaiSkeletonSize.medium),
    const SizedBox(width: 12),
    const Expanded(child: TsaiSkeletonText()),
  ],
)
```

All placeholders use the theme's `surfaceSkeleton` color. The shimmer runs for
1.4 seconds and is automatically disabled when reduced motion is requested.
Set `animate` to `false` for a static placeholder and provide `semanticLabel`
only when a loading announcement adds useful context.
