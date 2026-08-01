part of '../tsai_button.dart';

class _TsaiSpinner extends StatefulWidget {
  const _TsaiSpinner({
    required this.color,
    required this.duration,
    required this.semanticLabel,
  });

  final Color color;
  final Duration duration;
  final String? semanticLabel;

  @override
  State<_TsaiSpinner> createState() => _TsaiSpinnerState();
}

class _TsaiSpinnerState extends State<_TsaiSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant _TsaiSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.semanticLabel,
    child: RotationTransition(
      key: const ValueKey<String>('tsai-button-spinner'),
      turns: _controller,
      child: CustomPaint(
        size: const Size.square(16),
        painter: _SpinnerPainter(color: widget.color),
      ),
    ),
  );
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const arcSize = 12.0;
    final offset = (size.width - arcSize) / 2;
    final rect = Rect.fromLTWH(offset, offset, arcSize, arcSize);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) => color != oldDelegate.color;
}
