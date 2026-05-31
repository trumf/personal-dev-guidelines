#!/usr/bin/env bash
# Wire personal-dev-guidelines into the current project as a submodule
# and install Cursor rule wrappers from templates.
#
# Usage (from a project root):
#   bash /path/to/personal-dev-guidelines/bin/init-project.sh [repo-url]
#
# Or after submodule exists:
#   bash .guidelines/bin/init-project.sh
#
set -euo pipefail

REPO_URL="${1:-https://github.com/trumf/personal-dev-guidelines.git}"
SUBMODULE_PATH=".guidelines"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUIDELINES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: not inside a git repository. Run from your project root." >&2
  exit 1
fi

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
cd "${PROJECT_ROOT}"

# Add submodule if missing
if [ ! -d "${SUBMODULE_PATH}/.git" ] && [ ! -f "${SUBMODULE_PATH}/.git" ]; then
  if [ -d "${SUBMODULE_PATH}" ]; then
    echo "Error: ${SUBMODULE_PATH} exists but is not a submodule." >&2
    exit 1
  fi
  echo "Adding submodule ${SUBMODULE_PATH} from ${REPO_URL}..."
  git submodule add "${REPO_URL}" "${SUBMODULE_PATH}"
elif [ ! -d "${SUBMODULE_PATH}" ]; then
  echo "Adding submodule ${SUBMODULE_PATH} from ${REPO_URL}..."
  git submodule add "${REPO_URL}" "${SUBMODULE_PATH}"
else
  echo "Submodule ${SUBMODULE_PATH} already present."
fi

# Resolve template source: submodule in project, or local repo when developing guidelines
TEMPLATE_DIR=""
if [ -d "${SUBMODULE_PATH}/templates/cursor/rules" ]; then
  TEMPLATE_DIR="${SUBMODULE_PATH}/templates/cursor/rules"
elif [ -d "${GUIDELINES_ROOT}/templates/cursor/rules" ]; then
  TEMPLATE_DIR="${GUIDELINES_ROOT}/templates/cursor/rules"
else
  echo "Error: could not find templates/cursor/rules in submodule or script repo." >&2
  exit 1
fi

mkdir -p .cursor/rules

for f in "${TEMPLATE_DIR}"/*.mdc; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  dest=".cursor/rules/${name}"
  if [ "${name}" = "99-project-context.mdc" ] && [ -f "${dest}" ]; then
    echo "Skipping ${dest} (already exists; edit manually)."
    continue
  fi
  cp "${f}" "${dest}"
  echo "Installed ${dest}"
done

git add .gitmodules "${SUBMODULE_PATH}" .cursor/rules 2>/dev/null || true

echo ""
echo "Done. Next steps:"
echo "  1. Edit .cursor/rules/99-project-context.mdc for this project."
echo "  2. git commit -m \"Add shared development guidelines\""
echo ""
echo "Update guidelines later:"
echo "  git submodule update --remote --merge ${SUBMODULE_PATH}"
echo "  bash ${SUBMODULE_PATH}/bin/init-project.sh   # refresh rule wrappers if templates changed"
