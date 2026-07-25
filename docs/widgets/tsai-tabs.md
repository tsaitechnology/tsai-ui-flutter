# TsaiTabs

A token-backed tab selector with natural-height, bounded viewport, and pinned
sliver content compositions.

[Document-scroll example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/tabs-document){ target="_blank" rel="noopener" .md-button }
[Internal-scroll example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/tabs-viewport){ target="_blank" rel="noopener" .md-button }
[Sticky-tabs example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/tabs-sticky){ target="_blank" rel="noopener" .md-button }

## Natural-height document

Use `TsaiTabContentLayout.intrinsic` when the surrounding page owns scrolling.
The selected section takes its natural height, so the header, tabs, and content
move as one document.

```dart
SingleChildScrollView(
  child: Column(
    children: [
      const AccountHeader(),
      TsaiTabs(
        contentLayout: TsaiTabContentLayout.intrinsic,
        sections: [
          TsaiTabSection.text(
            label: 'Activity',
            content: const ActivitySection(),
          ),
          TsaiTabSection.text(
            label: 'Statements',
            content: const StatementsSection(),
          ),
        ],
      ),
    ],
  ),
)
```

`intrinsic` is the default. Content changes use the theme motion duration and
curves, animate their height, and honor `MediaQuery.disableAnimations`.

## Fixed tabs and internal scrolling

Use `viewport` inside bounded height when the header and tabs must stay visible.
Each content section owns its scrolling widget and therefore its scroll
position.

```dart
Column(
  children: [
    const OperationsHeader(),
    Expanded(
      child: TsaiTabs(
        contentLayout: TsaiTabContentLayout.viewport,
        sections: [
          TsaiTabSection.text(
            label: 'Open',
            content: ListView.builder(
              key: const PageStorageKey('open-requests'),
              itemCount: openRequests.length,
              itemBuilder: (context, index) =>
                  RequestRow(request: openRequests[index]),
            ),
          ),
          TsaiTabSection.text(
            label: 'Closed',
            content: ListView.builder(
              key: const PageStorageKey('closed-requests'),
              itemCount: closedRequests.length,
              itemBuilder: (context, index) =>
                  RequestRow(request: closedRequests[index]),
            ),
          ),
        ],
      ),
    ),
  ],
)
```

Do not place viewport mode in an unbounded `SingleChildScrollView`. Use a
`ListView`, `CustomScrollView`, or another scrollable as each section when the
section can exceed the available height.

## Sticky tabs

Use the standalone bar and content with one caller-owned `TabController` when
the page header should scroll away but the tab selector should remain pinned.

```dart
class BillingScreenState extends State<BillingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(child: BillingHeader()),
      TsaiSliverTabBar(
        controller: controller,
        tabs: const [Text('Usage'), Text('Invoices')],
      ),
      SliverToBoxAdapter(
        child: TsaiTabContent.intrinsic(
          controller: controller,
          children: const [UsageSection(), InvoiceSection()],
        ),
      ),
    ],
  );
}
```

Set `pinned: false` for a non-sticky sliver or `floating: true` to reveal the
bar as soon as scrolling reverses.

## Composition and control

`TsaiTabs` creates and disposes an internal `TabController` when `controller`
is omitted. Supply a controller when another part of the screen needs to
observe or change selection. `onChanged` reports both taps and programmatic
controller changes.

Use `TsaiTabSection(tab: ..., content: ...)` for composed tab labels. The
Penpot default is `TsaiTabBarFit.expand`; use `TsaiTabBarFit.scrollable` when
the labels cannot share the available width.
