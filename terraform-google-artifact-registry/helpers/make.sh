#!/usr/bin/env bash
# This function runs the flake8 linter on every file
# ending in '.py'
function check_python() {
  echo "Running flake8"
  find . -name "*.py" -exec flake8 {} \;
}

# This function runs the shellcheck linter on every
# file ending in '.sh'
function check_shell() {
  echo "Running shellcheck"
  find . -name "*.sh" -exec shellcheck -x {} \;
}

function generate_docs() {
  echo "Generating markdown docs with terraform-docs"
  TMPFILE=$(mktemp)
  #shellcheck disable=2006,2086
  for j in $(find ./ -name '*.tf' -type f -exec dirname '{}' \; | sort -u | grep -v '.terraform'|grep -v '.terragrunt-cache'); do
    terraform-docs markdown "$j" >"$TMPFILE"
    helpers/combine_docfiles.py "$j"/README.md "$TMPFILE"
  done
  rm -f "$TMPFILE"
}