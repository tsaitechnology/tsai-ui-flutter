part of '../tsai_date_picker.dart';

/// Penpot Time Picker colon: 12-pixel glyph with 12-pixel gaps on each side.
class TsaiTimeColon extends StatelessWidget {
  /// Creates the colon separator between hour and minute wheels.
  const TsaiTimeColon({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TsaiDatePickerMetrics.colonGap,
      ),
      child: SizedBox(
        key: const ValueKey<String>('tsai-time-colon'),
        width: TsaiDatePickerMetrics.colonWidth,
        height: TsaiDatePickerMetrics.timeRow,
        child: Center(
          child: Text(
            ':',
            style: tokens.typography.bodyLarge.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: tokens.colors.contentPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
