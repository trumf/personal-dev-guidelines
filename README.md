# personal-dev-guidelines

Central repository for personal design, development, and architecture guidelines. Projects consume this repo as a **Git submodule** at `.guidelines`, with thin **Cursor rule wrappers** in `.cursor/rules/` that reference the shared docs.

## Why submodule (not symlink or subtree)

| Approach | Pros | Cons |
|----------|------|------|
| **Submodule** (recommended) | Pinned per project; explicit updates; portable | Extra `git submodule` commands |
| Symlink | Simple locally | Breaks on other machines / clones |
| Subtree | No submodule mental model | Duplicates files in every project history |

## Quick start (new project)

From your project root (replace `YOUR_USERNAME` with your GitHub user):

```bash
bash /path/to/personal-dev-guidelines/bin/init-project.sh git@github.com:YOUR_USERNAME/personal-dev-guidelines.git
```

Or after cloning this repo locally:

```bash
bash ../personal-dev-guidelines/bin/init-project.sh git@github.com:YOUR_USERNAME/personal-dev-guidelines.git
```

Then edit `.cursor/rules/99-project-context.mdc` and commit:

```bash
git commit -m "Add shared development guidelines"
```

## Manual setup

```bash
git submodule add git@github.com:YOUR_USERNAME/personal-dev-guidelines.git .guidelines
mkdir -p .cursor/rules
cp .guidelines/templates/cursor/rules/*.mdc .cursor/rules/
# Edit 99-project-context.mdc for this project
git add .gitmodules .guidelines .cursor/rules
git commit -m "Add shared development guidelines"
```

## Repo layout

```txt
personal-dev-guidelines/
  design.md
  development.md
  architecture.md
  ai-agent-workflow.md
  documentation.md
  templates/cursor/rules/    # copied into each project's .cursor/rules/
  bin/init-project.sh
```

## Cursor rules (tiered activation)

Wrappers are installed into each project's `.cursor/rules/`. Content lives in `.guidelines/*.md`; wrappers only control **when** rules load.

| Rule file | Activation | Loads |
|-----------|------------|--------|
| `00-core.mdc` | Always | Inline core principles (~25 lines) |
| `10-development.mdc` | Agent-requested (`description`) | `@.guidelines/development.md` |
| `20-design.mdc` | Agent-requested | `@.guidelines/design.md` |
| `30-architecture.mdc` | Agent-requested | `@.guidelines/architecture.md` |
| `40-ai-workflow.mdc` | Agent-requested | `@.guidelines/ai-agent-workflow.md` |
| `50-documentation.mdc` | Globs: `README.md`, `docs/**/*.md` | `@.guidelines/documentation.md` |
| `99-project-context.mdc` | Always | Per-project stack, goals, constraints |

Only **two** rules use `alwaysApply: true` (`00-core`, `99-project-context`) to keep the always-on context small.

## Per-project overrides

Edit `.cursor/rules/99-project-context.mdc` in each project (not in this central repo). The bootstrap script **does not overwrite** an existing `99-project-context.mdc` on re-run.

Add extra project-only rules under `.cursor/rules/` as needed (e.g. `project-api.mdc` with globs for your API paths).

## Updating guidelines in a project

After you push changes to this central repo:

```bash
git submodule update --remote --merge .guidelines
git add .guidelines
git commit -m "Update shared guidelines"
```

If wrapper templates in `templates/cursor/rules/` changed:

```bash
bash .guidelines/bin/init-project.sh
git add .cursor/rules
git commit -m "Refresh Cursor rule wrappers"
```

Submodule pins a specific commit—projects do **not** auto-update until you run the commands above.

## Publishing this repo

```bash
git remote add origin git@github.com:YOUR_USERNAME/personal-dev-guidelines.git
git add -A
git commit -m "Initial personal dev guidelines"
git push -u origin main
```

Update `YOUR_USERNAME` in `bin/init-project.sh` default URL or pass the URL as the first argument when bootstrapping projects.

## Filling in content

Guideline markdown files currently use `TODO` stubs. Replace them with your own principles over time. Keep each file focused and under ~150 lines so Cursor rules stay effective.
