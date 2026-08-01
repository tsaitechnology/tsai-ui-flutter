part of '../tsai_select.dart';

extension _TsaiSelectPresentations<T> on _TsaiSelectState<T> {
  Future<void> _showBottomSheet() async {
    _handleOpen();
    try {
      final selected = await showModalBottomSheet<TsaiSelectOption<T>>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: widget.menuMaxHeight),
        builder: (context) {
          final tokens = TsaiThemeTokens.of(context);
          return SafeArea(
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
      );
      if (selected != null) {
        widget.onChanged?.call(selected.value);
      }
    } finally {
      _handleClose();
      _focusNode.requestFocus();
    }
  }

  Future<void> _showCupertinoPicker() async {
    var selectedIndex = _initialPickerIndex();
    _handleOpen();
    try {
      final selected = await showCupertinoModalPopup<TsaiSelectOption<T>>(
        context: context,
        builder: (context) {
          final tokens = TsaiThemeTokens.of(context);
          final background = CupertinoDynamicColor.resolve(
            CupertinoColors.systemBackground,
            context,
          );
          return StatefulBuilder(
            builder: (context, setModalState) => ColoredBox(
              color: background,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  key: const ValueKey<String>('tsai-select-cupertino-picker'),
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            CupertinoButton(
                              onPressed:
                                  widget.options.isNotEmpty &&
                                      widget.options[selectedIndex].enabled
                                  ? () => Navigator.of(
                                      context,
                                    ).pop(widget.options[selectedIndex])
                                  : null,
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: widget.options.isEmpty
                            ? Center(
                                child: Text(
                                  'No options',
                                  style: tokens.typography.bodyLarge.copyWith(
                                    color: tokens.colors.contentTertiary,
                                  ),
                                ),
                              )
                            : CupertinoPicker(
                                itemExtent: 44,
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedIndex,
                                ),
                                onSelectedItemChanged: (index) =>
                                    setModalState(() => selectedIndex = index),
                                children: [
                                  for (final option in widget.options)
                                    Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (option.icon != null) ...[
                                            option.icon!,
                                            SizedBox(
                                              width: tokens.spacing.space8,
                                            ),
                                          ],
                                          Text(
                                            option.label,
                                            style: tokens.typography.bodyLarge
                                                .copyWith(
                                                  color: option.enabled
                                                      ? tokens
                                                            .colors
                                                            .contentPrimary
                                                      : tokens
                                                            .colors
                                                            .contentTertiary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      if (selected != null) {
        widget.onChanged?.call(selected.value);
      }
    } finally {
      _handleClose();
      _focusNode.requestFocus();
    }
  }

  int _initialPickerIndex() {
    final selected = widget.options.indexWhere(
      (option) => option.value == widget.value && option.enabled,
    );
    if (selected >= 0) {
      return selected;
    }
    final firstEnabled = widget.options.indexWhere((option) => option.enabled);
    return firstEnabled < 0 ? 0 : firstEnabled;
  }
}
