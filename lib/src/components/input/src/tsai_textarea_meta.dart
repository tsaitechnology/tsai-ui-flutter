part of '../tsai_textarea.dart';

/// Description and optional character counter under a textarea field.
class TsaiTextareaMetaRow extends StatelessWidget {
  /// Creates the Penpot meta row (`space-between`, 4-pixel gap above).
  const TsaiTextareaMetaRow({
    super.key,
    this.description,
    this.descriptionIsError = false,
    this.counterText,
    this.counterIsError = false,
  });

  /// Start-aligned helper or error copy.
  final String? description;

  /// Whether [description] uses the error color.
  final bool descriptionIsError;

  /// End-aligned `current/max` counter. Hidden when null.
  final String? counterText;

  /// Whether the counter uses the error color.
  final bool counterIsError;

  @override
  Widget build(BuildContext context) {
    if (description == null && counterText == null) {
      return const SizedBox.shrink();
    }
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    return Padding(
      padding: EdgeInsets.only(top: tokens.spacing.space4),
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: tokens.spacing.space4),
        child: Row(
          key: const ValueKey<String>('tsai-textarea-meta'),
          children: [
            if (description != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: tokens.spacing.space4,
                  ),
                  child: Text(
                    description!,
                    key: const ValueKey<String>('tsai-textarea-description'),
                    style: tokens.typography.captionMediumRegular.copyWith(
                      color: descriptionIsError
                          ? colors.accentError
                          : colors.contentSecondary,
                    ),
                  ),
                ),
              )
            else
              const Spacer(),
            if (counterText != null)
              Text(
                counterText!,
                key: const ValueKey<String>('tsai-textarea-counter'),
                style: tokens.typography.captionMediumRegular.copyWith(
                  color: counterIsError
                      ? colors.accentError
                      : colors.contentTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
