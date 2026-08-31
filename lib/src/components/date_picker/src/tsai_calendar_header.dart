part of '../tsai_date_picker.dart';

/// Navigation row: chevrons plus optional month and year actions.
class TsaiCalendarHeader extends StatelessWidget {
  /// Creates a 342×44 calendar header.
  const TsaiCalendarHeader({
    super.key,
    this.title,
    this.monthLabel,
    this.yearLabel,
    this.onMonthPressed,
    this.onYearPressed,
    this.onPrevious,
    this.onNext,
    this.previousEnabled = true,
    this.nextEnabled = true,
  });

  /// Non-interactive title, used on the year grid.
  final String? title;

  /// Tappable month name on the day grid.
  final String? monthLabel;

  /// Tappable year on the day or month grid.
  final String? yearLabel;

  /// Opens the month grid.
  final VoidCallback? onMonthPressed;

  /// Opens the year grid.
  final VoidCallback? onYearPressed;

  /// Previous chevron.
  final VoidCallback? onPrevious;

  /// Next chevron.
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
            enabled: previousEnabled && onPrevious != null,
            onPressed: onPrevious,
          ),
          Expanded(child: _titleRow(tokens)),
          _HeaderChevron(
            key: const ValueKey<String>('tsai-calendar-next'),
            icon: LucideIcons.chevron_right,
            semanticLabel: 'Next period',
            enabled: nextEnabled && onNext != null,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }

  Widget _titleRow(TsaiThemeTokens tokens) {
    final style = tokens.typography.bodyMediumMedium.copyWith(
      color: tokens.colors.contentPrimary,
    );
    if (title != null) {
      return Text(title!, textAlign: TextAlign.center, style: style);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (monthLabel != null) ...[
          _HeaderTextButton(
            key: const ValueKey<String>('tsai-calendar-month-button'),
            label: monthLabel!,
            onPressed: onMonthPressed,
            style: style,
          ),
          if (yearLabel != null) SizedBox(width: tokens.spacing.space8),
        ],
        if (yearLabel != null)
          _HeaderTextButton(
            key: const ValueKey<String>('tsai-calendar-year-button'),
            label: yearLabel!,
            onPressed: onYearPressed,
            style: style,
          ),
      ],
    );
  }
}

class _HeaderTextButton extends StatelessWidget {
  const _HeaderTextButton({
    required this.label,
    required this.style,
    super.key,
    this.onPressed,
  });

  final String label;
  final TextStyle style;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(label, style: style),
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
