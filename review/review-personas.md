# Review personas — {{MODULE_CODE}}

The persona list a review of this extension runs. It is the guide's own list —
[`doc/itop-extension-guide.md`](../doc/itop-extension-guide.md), "Review procedure — persona
passes" — in the guide's order, plus whatever passes this extension adds. Each guide pass is
named rather than copied: its question, what to open and what it blocks are in the guide, which
is the same text in every extension that adopts it.

**Add a pass here, not in the guide,** when it comes from what this extension is rather than from
what every iTop extension is: an endpoint an AI agent calls, a theme people with a screen reader
use, an integration that sends data to another system. A pass that every extension could answer
belongs in the guide instead, for all of them.

**Findings** go beside this file, one per review, named `<date>-<kind>.md`. They are gitignored —
they name real gaps — and only this file is tracked. `exclude.txt` keeps the folder out of the
release archive.

## Red

1. **Red team** — the guide's.

## Purple

2. **Combodo / product fit** — the guide's.
3. **Neighbouring extension** — the guide's.
4. **Upgrading client** — the guide's.
5. **Installing client / operator** — the guide's.
6. **Auditor** — the guide's.
7. **Downstream / competitor** — the guide's.

## Blue

8. **Blue team** — the guide's, over every finding above.
9. **Maintainer** — the guide's.

<!-- An added pass goes where its colour puts it - red first, purple between, blue last - and
     carries a **Question**, what to **Open** in this repository, and what it **Blocks**:
     release, delivery, or backlog. Mark it "added", and say in the paragraph at the top why
     this extension needs it. -->
