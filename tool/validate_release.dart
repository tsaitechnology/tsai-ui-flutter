import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    _fail('Usage: dart run tool/validate_release.dart <major.minor.patch>');
  }

  final requestedVersion = arguments.single;
  if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(requestedVersion)) {
    _fail('Release version must use the stable major.minor.patch format.');
  }

  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync());
  if (pubspec is! YamlMap) {
    _fail('pubspec.yaml must contain a YAML map.');
  }

  final packageVersion = pubspec['version'];
  if (packageVersion != requestedVersion) {
    _fail(
      'pubspec.yaml version is $packageVersion, expected $requestedVersion.',
    );
  }
  if (pubspec.containsKey('publish_to') && pubspec['publish_to'] == 'none') {
    _fail('pubspec.yaml still disables publication with publish_to: none.');
  }

  final changelog = File('CHANGELOG.md').readAsStringSync();
  final releaseHeading = RegExp(
    '^## ${RegExp.escape(requestedVersion)}(?: - \\d{4}-\\d{2}-\\d{2})?\$',
    multiLine: true,
  );
  if (!releaseHeading.hasMatch(changelog)) {
    _fail('CHANGELOG.md has no release heading for $requestedVersion.');
  }

  final license = File('LICENSE').readAsStringSync();
  if (!license.startsWith('MIT License')) {
    _fail('LICENSE is not the expected MIT license.');
  }
  if (!File('.pubignore').existsSync()) {
    _fail('.pubignore is required to control the published archive.');
  }

  stdout.writeln('Release metadata is valid for $requestedVersion.');
}

Never _fail(String message) {
  stderr.writeln('Release validation failed: $message');
  exitCode = 1;
  exit(exitCode);
}
