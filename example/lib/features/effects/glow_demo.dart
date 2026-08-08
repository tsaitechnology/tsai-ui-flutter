import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_playground.dart';

class GlowDemo extends StatefulWidget {
  const GlowDemo({super.key});

  @override
  State<GlowDemo> createState() => _GlowDemoState();
}

class _GlowDemoState extends State<GlowDemo> {
  double _diameter = 240;
  double _blurRadius = 85;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey<String>('glow-demo'),
    padding: const EdgeInsets.all(24),
    child: ComponentPlayground(
      controls: [
        PlaygroundField(
          label: 'diameter: ${_diameter.round()}',
          child: Slider(
            value: _diameter,
            min: 80,
            max: 480,
            onChanged: (value) => setState(() => _diameter = value),
          ),
        ),
        PlaygroundField(
          label: 'blurRadius: ${_blurRadius.round()}',
          child: Slider(
            value: _blurRadius,
            min: 0,
            max: 170,
            onChanged: (value) => setState(() => _blurRadius = value),
          ),
        ),
      ],
      preview: Center(
        child: TsaiGlow(diameter: _diameter, blurRadius: _blurRadius),
      ),
    ),
  );
}
