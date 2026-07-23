# Official Dart And Flutter Sources

Use these primary sources for SDK-sensitive decisions. Re-check the live pages
when changing supported SDK constraints; commands, scoring, and platform rules
evolve.

## Package structure and publishing

- Flutter: Developing packages and plugins  
  https://docs.flutter.dev/packages-and-plugins/developing-packages
- Dart: Creating packages  
  https://dart.dev/tools/pub/create-packages
- Dart: Package layout conventions  
  https://dart.dev/tools/pub/package-layout
- Dart: The pubspec file  
  https://dart.dev/tools/pub/pubspec
- Dart: Package dependencies  
  https://dart.dev/tools/pub/dependencies
- Dart: Package versioning  
  https://dart.dev/tools/pub/versioning
- Dart: Publishing packages  
  https://dart.dev/tools/pub/publishing
- Dart: Pub workspaces  
  https://dart.dev/tools/pub/workspaces
- pub.dev: Package scores and pub points  
  https://pub.dev/help/scoring

## API design and documentation

- Effective Dart  
  https://dart.dev/effective-dart
- Effective Dart: Design  
  https://dart.dev/effective-dart/design
- Effective Dart: Usage  
  https://dart.dev/effective-dart/usage
- Effective Dart: Documentation  
  https://dart.dev/effective-dart/documentation
- Dart API: Deprecated  
  https://api.dart.dev/dart-core/Deprecated-class.html

## Theming and tokens

- Flutter: Use themes to share colors and font styles  
  https://docs.flutter.dev/cookbook/design/themes
- Flutter API: ThemeData  
  https://api.flutter.dev/flutter/material/ThemeData-class.html
- Flutter API: ThemeExtension  
  https://api.flutter.dev/flutter/material/ThemeExtension-class.html
- Flutter API: ColorScheme  
  https://api.flutter.dev/flutter/material/ColorScheme-class.html

The three-level reference/semantic/component token model is an architectural
application of these theming APIs. Flutter prescribes typed theme data,
contextual lookup, `copyWith`, and interpolation; it does not prescribe the
project's token names.

## Testing and accessibility

- Flutter: Testing overview  
  https://docs.flutter.dev/testing/overview
- Flutter: Widget testing  
  https://docs.flutter.dev/cookbook/testing/widget/introduction
- Flutter: Integration testing  
  https://docs.flutter.dev/testing/integration-tests
- Flutter: Accessibility  
  https://docs.flutter.dev/ui/accessibility
- Flutter: Accessibility testing  
  https://docs.flutter.dev/ui/accessibility/accessibility-testing
- Flutter: Accessible UI design and styling  
  https://docs.flutter.dev/ui/accessibility/ui-design-and-styling
- Flutter: Web accessibility  
  https://docs.flutter.dev/ui/accessibility/web-accessibility

Golden-test policy and matrix size are enterprise safeguards built on Flutter's
testing APIs; treat them as this library's quality policy rather than a claim
that Flutter mandates a specific golden matrix.

## Compatibility

- Flutter compatibility policy  
  https://docs.flutter.dev/release/compatibility-policy
- Flutter breaking changes and migration guides  
  https://docs.flutter.dev/release/breaking-changes
- Dart: `dart pub downgrade`  
  https://dart.dev/tools/pub/cmd/pub-downgrade
- Dart: `dart pub outdated`  
  https://dart.dev/tools/pub/cmd/pub-outdated

## Source policy

Prefer `dart.dev`, `docs.flutter.dev`, `api.dart.dev`, `api.flutter.dev`, and
`pub.dev` for normative decisions. Use community packages only after verifying
that the SDK does not provide the capability and after evaluating maintenance,
license, platform, and public-API impact.
