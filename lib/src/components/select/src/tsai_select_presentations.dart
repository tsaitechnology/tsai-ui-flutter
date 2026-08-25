part of '../tsai_select.dart';

extension _TsaiSelectPresentations<T> on _TsaiSelectState<T> {
  Future<void> _showBottomSheet() async {
    _handleOpen();
    try {
      final selected = await showTsaiBottomSheet<TsaiSelectOption<T>>(
        context: context,
        title: widget.placeholder ?? 'Select an option',
        size: TsaiBottomSheetSize.half,
        showCloseButton: true,
        child: Builder(
          builder: (context) {
            final tokens = TsaiThemeTokens.of(context);
            return ListView.separated(
              key: const ValueKey<String>('tsai-select-bottom-sheet'),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: tokens.spacing.space8),
              itemCount: widget.options.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: tokens.spacing.space8),
              itemBuilder: (context, index) {
                final option = widget.options[index];
                return TsaiListItem(
                  active: option.value == widget.value,
                  icon: option.icon,
                  showChevron: false,
                  semanticLabel: option.label,
                  content: TsaiTextBody(
                    option.label,
                    size: TsaiBodySize.medium,
                    weight: TsaiTextWeight.medium,
                    color: option.enabled
                        ? tokens.colors.contentPrimary
                        : tokens.colors.contentTertiary,
                  ),
                  onTap: option.enabled
                      ? () => Navigator.of(context).pop(option)
                      : null,
                );
              },
            );
          },
        ),
      );
      if (selected != null) {
        widget.onChanged?.call(selected.value);
      }
    } finally {
      _handleClose();
      _focusNode.requestFocus();
    }
  }
}
