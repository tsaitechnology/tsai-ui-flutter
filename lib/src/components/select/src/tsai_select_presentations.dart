part of '../tsai_select.dart';

extension _TsaiSelectPresentations<T> on _TsaiSelectState<T> {
  Future<void> _showBottomSheet() async {
    _handleOpen();
    try {
      final selected = await showTsaiBottomSheet<TsaiSelectOption<T>>(
        context: context,
        title: widget.placeholder ?? 'Select an option',
        showCloseButton: false,
        child: Builder(
          builder: (context) {
            final tokens = TsaiThemeTokens.of(context);
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.menuMaxHeight),
              child: ListView(
                key: const ValueKey<String>('tsai-select-bottom-sheet'),
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: tokens.spacing.space8),
                children: [
                  for (final option in widget.options)
                    ListTile(
                      enabled: option.enabled,
                      leading: option.icon,
                      title: Text(
                        option.label,
                        style: tokens.typography.bodyLarge.copyWith(
                          color: option.enabled
                              ? tokens.colors.contentPrimary
                              : tokens.colors.contentTertiary,
                        ),
                      ),
                      trailing: option.value == widget.value
                          ? Icon(
                              LucideIcons.check,
                              size: 20,
                              color: tokens.colors.actionPrimary,
                            )
                          : null,
                      onTap: option.enabled
                          ? () => Navigator.of(context).pop(option)
                          : null,
                    ),
                ],
              ),
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
