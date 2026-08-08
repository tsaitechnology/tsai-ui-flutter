import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'src/crypto_icon_data.dart';
import 'tsai_icon.dart';

/// Cryptocurrency assets included in the Penpot icon pack.
enum TsaiCryptoAsset {
  /// Bitcoin.
  btc,

  /// Ethereum.
  eth,

  /// Tether USD.
  usdt,

  /// XRP.
  xrp,

  /// BNB.
  bnb,

  /// Solana.
  sol,

  /// USD Coin.
  usdc,

  /// Dogecoin.
  doge,

  /// Cardano.
  ada,

  /// TRON.
  trx,

  /// Chainlink.
  link,

  /// Avalanche.
  avax,

  /// Stellar.
  xlm,

  /// Litecoin.
  ltc,

  /// Polkadot.
  dot,
}

/// A scalable, full-color cryptocurrency icon from the Penpot asset pack.
///
/// The artwork already contains its own circular background. Wrap this widget
/// in [CircleIcon] only when an additional product surface is intentional.
class TsaiCryptoIcon extends StatelessWidget {
  /// Creates a Tsai cryptocurrency icon.
  const TsaiCryptoIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.semanticLabel,
  }) : assert(size > 0);

  /// Cryptocurrency artwork to render.
  final TsaiCryptoAsset asset;

  /// Square icon extent in logical pixels.
  final double size;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => TsaiIcon.custom(
    SvgPicture.string(
      tsaiCryptoIconData[asset.name]!,
      key: ValueKey<String>('tsai-crypto-${asset.name}'),
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    ),
    size: size,
    semanticLabel: semanticLabel,
  );
}
