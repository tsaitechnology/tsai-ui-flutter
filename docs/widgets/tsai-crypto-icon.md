# TsaiCryptoIcon

`TsaiCryptoIcon` renders the 15 full-color cryptocurrency assets synchronized
from the Penpot icon pack. Each asset already includes its circular brand
background and occupies a stable square icon slot.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/icons/crypto-icon){ target="_blank" rel="noopener" .md-button }

```dart
import 'package:tsai_ui/tsai_icons.dart';

const TsaiCryptoIcon(
  TsaiCryptoAsset.btc,
  size: 24,
  semanticLabel: 'Bitcoin',
)
```

Available assets are `btc`, `eth`, `usdt`, `xrp`, `bnb`, `sol`, `usdc`,
`doge`, `ada`, `trx`, `link`, `avax`, `xlm`, `ltc`, and `dot`.

Do not wrap the icon in `CircleIcon` by default: that produces a second circle
around artwork that is already circular. Use `CircleIcon` only when the product
needs an explicit additional surface or interactive treatment. Omit
`semanticLabel` when a nearby visible label already identifies the asset.

The vector artwork comes from Iconify's `cryptocurrency-color` set and is
included under CC0 1.0; see `THIRD_PARTY_NOTICES.md` for attribution details.
