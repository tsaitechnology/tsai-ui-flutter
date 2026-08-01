part of '../tsai_tabs.dart';

/// A convenient tab bar and content composition.
///
/// When [contentLayout] is [TsaiTabContentLayout.viewport], this widget must
/// receive bounded height, normally by being placed in an [Expanded].
class TsaiTabs extends StatefulWidget {
  /// Creates a complete tabs composition.
  const TsaiTabs({
    required this.sections,
    super.key,
    this.controller,
    this.initialIndex = 0,
    this.onChanged,
    this.fit = TsaiTabBarFit.expand,
    this.contentLayout = TsaiTabContentLayout.intrinsic,
    this.tabBarPhysics,
    this.contentPhysics,
  });

  /// Tab labels and matching content sections.
  final List<TsaiTabSection> sections;

  /// Optional caller-owned controller.
  ///
  /// An internal controller is created when omitted.
  final TabController? controller;

  /// Initial selection used only by an internally owned controller.
  final int initialIndex;

  /// Called when the selected index changes.
  final ValueChanged<int>? onChanged;

  /// How tabs consume horizontal space.
  final TsaiTabBarFit fit;

  /// Whether content uses natural or bounded viewport height.
  final TsaiTabContentLayout contentLayout;

  /// Optional scrolling physics for a scrollable tab bar.
  final ScrollPhysics? tabBarPhysics;

  /// Optional swipe physics for viewport content.
  final ScrollPhysics? contentPhysics;

  @override
  State<TsaiTabs> createState() => _TsaiTabsState();
}

class _TsaiTabsState extends State<TsaiTabs>
    with SingleTickerProviderStateMixin {
  TabController? _internalController;
  TabController? _activeController;
  Duration? _resolvedAnimationDuration;
  late int _lastReportedIndex;

  TabController get _controller => _activeController!;

  @override
  void initState() {
    super.initState();
    _activeController = widget.controller;
    _lastReportedIndex = widget.controller?.index ?? widget.initialIndex;
    _activeController?.addListener(_handleController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokens = TsaiThemeTokens.of(context);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : tokens.motion.interaction;
    if (_activeController == null) {
      _createInternalController(
        previousIndex: _lastReportedIndex,
        animationDuration: duration,
      );
      _attachInternalController();
    } else if (_internalController != null &&
        duration != _resolvedAnimationDuration) {
      final previousIndex = _controller.index;
      _controller.removeListener(_handleController);
      _internalController!.dispose();
      _createInternalController(
        previousIndex: previousIndex,
        animationDuration: duration,
      );
      _attachInternalController();
    }
    _resolvedAnimationDuration = duration;
  }

  @override
  void didUpdateWidget(covariant TsaiTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controllerChanged = oldWidget.controller != widget.controller;
    final lengthChanged = oldWidget.sections.length != widget.sections.length;
    if (!controllerChanged && !(lengthChanged && widget.controller == null)) {
      return;
    }

    final previousIndex = _activeController?.index ?? widget.initialIndex;
    _activeController?.removeListener(_handleController);
    _internalController?.dispose();
    _internalController = null;
    _activeController = widget.controller;
    if (_activeController == null) {
      _createInternalController(
        previousIndex: previousIndex,
        animationDuration:
            _resolvedAnimationDuration ?? TsaiMotionTokens.standard.interaction,
      );
      _attachInternalController();
    } else {
      _lastReportedIndex = _controller.index;
      _controller.addListener(_handleController);
    }
  }

  @override
  void dispose() {
    _activeController?.removeListener(_handleController);
    _internalController?.dispose();
    super.dispose();
  }

  void _createInternalController({
    required int previousIndex,
    required Duration animationDuration,
  }) {
    final length = widget.sections.length;
    _internalController = TabController(
      length: length,
      initialIndex: length == 0 ? 0 : previousIndex.clamp(0, length - 1),
      animationDuration: animationDuration,
      vsync: this,
    );
  }

  void _attachInternalController() {
    _activeController = _internalController;
    _lastReportedIndex = _controller.index;
    _controller.addListener(_handleController);
  }

  void _handleController() {
    final index = _controller.index;
    if (index == _lastReportedIndex) {
      return;
    }
    _lastReportedIndex = index;
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.sections.isNotEmpty,
      'TsaiTabs requires at least one section.',
    );
    assert(
      widget.initialIndex >= 0 && widget.initialIndex < widget.sections.length,
      'initialIndex must identify an existing section.',
    );
    assert(
      _controller.length == widget.sections.length,
      'TabController length must match the number of sections.',
    );

    final bar = TsaiTabBar(
      controller: _controller,
      tabs: [for (final section in widget.sections) section.tab],
      fit: widget.fit,
      physics: widget.tabBarPhysics,
    );
    final content = widget.contentLayout == TsaiTabContentLayout.viewport
        ? TsaiTabContent.viewport(
            controller: _controller,
            physics: widget.contentPhysics,
            children: [for (final section in widget.sections) section.content],
          )
        : TsaiTabContent.intrinsic(
            controller: _controller,
            children: [for (final section in widget.sections) section.content],
          );

    return Column(
      mainAxisSize: widget.contentLayout == TsaiTabContentLayout.intrinsic
          ? MainAxisSize.min
          : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar,
        if (widget.contentLayout == TsaiTabContentLayout.viewport)
          Expanded(child: content)
        else
          content,
      ],
    );
  }
}
