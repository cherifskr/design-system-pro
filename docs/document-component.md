# Generate proper docs for a component — `/ds document`

> **Prerequisites** : skill installed, Claude Code restarted, a component file in your project.

## Scenario

You have a `Button` component that's been used 180 times across your app. Nobody on the team fully understands its API anymore. You tried writing the doc twice, you gave up twice. Now a new contractor joins and asks: *"what's the difference between `variant='ghost'` and `variant='secondary'`?"*

Time to automate this.

## Step 1 — Run it

Three ways to pass the component:

```
/ds document Button                                   # by name (skill finds the file)
/ds document src/components/ui/button.tsx             # explicit path
/ds document                                          # skill asks which one you want
```

## Step 2 — Watch the extraction

The skill performs targeted file reads — not a full repo scan. It:

1. **Locates the file** (Glob on the name, excluding tests/stories)
2. **Reads the component + its neighbors** (barrel `index.ts`, related styles)
3. **Extracts the API**:
   - Props (name, type, default, JSDoc if present)
   - Variants (parsed from `cva()`, `tailwind-variants`, or discriminated unions)
   - States (hover/focus/active/disabled/loading — inferred from classes and handlers)
   - A11y signals (aria-*, role, type="button", focus-visible rings)
   - Tokens consumed (which colors / spacings / radii the component references)

If the code is ambiguous (e.g., no JSDoc and an unclear prop name), the skill **asks you** rather than inventing.

## Step 3 — Read the output

You get a full markdown spec, ready to paste into:

- Your Notion DS page
- Storybook MDX
- A Slack canvas
- The team wiki

**Sections included** (in this order) :

```
1. Name + one-liner description
2. When to use + when to use something else
3. API table (props, types, defaults, description)
4. Variants & states (with mini code examples)
5. Accessibility checklist + keyboard shortcuts
6. Code examples (basic, composition, form integration)
7. Do's & Don'ts (3+ of each)
8. Tokens consumed (a reference list)
9. Design decisions (optional — if you added comments, they surface here)
```

## Step 4 — Review and share

The skill doesn't write to your codebase — it **outputs** the markdown. You:

1. **Read it end-to-end.** Does anything feel wrong or inaccurate?
2. **Add design decisions.** The skill can't know *why* you picked `rounded-full` — paste a paragraph explaining intent.
3. **Publish.** Commit as `docs/components/button.md` or paste into your docs site.

## Common next actions

- **The skill missed a prop.** → You probably have an untyped `...props` spread. Ask: "also document the HTML button attributes this component forwards".
- **One variant has no real usage** → that's a signal. Cross-check with `/ds audit` to confirm it's orphan.
- **The spec feels thin for a compound component** (e.g., `Card.Header`, `Card.Body`) → run `/ds document Card` and ask the skill to expand each subcomponent.

## Tips

- **Document the top-10 most-reused components first.** That's 90% of your DS value.
- **Re-run after major changes.** If you add a variant, re-generate the doc rather than patching by hand — cheaper and more consistent.
- **Use the a11y checklist as PR criteria.** If the doc lists 8 a11y checks and your PR doesn't match, you know what to fix.

## Pitfalls

- **Don't blindly commit the first draft.** The skill is good but not infallible — especially on design intent. A 2-minute read catches 90% of issues.
- **If the skill invents a default value, push back.** Every number in the output should come from the file. Ask it to show you the source line.
- **Compound components need the parent context.** Running `/ds document CardHeader` alone might miss the coordination with `Card`. Run `/ds document Card` instead.

## What comes next

- Use the output as your **input to `/ds extend`** when proposing a similar pattern — "design the new `Alert` component to match the structure of `Button`".
- Keep the generated docs **in your repo** under `docs/components/`. Your future self (and your new hires) will thank you.

See also: [first-audit.md](./first-audit.md) for the broader picture, [extend-pattern.md](./extend-pattern.md) for net-new components.
