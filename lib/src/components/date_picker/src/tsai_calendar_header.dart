part of '../tsai_date_picker.dart';

/// Month or year title with previous and next chevrons.
class TsaiCalendarHeader extends StatelessWidget {
  /// Creates a 342×44 calendar header.
  const TsaiCalendarHeader({
    required this.title,
    super.key,
    this.onPrevious,
    this.onNext,
    this.previousEnabled = true,
    this.nextEnabled = true,
  });

  /// Centered period title, for example `August 2026`.
  final String title;

  /// Called by the previous chevron.
  final VoidCallback? onPrevious;

  /// Called by the next chevron.
  final VoidCallback? onNext;

  /// Whether the previous chevron is interactive.
  final bool previousEnabled;

  /// Whether the next chevron is interactive.
  final bool nextEnabled;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-calendar-header'),
      width: TsaiDatePickerMetrics.width,
      height: TsaiDatePickerMetrics.headerHeight,
      child: Row(
        children: [
          _HeaderChevron(
            key: const ValueKey<String>('tsai-calendar-prev'),
            icon: LucideIcons.chevron_left,
            semanticLabel: 'Previous period',
            enabled: previousEnabled,
            onPressed: onPrevious,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMediumMedium.copyWith(
                color: tokens.colors.contentPrimary,
              ),
            ),
          ),
          _HeaderChevron(
            key: const ValueKey<String>('tsai-calendar-next'),
            icon: LucideIcons.chevron_right,
            semanticLabel: 'Next period',
            enabled: nextEnabled,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _HeaderChevron extends StatelessWidget {
  const _HeaderChevron({
    required this.icon,
    required this.semanticLabel,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = TsaiThemeTokens.of(context).colors;
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        splashRadius: 16,
        tooltip: semanticLabel,
        onPressed: enabled ? onPressed : null,
        icon: TsaiIcon(
          icon,
          size: 20,
          color: enabled ? colors.iconSecondary : colors.iconTertiary,
        ),
      ),
    );
  }
}
