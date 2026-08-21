// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../badge/tsai_badge.dart';

/// Overlay shown on an icon button.
sealed class TsaiIconButtonBadge {
  const TsaiIconButtonBadge();
}

/// No notification overlay.
class TsaiIconButtonBadgeNone extends TsaiIconButtonBadge {
  const TsaiIconButtonBadgeNone();
}

/// An 8 pixel notification dot.
class TsaiIconButtonBadgeDot extends TsaiIconButtonBadge {
  const TsaiIconButtonBadgeDot({this.tone = TsaiBadgeTone.accent});
  final TsaiBadgeTone tone;
}

/// A notification count overlay.
class TsaiIconButtonBadgeCount extends TsaiIconButtonBadge {
  const TsaiIconButtonBadgeCount(
    this.value, {
    this.tone = TsaiBadgeTone.accent,
  });
  final int value;
  final TsaiBadgeTone tone;
}

/// A 40 pixel icon button with optional badge overlay.
class TsaiIconButton extends StatelessWidget {
  const TsaiIconButton({
    required this.icon,
    required this.onPressed,
    this.badge = const TsaiIconButtonBadgeNone(),
    super.key,
  });
  final Widget icon;
  final VoidCallback? onPressed;
  final TsaiIconButtonBadge badge;
  @override
  Widget build(BuildContext context) {
    final t = TsaiThemeTokens.of(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            icon: IconTheme.merge(
              data: IconThemeData(color: t.colors.iconPrimary, size: 20),
              child: icon,
            ),
          ),
          if (badge case TsaiIconButtonBadgeDot(:final tone))
            Positioned(top: 2.5, right: 3.5, child: TsaiBadgeDot(tone: tone)),
          if (badge case TsaiIconButtonBadgeCount(:final value, :final tone))
            Positioned(
              top: 0,
              right: 0,
              child: TsaiBadgeCounter(value: value, tone: tone),
            ),
        ],
      ),
    );
  }
}
