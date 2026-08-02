import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class AvatarDemoScreen extends StatelessWidget {
  const AvatarDemoScreen({
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: section,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: _AvatarDemo(section: section),
  );
}

class _AvatarDemo extends StatelessWidget {
  const _AvatarDemo({required this.section});

  final ComponentDemoSection section;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ListView(
      key: ValueKey<String>('${section.name}-demo'),
      padding: EdgeInsets.all(tokens.spacing.space24),
      children: [
        switch (section) {
          ComponentDemoSection.avatar => const _AvatarExample(),
          ComponentDemoSection.userPill => const _UserPillExample(),
          _ => throw ArgumentError.value(section, 'section'),
        },
        SizedBox(height: tokens.spacing.space32),
        switch (section) {
          ComponentDemoSection.avatar => const _AvatarPlayground(),
          ComponentDemoSection.userPill => const _UserPillPlayground(),
          _ => throw ArgumentError.value(section, 'section'),
        },
      ],
    );
  }
}

class _AvatarExample extends StatelessWidget {
  const _AvatarExample();

  @override
  Widget build(BuildContext context) => const PenpotExample(
    title: 'Avatar',
    child: PenpotBoard(
      child: Avatar(initials: 'IT', semanticLabel: 'Ilona T.'),
    ),
  );
}

class _UserPillExample extends StatelessWidget {
  const _UserPillExample();

  @override
  Widget build(BuildContext context) => PenpotExample(
    title: 'UserPill',
    child: PenpotBoard(
      child: UserPill(
        name: 'Ilona T.',
        initials: 'IT',
        semanticLabel: 'Open profile',
        onPressed: () {},
      ),
    ),
  );
}

class _AvatarPlayground extends StatefulWidget {
  const _AvatarPlayground();

  @override
  State<_AvatarPlayground> createState() => _AvatarPlaygroundState();
}

class _AvatarPlaygroundState extends State<_AvatarPlayground> {
  String _initials = 'IT';
  _AvatarContent _content = _AvatarContent.initials;
  bool _semanticLabel = true;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    controls: [
      PlaygroundTextControl(
        label: 'initials',
        value: _initials,
        onChanged: (value) => setState(() => _initials = value),
      ),
      PlaygroundRadioGroup<_AvatarContent>(
        label: 'content',
        value: _content,
        options: const [
          (_AvatarContent.initials, 'Initials'),
          (_AvatarContent.image, 'Image'),
        ],
        onChanged: (value) => setState(() => _content = value),
      ),
      PlaygroundToggleControl(
        label: 'semanticLabel',
        value: _semanticLabel,
        onChanged: (value) => setState(() => _semanticLabel = value),
      ),
    ],
    preview: Avatar(
      initials: _initials.isEmpty ? 'IT' : _initials,
      image: _content == _AvatarContent.image
          ? const NetworkImage('https://i.pravatar.cc/64?img=47')
          : null,
      semanticLabel: _semanticLabel ? 'Demo avatar' : null,
    ),
  );
}

enum _AvatarContent { initials, image }

class _UserPillPlayground extends StatefulWidget {
  const _UserPillPlayground();

  @override
  State<_UserPillPlayground> createState() => _UserPillPlaygroundState();
}

class _UserPillPlaygroundState extends State<_UserPillPlayground> {
  String _name = 'Ilona T.';
  String _initials = 'IT';
  bool _showImage = false;
  bool _interactive = true;
  int _presses = 0;

  @override
  Widget build(BuildContext context) => ComponentPlayground(
    controls: [
      PlaygroundTextControl(
        label: 'name',
        value: _name,
        onChanged: (value) => setState(() => _name = value),
      ),
      PlaygroundTextControl(
        label: 'initials',
        value: _initials,
        onChanged: (value) => setState(() => _initials = value),
      ),
      PlaygroundToggleControl(
        label: 'imageUrl',
        value: _showImage,
        onChanged: (value) => setState(() => _showImage = value),
      ),
      PlaygroundToggleControl(
        label: 'interactive',
        value: _interactive,
        onChanged: (value) => setState(() => _interactive = value),
      ),
      PlaygroundOutput(label: 'presses', value: '$_presses'),
    ],
    preview: UserPill(
      name: _name.isEmpty ? 'Ilona T.' : _name,
      initials: _initials.isEmpty ? 'IT' : _initials,
      avatarUrl: _showImage ? 'https://i.pravatar.cc/64?img=47' : null,
      semanticLabel: 'Open demo profile',
      onPressed: _interactive ? () => setState(() => _presses++) : null,
    ),
  );
}
