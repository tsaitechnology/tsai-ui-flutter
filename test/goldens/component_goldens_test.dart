import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_icons.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../test_utils/load_test_fonts.dart';
import 'golden_harness.dart';

void main() {
  setUpAll(loadTsaiTestFonts);

  for (final brightness in Brightness.values) {
    for (final spec in _specs()) {
      testWidgets('${spec.name} ${brightness.name}', (tester) async {
        await expectComponentGolden(
          tester,
          name: spec.name,
          brightness: brightness,
          child: spec.child,
          size: spec.size,
        );
      });
    }
  }
}

final class _Spec {
  const _Spec(this.name, this.child, {this.size = const Size(390, 280)});

  final String name;
  final Widget child;
  final Size size;
}

Widget _pad(Widget child) => Padding(
  padding: const EdgeInsets.all(16),
  child: SizedBox(width: 358, child: child),
);

List<_Spec> _specs() {
  const chartPoints = [
    TsaiChartPoint(
      value: 10,
      tooltipValue: r'$10',
      tooltipDate: 'Mon',
      axisLabel: 'M',
    ),
    TsaiChartPoint(
      value: 20,
      tooltipValue: r'$20',
      tooltipDate: 'Tue',
      axisLabel: 'T',
    ),
    TsaiChartPoint(
      value: 14,
      tooltipValue: r'$14',
      tooltipDate: 'Wed',
      axisLabel: 'W',
    ),
    TsaiChartPoint(
      value: 28,
      tooltipValue: r'$28',
      tooltipDate: 'Thu',
      axisLabel: 'T',
    ),
    TsaiChartPoint(
      value: 18,
      tooltipValue: r'$18',
      tooltipDate: 'Fri',
      axisLabel: 'F',
    ),
    TsaiChartPoint(
      value: 8,
      tooltipValue: r'$8',
      tooltipDate: 'Sat',
      axisLabel: 'S',
    ),
    TsaiChartPoint(
      value: 22,
      tooltipValue: r'$22',
      tooltipDate: 'Sun',
      axisLabel: 'S',
    ),
  ];

  return [
    _Spec(
      'accordion',
      _pad(
        const TsaiAccordion(
          title: 'Fees',
          body: 'No hidden fees on this transfer.',
          expanded: true,
          showDivider: true,
        ),
      ),
    ),
    _Spec(
      'action_tile',
      _pad(
        Row(
          children: [
            TsaiActionTile(
              icon: const Icon(Icons.send),
              label: 'Send',
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            TsaiActionTile(
              variant: TsaiActionTileVariant.card,
              icon: const Icon(Icons.wallet),
              label: 'Cards',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
    _Spec(
      'alert',
      _pad(
        TsaiInlineAlert(
          title: 'Payment failed',
          message: 'Try again in a few minutes.',
          onDismiss: () {},
        ),
      ),
    ),
    _Spec(
      'amount_display',
      _pad(
        const TsaiAmountDisplay(
          caption: 'Total balance',
          value: r'$24,562.80',
          subtitle: '+2.2% this month',
        ),
      ),
    ),
    _Spec(
      'avatar',
      _pad(
        const Row(
          children: [
            Avatar(initials: 'IT', semanticLabel: 'Ilona T.'),
            SizedBox(width: 12),
            UserPill(name: 'Ilona T.', initials: 'IT'),
          ],
        ),
      ),
      size: const Size(390, 120),
    ),
    _Spec(
      'badge',
      _pad(
        const Row(
          children: [
            TsaiBadge(label: 'Ready', showDot: true),
            SizedBox(width: 8),
            TsaiBadgeCounter(value: 3),
            SizedBox(width: 8),
            TsaiBadgeDot(),
          ],
        ),
      ),
      size: const Size(390, 80),
    ),
    _Spec('bank_card', const TsaiBankCard(), size: const Size(390, 246)),
    _Spec(
      'bottom_nav_bar',
      BottomNavBar(
        selectedIndex: 0,
        onSelected: (_) {},
        items: const [
          BottomNavBarItem(icon: TsaiIcon(Icons.home), label: 'Home'),
          BottomNavBarItem(icon: TsaiIcon(Icons.bar_chart), label: 'Stats'),
          BottomNavBarItem(icon: TsaiIcon(Icons.credit_card), label: 'Cards'),
        ],
      ),
      size: const Size(390, 96),
    ),
    _Spec(
      'bottom_sheet',
      SizedBox(
        width: 390,
        child: TsaiBottomSheet(
          title: 'Select country',
          showCloseButton: true,
          onClose: () {},
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: TsaiTextBody(
              'Option list',
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.regular,
            ),
          ),
        ),
      ),
      size: const Size(390, 220),
    ),
    _Spec(
      'button',
      _pad(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiButton(label: 'Continue', onPressed: () {}),
            const SizedBox(height: 12),
            const TsaiButton(label: 'Disabled', onPressed: null),
            const SizedBox(height: 12),
            TsaiIconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
              badge: const TsaiIconButtonBadgeCount(3),
            ),
          ],
        ),
      ),
    ),
    _Spec(
      'card',
      _pad(
        const TsaiCard(
          title: 'Card title',
          child: SizedBox(height: 64, width: double.infinity),
        ),
      ),
    ),
    _Spec(
      'charts_line',
      const SizedBox(
        width: 294,
        height: 256,
        child: TsaiLineChart(points: chartPoints, showTabs: true),
      ),
      size: const Size(390, 288),
    ),
    _Spec(
      'charts_bar',
      const SizedBox(
        width: 294,
        height: 256,
        child: TsaiBarChart(points: chartPoints, showTabs: true),
      ),
      size: const Size(390, 288),
    ),
    _Spec(
      'charts_mini_tabs',
      _pad(
        TsaiMiniTabs(
          labels: const ['1D', '1W', '1M', '1Y', 'All'],
          selectedIndex: 2,
          onChanged: (_) {},
        ),
      ),
      size: const Size(390, 80),
    ),
    _Spec(
      'chip',
      _pad(
        Row(
          children: [
            TsaiChip(label: 'USD', onTap: () {}),
            const SizedBox(width: 8),
            const TsaiChip(label: 'EUR', selected: true, showCheck: true),
          ],
        ),
      ),
      size: const Size(390, 80),
    ),
    _Spec('divider', _pad(const TsaiDivider()), size: const Size(390, 48)),
    _Spec(
      'effects_glow',
      const SizedBox.square(
        dimension: 96,
        child: TsaiGlow(diameter: 64, blurRadius: 16),
      ),
      size: const Size(160, 160),
    ),
    _Spec(
      'input',
      _pad(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiInput(placeholder: 'Email'),
            SizedBox(height: 12),
            TsaiSearchInput(placeholder: 'Search'),
            SizedBox(height: 12),
            TsaiPhoneInput(),
            SizedBox(height: 12),
            TsaiOtpInput(length: 4),
            SizedBox(height: 12),
            TsaiTextarea(
              placeholder: 'Label',
              description: 'Description',
              initialValue: 'A short note.',
            ),
          ],
        ),
      ),
      size: const Size(390, 520),
    ),
    _Spec(
      'date_picker',
      Padding(
        padding: const EdgeInsets.all(16),
        child: TsaiDatePeriodPicker(
          now: DateTime(2026, 8, 30),
          initialPeriod: TsaiDatePeriod(
            start: DateTime(2026, 8, 5),
            end: DateTime(2026, 8, 13),
            granularity: TsaiDateGranularity.weekly,
          ),
        ),
      ),
      size: const Size(390, 640),
    ),
    _Spec(
      'time_picker',
      Padding(
        padding: const EdgeInsets.all(16),
        child: TsaiTimePicker(initialTime: TimeOfDay(hour: 15, minute: 30)),
      ),
      size: const Size(390, 280),
    ),
    _Spec(
      'keypad',
      TsaiNumericKeypad(onDigit: (_) {}),
      size: const Size(390, 260),
    ),
    _Spec(
      'link',
      _pad(TsaiLink(label: 'View details', onPressed: () {})),
      size: const Size(390, 80),
    ),
    _Spec(
      'modal_dialog',
      TsaiModalDialog(
        title: 'Delete item',
        message: 'This cannot be undone.',
        icon: const Icon(Icons.warning_amber_rounded),
        primaryAction: TsaiButton(
          label: 'Delete',
          tone: TsaiButtonTone.danger,
          onPressed: () {},
        ),
        secondaryAction: TsaiButton(
          label: 'Cancel',
          variant: TsaiButtonVariant.ghost,
          onPressed: () {},
        ),
      ),
      size: const Size(390, 360),
    ),
    _Spec(
      'page_indicator',
      _pad(const TsaiPageIndicator(count: 5, index: 2)),
      size: const Size(390, 64),
    ),
    _Spec(
      'progress',
      _pad(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiProgressBar(
              value: 0.6,
              label: 'Upload',
              labelPosition: TsaiProgressBarLabelPosition.top,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TsaiSpinner(size: TsaiSpinnerSize.small),
                SizedBox(width: 16),
                TsaiSpinner(),
              ],
            ),
          ],
        ),
      ),
    ),
    _Spec(
      'select',
      _pad(
        TsaiSelect<String>(
          value: 'uy',
          placeholder: 'Country',
          onChanged: (_) {},
          options: const [
            TsaiSelectOption(value: 'uy', label: 'Uruguay'),
            TsaiSelectOption(value: 'ar', label: 'Argentina'),
          ],
        ),
      ),
      size: const Size(390, 120),
    ),
    _Spec(
      'selection',
      _pad(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiCheckbox(value: true, label: 'Accept terms', onChanged: (_) {}),
            TsaiRadio<String>(
              value: 'a',
              groupValue: 'a',
              label: 'Option A',
              onChanged: (_) {},
            ),
            TsaiSwitch(value: true, label: 'Notifications', onChanged: (_) {}),
          ],
        ),
      ),
    ),
    _Spec(
      'skeleton',
      _pad(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiSkeletonText(),
            SizedBox(height: 12),
            TsaiSkeletonAvatar(),
            SizedBox(height: 12),
            TsaiSkeletonCard(),
          ],
        ),
      ),
    ),
    _Spec(
      'slider',
      _pad(TsaiSlider(value: 0.4, onChanged: (_) {})),
      size: const Size(390, 80),
    ),
    _Spec(
      'stepper',
      _pad(TsaiStepper(value: 2, onChanged: (_) {})),
      size: const Size(390, 80),
    ),
    _Spec(
      'tabs',
      SizedBox(
        width: 358,
        child: TsaiTabs(
          sections: const [
            TsaiTabSection(
              tab: Text('Overview'),
              content: Text('Overview body'),
            ),
            TsaiTabSection(
              tab: Text('Activity'),
              content: Text('Activity body'),
            ),
          ],
        ),
      ),
      size: const Size(390, 160),
    ),
    _Spec(
      'toast',
      SizedBox(
        width: 342,
        height: 72,
        child: TsaiToast(
          variant: TsaiToastVariant.undo,
          message: 'Item deleted',
          actionLabel: 'Undo',
          secondsRemaining: 7,
          onAction: () {},
        ),
      ),
      size: const Size(390, 104),
    ),
    _Spec(
      'top_bar',
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeTopBar(
            leading: const [UserPill(name: 'Ilona', initials: 'IT')],
            trailing: [
              HomeTopBarAction(
                icon: const TsaiIcon(LucideIcons.bell, size: 24),
                semanticLabel: 'Notifications',
                onPressed: () {},
              ),
            ],
          ),
          PageTopBar(
            title: 'Settings',
            leading: [
              PageTopBarAction(
                icon: const TsaiIcon(LucideIcons.arrow_left, size: 24),
                semanticLabel: 'Back',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      size: const Size(390, 180),
    ),
    _Spec(
      'typography',
      _pad(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TsaiTitle('Portfolio', subtitle: 'Main account'),
            SizedBox(height: 8),
            TsaiTextHeading('Heading', size: TsaiHeadingSize.large),
            TsaiTextBody(
              'Body copy',
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.regular,
            ),
          ],
        ),
      ),
    ),
    _Spec(
      'ui_blocks',
      _pad(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TsaiSectionHeader(title: 'Recent'),
            TsaiListItem(
              content: const Text('Blue Bottle'),
              showChevron: true,
              onTap: () {},
            ),
            const TsaiEmptyState(
              icon: Icon(Icons.inbox),
              title: 'Nothing here',
              description: 'Activity will show up in this list.',
            ),
          ],
        ),
      ),
      size: const Size(390, 280),
    ),
    _Spec(
      'icons',
      _pad(
        const Row(
          children: [
            TsaiIcon(LucideIcons.plus, size: 24),
            SizedBox(width: 12),
            CircleIcon(icon: Icon(Icons.search)),
            SizedBox(width: 12),
            TsaiCryptoIcon(TsaiCryptoAsset.btc),
          ],
        ),
      ),
      size: const Size(390, 80),
    ),
  ];
}
