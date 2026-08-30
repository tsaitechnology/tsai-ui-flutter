# Penpot Synchronization

Source file:

```text
team-id: 94d08ab2-b712-814a-8008-482d5efb1ac1
file-id: ab506819-5bcf-801f-8008-4e8f605cef78
library: Design System
```

Latest snapshot read on 2026-08-13:

- sets: `dark`, `light`, `typography`, `spacing`;
- color roles include glass canvas, surface, accent-surface, and accent-text
  values for both themes;
- reusable color assets: `top-light`, `top-dark`, `bottom-light`, and
  `bottom-dark`, normalized as semantic top/bottom scrim gradients;
- typography roles: 20;
- spacing values: 12, including `spacing.6 = 6` and `spacing.12 = 12`;
- nested medium radius: `radius.inner.md = 10`;
- large sheet radius: `radius.xxl = 32`;
- modal overlay: `color.bg.overlay = #00000066` (light) and `#00000099`
  (dark);
- background glow: `color.accent.glow = #C7D2FE33` (light) and
  `#6366F11A` (dark);
- dim accent glass: `color.surface.indigo.glassDim = #E4E7FA4D` (light) and
  `#31345E4D` (dark);
- semantic status accents, surfaces, and borders for info, success, error, and
  warning are mapped directly from the light and dark Penpot sets;
- canonical status accent roles are `color.semantic.accent.success` and
  `color.semantic.accent.error`;
- updated values: dark `color.surface.1 = #15161F`, light
  `color.border.hairline = #E1E2EB`, and dark
  `color.border.hairline = #24252E`;
- button axes: state, type, size;
- button matrix: 4 × 4 × 2 = 32 variants;
- icon/loader slot: 16 × 16, with a 12-pixel loader path and 1.5 stroke;
- icon-to-text gap: 8 pixels for L and 4 pixels for M;
- loading replaces the icon in the same slot without changing button width;
- M button: 40 pixels high, `radius.md`, 12-pixel start and 16-pixel end
  padding, and a 12-pixel `type.button.m` label;
- Stroke button: `color.border.hairline` border rather than an accent-surface
  color;
- Section Header: 8-pixel vertical padding, medium caption title, and optional
  16-pixel trailing icon;
- List Item: 8-pixel vertical padding and gap; optional 40-pixel circular icon,
  external content and trailing slots, 20-pixel chevron, and active hairline
  surface with `radius.lg`;
- List: Section Header, List Items, and optional bottom button separated by
  `spacing.8`;
- Empty State: 32-pixel vertical padding, 64-pixel circular icon surface,
  centered title/description stack, and optional M button.
- Link states: Default, Active, Disabled; 32-pixel visual height, 14/500 label,
  optional 16-pixel icons, and a 4-pixel content gap.
- Input + Button example: an M Secondary button is placed inside the 56-pixel
  input field with an 8-pixel trailing inset.
- Home Top App Bar: 76-pixel top scrim with no bar-level blur; UserPill and
  actions use `surfaceGlass` and `blur.glass = 24`.
- Page Top App Bar: 56-pixel `canvasGlass` surface with
  `blur.glass = 24`, intended to overlay scrolling page content.
- Bottom Nav: a 94-pixel full-width bottom scrim containing a centered glass
  pill; one to five 80 × 54 preferred items; a four-slot composition for three
  items; equal-width responsive items when the preferred composition does not
  fit; four-pixel pill padding; selected accent-glass surface;
  `blur.glass = 24`.
- Modal Dialog: 320-pixel surface, 24-pixel backdrop blur, 40-pixel action
  bottom inset, and exact row or stacked action geometry.
- Bottom Sheet: 42-pixel action bottom inset and fixed 72-pixel app-bar edge
  slots around the centered title; the 480-pixel glow remains horizontally
  centered at every host width, while content sizing is the Flutter default.
- Toast: 48-pixel glass pill in 242-pixel Undo, 238-pixel Action, and 194-pixel
  Info reference compositions.
- Inline Alert: 342 × 74 pixels with 12-pixel vertical padding, a 20-pixel
  status icon, and tone-specific semantic surface and border roles.
- Progress Bar: 342-pixel track compositions with Left, Right, Top, and Both
  label arrangements and Default, Success, and Error states.
- Spinner: 16, 24, and 32-pixel extents with 1.5, 2, and 2.5-pixel strokes.
- Card: 342 × 148 reference composition, 16-pixel radius and padding,
  20-pixel header, 16-pixel content gap, and arbitrary body content.

## Source of truth

Penpot is the only authority for visual UI and tokens. Ticket prose, raw hex
in Vikunja, screenshot captions, and Skeleton shimmer recipes are not.

Do not implement or change appearance unless Penpot MCP is connected to the
Design System file and the target variant has been dumped (`fills`, `strokes`,
layout, tokens). If the plugin is not connected, stop and wait for a reconnect.

## Sync workflow

1. Read `tokenOverview()`, every raw token value, and reusable color/gradient
   assets through Penpot MCP.
2. Validate light/dark names and counts before code generation.
3. Convert raw names to the stable semantic Dart schema.
4. Diff generated reference values; never generate public declarations.
5. Inspect affected components and export representative shapes.
6. Update tests and intentional goldens.
7. Classify semantic meaning changes separately from value-only changes.

The MCP access token is operational configuration and must never be committed.
The next iteration should automate steps 1-4 with a validated intermediate JSON
artifact excluded from the runtime package.
