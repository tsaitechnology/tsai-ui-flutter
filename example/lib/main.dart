import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import 'catalog_app.dart';

void main() => runApp(const CatalogApp(home: QuickStartExample()));

/// A compact example of theming and composing Tsai UI components.
class QuickStartExample extends StatefulWidget {
  const QuickStartExample({super.key});

  @override
  State<QuickStartExample> createState() => _QuickStartExampleState();
}

class _QuickStartExampleState extends State<QuickStartExample> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TsaiHeading(
                  'Create your workspace',
                  size: TsaiHeadingSize.extraLarge,
                ),
                const SizedBox(height: 8),
                const TsaiBody(
                  'Compose accessible Flutter interfaces with Tsai UI.',
                  size: TsaiBodySize.large,
                  weight: TsaiTextWeight.regular,
                ),
                const SizedBox(height: 32),
                const TsaiInput(
                  label: 'Work email',
                  hintText: 'you@company.com',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                ),
                const SizedBox(height: 20),
                TsaiCheckbox(
                  value: _acceptedTerms,
                  label: 'I agree to the terms of service',
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value ?? false),
                ),
                const SizedBox(height: 24),
                TsaiButton(
                  label: 'Create workspace',
                  isExpanded: true,
                  onPressed: _acceptedTerms
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Workspace created')),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                TsaiButton(
                  label: 'Browse the component catalog',
                  variant: TsaiButtonVariant.outline,
                  isExpanded: true,
                  onPressed: () => Navigator.pushNamed(context, '/buttons'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
