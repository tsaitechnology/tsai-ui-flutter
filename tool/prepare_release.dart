import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    _fail(
      'Usage: dart run tool/prepare_release.dart '
      '<major|minor|patch|major.minor.patch>',
    );
  }

  final pubspecFile = File('pubspec.yaml');
  final pubspecSource = pubspecFile.readAsStringSync();
  final pubspec = loadYaml(pubspecSource);
  if (pubspec is! YamlMap) {
    _fail('pubspec.yaml must contain a YAML map.');
  }

  final currentVersion = _Version.parse(pubspec['version'] as String? ?? '');
  final requestedVersion = _Version.resolve(
    arguments.single,
    current: currentVersion,
  );
  if (requestedVersion <= currentVersion) {
    _fail(
      'The requested version $requestedVersion must be greater than '
      '$currentVersion.',
    );
  }

  final previousTag = _latestReleaseTag();
  final changes = _changesSince(previousTag);
  if (changes.isEmpty) {
    _fail('No commits were found after $previousTag.');
  }

  _writePubspecVersion(
    file: pubspecFile,
    source: pubspecSource,
    currentVersion: currentVersion,
    requestedVersion: requestedVersion,
  );
  _writeChangelog(
    version: requestedVersion,
    changes: changes,
    repository: pubspec['repository'] as String? ?? '',
  );
  _updateInstallationVersions(currentVersion, requestedVersion);

  stderr.writeln(
    'Prepared $requestedVersion from ${changes.length} commits after '
    '$previousTag.',
  );
  stdout.writeln(requestedVersion);
}

String _latestReleaseTag() {
  final result = Process.runSync('git', [
    'describe',
    '--tags',
    '--abbrev=0',
    '--match',
    'v[0-9]*.[0-9]*.[0-9]*',
  ]);
  if (result.exitCode != 0) {
    _fail('No previous v<major>.<minor>.<patch> release tag was found.');
  }
  return (result.stdout as String).trim();
}

List<_Change> _changesSince(String tag) {
  const fieldSeparator = '\u001f';
  const recordSeparator = '\u001e';
  final result = Process.runSync('git', [
    'log',
    '$tag..HEAD',
    '--format=%H$fieldSeparator%s$fieldSeparator%b$recordSeparator',
  ]);
  if (result.exitCode != 0) {
    _fail('Unable to read commits after $tag.');
  }

  return (result.stdout as String)
      .split(recordSeparator)
      .map((record) => record.trim())
      .where((record) => record.isNotEmpty)
      .map((record) {
        final fields = record.split(fieldSeparator);
        if (fields.length < 3) {
          _fail('Unable to parse a git log record.');
        }
        return _Change.parse(
          hash: fields[0],
          subject: fields[1],
          body: fields.sublist(2).join(fieldSeparator),
        );
      })
      .toList();
}

void _writePubspecVersion({
  required File file,
  required String source,
  required _Version currentVersion,
  required _Version requestedVersion,
}) {
  final versionLine = RegExp(
    '^version:\\s*${RegExp.escape(currentVersion.toString())}\\s*\$',
    multiLine: true,
  );
  if (!versionLine.hasMatch(source)) {
    _fail('Unable to locate the current version line in pubspec.yaml.');
  }
  file.writeAsStringSync(
    source.replaceFirst(versionLine, 'version: $requestedVersion'),
  );
}

void _writeChangelog({
  required _Version version,
  required List<_Change> changes,
  required String repository,
}) {
  final changelogFile = File('CHANGELOG.md');
  final existing = changelogFile.readAsStringSync().trimLeft();
  final duplicateHeading = RegExp(
    '^## ${RegExp.escape(version.toString())}(?:\\s|\$)',
    multiLine: true,
  );
  if (duplicateHeading.hasMatch(existing)) {
    _fail('CHANGELOG.md already contains a section for $version.');
  }

  final groups = <_ChangeGroup, List<_Change>>{
    for (final group in _ChangeGroup.values) group: [],
  };
  for (final change in changes.reversed) {
    groups[change.group]!.add(change);
  }

  final date = DateTime.now().toUtc();
  final dateText =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final section = StringBuffer('## $version - $dateText\n');
  for (final group in _ChangeGroup.values) {
    final entries = groups[group]!;
    if (entries.isEmpty) {
      continue;
    }
    section.writeln('\n### ${group.heading}\n');
    for (final change in entries) {
      final commit = repository.isEmpty
          ? change.shortHash
          : '[${change.shortHash}]($repository/commit/${change.hash})';
      section.writeln('- ${change.description} ($commit)');
    }
  }

  changelogFile.writeAsStringSync('$section\n$existing');
}

void _updateInstallationVersions(
  _Version currentVersion,
  _Version requestedVersion,
) {
  for (final path in ['README.md', 'docs/installation.md']) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final source = file.readAsStringSync();
    file.writeAsStringSync(
      source.replaceAll('^$currentVersion', '^$requestedVersion'),
    );
  }
}

enum _ChangeGroup {
  breakingChanges('Breaking Changes'),
  features('Features'),
  fixes('Bug Fixes'),
  dependencies('Dependencies'),
  documentation('Documentation'),
  maintenance('Maintenance');

  const _ChangeGroup(this.heading);

  final String heading;
}

final class _Change {
  const _Change({
    required this.hash,
    required this.description,
    required this.group,
  });

  factory _Change.parse({
    required String hash,
    required String subject,
    required String body,
  }) {
    final conventional = RegExp(
      r'^([a-zA-Z]+)(?:\([^)]+\))?(!)?:\s*(.+)$',
    ).firstMatch(subject);
    final type = conventional?.group(1)?.toLowerCase();
    final breaking =
        conventional?.group(2) == '!' ||
        body.contains('BREAKING CHANGE:') ||
        body.contains('BREAKING-CHANGE:');
    final group = breaking
        ? _ChangeGroup.breakingChanges
        : switch (type) {
            'feat' => _ChangeGroup.features,
            'fix' => _ChangeGroup.fixes,
            'deps' => _ChangeGroup.dependencies,
            'docs' => _ChangeGroup.documentation,
            _ => _ChangeGroup.maintenance,
          };
    return _Change(
      hash: hash,
      description: conventional?.group(3) ?? subject,
      group: group,
    );
  }

  final String hash;
  final String description;
  final _ChangeGroup group;

  String get shortHash => hash.substring(0, 7);
}

final class _Version implements Comparable<_Version> {
  const _Version(this.major, this.minor, this.patch);

  factory _Version.resolve(String source, {required _Version current}) =>
      switch (source) {
        'major' => _Version(current.major + 1, 0, 0),
        'minor' => _Version(current.major, current.minor + 1, 0),
        'patch' => _Version(current.major, current.minor, current.patch + 1),
        _ => _Version.parse(source),
      };

  factory _Version.parse(String source) {
    final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)$').firstMatch(source);
    if (match == null) {
      _fail('Version "$source" must use the stable major.minor.patch format.');
    }
    return _Version(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  final int major;
  final int minor;
  final int patch;

  @override
  int compareTo(_Version other) {
    for (final comparison in [
      major.compareTo(other.major),
      minor.compareTo(other.minor),
      patch.compareTo(other.patch),
    ]) {
      if (comparison != 0) {
        return comparison;
      }
    }
    return 0;
  }

  bool operator <=(_Version other) => compareTo(other) <= 0;

  @override
  String toString() => '$major.$minor.$patch';
}

Never _fail(String message) {
  stderr.writeln('Release preparation failed: $message');
  exit(1);
}
