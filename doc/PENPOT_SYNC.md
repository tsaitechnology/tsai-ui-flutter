# Penpot Synchronization

Source file:

```text
team-id: 94d08ab2-b712-814a-8008-482d5efb1ac1
file-id: ab506819-5bcf-801f-8008-4e8f605cef78
library: Design System
```

Latest snapshot read on 2026-07-31:

- sets: `dark`, `light`, `typography`, `spacing`;
- color roles include glass canvas, surface, accent-surface, and accent-text
  values for both themes;
- reusable color assets: `top-light`, `top-dark`, `bottom-light`, and
  `bottom-dark`, normalized as semantic top/bottom scrim gradients;
- typography roles: 20;
- spacing values: 12, including `spacing.6 = 6` and `spacing.12 = 12`;
- button axes: state, type, size;
- button matrix: 4 × 4 × 2 = 32 variants.
- icon/loader slot: 16 × 16, with a 12-pixel loader path and 1.5 stroke;
- icon-to-text gap: 8 pixels for L and 4 pixels for M;
- loading replaces the icon in the same slot without changing button width.
- M button: 40 pixels high, `radius.md`, 12-pixel start and 16-pixel end
  padding.
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
