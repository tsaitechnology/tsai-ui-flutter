import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class FeedbackDemo extends StatefulWidget {
  const FeedbackDemo({required this.section, super.key});

  final ComponentDemoSection section;

  @override
  State<FeedbackDemo> createState() => _FeedbackDemoState();
}

class _FeedbackDemoState extends State<FeedbackDemo> {
  TsaiToastVariant _toastVariant = TsaiToastVariant.undo;
  TsaiInlineAlertTone _alertTone = TsaiInlineAlertTone.info;
  TsaiProgressBarState _progressState = TsaiProgressBarState.normal;
  TsaiProgressBarLabelPosition _labelPosition =
      TsaiProgressBarLabelPosition.top;
  TsaiSpinnerSize _spinnerSize = TsaiSpinnerSize.medium;
  double _progress = 0.6;
  bool _showCardHeader = true;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: ValueKey<String>('${widget.section.name}-demo'),
    padding: const EdgeInsets.all(24),
    child: switch (widget.section) {
      ComponentDemoSection.toast => _toastPlayground(),
      ComponentDemoSection.inlineAlert => _alertPlayground(),
      ComponentDemoSection.progress => _progressPlayground(),
      ComponentDemoSection.card => _cardPlayground(),
      _ => const SizedBox.shrink(),
    },
  );

  Widget _toastPlayground() => ComponentPlayground(
    controls: [
      PlaygroundSelectControl<TsaiToastVariant>(
        label: 'variant',
        value: _toastVariant,
        values: TsaiToastVariant.values,
        onChanged: (value) => setState(() => _toastVariant = value),
      ),
    ],
    preview: PlaygroundContrastBackdrop(
      height: 112,
      child: TsaiToast(
        variant: _toastVariant,
        message: _toastVariant == TsaiToastVariant.info
            ? 'Settings updated'
            : 'Item deleted',
        actionLabel: _toastVariant == TsaiToastVariant.undo ? 'Undo' : 'View',
        secondsRemaining: 7,
        onAction: () {},
        onDismiss: () {},
      ),
    ),
  );

  Widget _alertPlayground() => ComponentPlayground(
    controls: [
      PlaygroundSelectControl<TsaiInlineAlertTone>(
        label: 'tone',
        value: _alertTone,
        values: TsaiInlineAlertTone.values,
        onChanged: (value) => setState(() => _alertTone = value),
      ),
    ],
    preview: TsaiInlineAlert(
      tone: _alertTone,
      title: _alertTone.name[0].toUpperCase() + _alertTone.name.substring(1),
      message: 'A concise status message with a clear next step.',
      onDismiss: () {},
    ),
  );

  Widget _progressPlayground() => ComponentPlayground(
    controls: [
      PlaygroundField(
        label: 'value: ${(_progress * 100).round()}%',
        child: Slider(
          value: _progress,
          onChanged: (value) => setState(() => _progress = value),
        ),
      ),
      PlaygroundSelectControl<TsaiProgressBarState>(
        label: 'state',
        value: _progressState,
        values: TsaiProgressBarState.values,
        onChanged: (value) => setState(() => _progressState = value),
      ),
      PlaygroundSelectControl<TsaiProgressBarLabelPosition>(
        label: 'labelPosition',
        value: _labelPosition,
        values: TsaiProgressBarLabelPosition.values,
        onChanged: (value) => setState(() => _labelPosition = value),
      ),
      PlaygroundSelectControl<TsaiSpinnerSize>(
        label: 'spinnerSize',
        value: _spinnerSize,
        values: TsaiSpinnerSize.values,
        onChanged: (value) => setState(() => _spinnerSize = value),
      ),
    ],
    preview: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TsaiProgressBar(
          value: _progress,
          state: _progressState,
          labelPosition: _labelPosition,
          label: 'Processing',
        ),
        const SizedBox(height: 32),
        TsaiSpinner(size: _spinnerSize),
      ],
    ),
  );

  Widget _cardPlayground() => ComponentPlayground(
    controls: [
      PlaygroundField(
        label: 'showHeader',
        child: Switch(
          value: _showCardHeader,
          onChanged: (value) => setState(() => _showCardHeader = value),
        ),
      ),
    ],
    preview: TsaiCard(
      title: _showCardHeader ? 'Card title' : null,
      trailing: _showCardHeader ? const Icon(LucideIcons.ellipsis) : null,
      child: const _CardContentExample(),
    ),
  );
}

class _CardContentExample extends StatelessWidget {
  const _CardContentExample();

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(tokens.radii.innerMedium),
      ),
      child: const TsaiTextCaption(
        'Arbitrary card content',
        size: TsaiCaptionSize.medium,
        weight: TsaiTextWeight.regular,
      ),
    );
  }
}
