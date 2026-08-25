import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../typography/tsai_text.dart';

/// A dark payment-card face matching the Penpot Bank Card.
///
/// The card stays dark in both themes. Every overlay is optional.
class TsaiBankCard extends StatelessWidget {
  /// Creates a bank card.
  const TsaiBankCard({
    super.key,
    this.wordmark = 'tsaitech',
    this.showContactless = true,
    this.number = '•••• 4821',
    this.network = 'VISA',
  });

  /// Brand wordmark in the top-leading corner. Hidden when null.
  final String? wordmark;

  /// Whether to show the rotated contactless glyph.
  final bool showContactless;

  /// Masked PAN in the bottom-leading corner. Hidden when null.
  final String? number;

  /// Network mark in the bottom-trailing corner. Hidden when null.
  final String? network;

  static const _faceWhite = Color(0xEBFFFFFF);
  static const _networkWhite = Color(0xE6FFFFFF);
  static const _hairline = Color(0x1FFFFFFF);
  static const _graphiteStart = Color(0xFF1E1E24);
  static const _graphiteEnd = Color(0xFF101014);
  static const _indigo = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tokens.radii.card),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            offset: Offset(0, 16),
            blurRadius: 40,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radii.card),
        child: SizedBox(
          key: const ValueKey<String>('tsai-bank-card'),
          width: 342,
          height: 214,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_graphiteStart, _graphiteEnd],
                  ),
                ),
                child: SizedBox.expand(),
              ),
              Positioned(
                left: 180,
                top: -120,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _indigo.withValues(alpha: 0.32),
                          _indigo.withValues(alpha: 0),
                        ],
                      ),
                    ),
                    child: const SizedBox(width: 300, height: 300),
                  ),
                ),
              ),
              Positioned(
                left: -80,
                top: 140,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _indigo.withValues(alpha: 0.14),
                          _indigo.withValues(alpha: 0),
                        ],
                      ),
                    ),
                    child: const SizedBox(width: 220, height: 220),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radii.card),
                    border: Border.all(
                      color: _hairline,
                      width: tokens.borders.hairline,
                    ),
                  ),
                ),
              ),
              if (wordmark case final mark?)
                Positioned(
                  left: tokens.spacing.space24,
                  top: 26,
                  child: Text(
                    mark,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      package: 'tsai_ui',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.5,
                      color: _faceWhite,
                    ),
                  ),
                ),
              if (showContactless)
                Positioned(
                  left: 296,
                  top: 28,
                  child: Transform.rotate(
                    angle: math.pi / 2,
                    child: const TsaiIcon(
                      LucideIcons.wifi,
                      size: 22,
                      color: _faceWhite,
                    ),
                  ),
                ),
              if (number case final pan?)
                Positioned(
                  left: tokens.spacing.space24,
                  top: 166,
                  child: TsaiTextMonoBody(
                    pan,
                    size: TsaiBodySize.large,
                    color: _faceWhite,
                  ),
                ),
              if (network case final mark?)
                Positioned(
                  left: 271,
                  top: 164,
                  child: Text(
                    mark,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      package: 'tsai_ui',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: 1,
                      color: _networkWhite,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
