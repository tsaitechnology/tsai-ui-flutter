# Penpot Synchronization

Source file:

```text
team-id: 94d08ab2-b712-814a-8008-482d5efb1ac1
file-id: ab506819-5bcf-801f-8008-4e8f605cef78
library: Design System
```

Initial snapshot read on 2026-07-23:

- sets: `dark`, `light`, `typography`, `spacing`;
- color roles: 22 per theme;
- typography roles: 20;
- spacing values: 10;
- button axes: state, type, size;
- button matrix: 4 × 4 × 2 = 32 variants.
- icon/loader slot: 16 × 16, with a 12-pixel loader path and 1.5 stroke;
- icon-to-text gap: 8 pixels for L and 4 pixels for M;
- loading replaces the icon in the same slot without changing button width.

## Sync workflow

1. Read `tokenOverview()` and every raw token value through Penpot MCP.
2. Validate light/dark names and counts before code generation.
3. Convert raw names to the stable semantic Dart schema.
4. Diff generated reference values; never generate public declarations.
5. Inspect affected components and export representative shapes.
6. Update tests and intentional goldens.
7. Classify semantic meaning changes separately from value-only changes.

The MCP access token is operational configuration and must never be committed.
The next iteration should automate steps 1-4 with a validated intermediate JSON
artifact excluded from the runtime package.
