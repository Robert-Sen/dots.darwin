#!/usr/bin/env bash
set -euo pipefail

# hfsync.sh
# Scan Nix files in this repository for `home.file` entries that have
# `mutable = true` and copy the corresponding file from $HOME back into
# the project's source path given by the `source = ...;` attribute.
#
# Usage:
#   ./hfsync.sh
#
# Behavior:
# - Searches all *.nix files under the repository directory that contains this script.
# - For each `home.file = { ... };` block, finds entries of the form:
#     "<home-relative-path>" = { source = ../path/in/repo; mutable = true; ... };
# - If `mutable = true` is present, copies "$HOME/<home-relative-path>" to
#   the project source path, resolved relative to the directory of the nix file.
#
# Notes / assumptions:
# - `source =` may be quoted or unquoted, and may contain ../ segments.
# - The script is conservative: it will skip entries with no `source` or when the
#   file does not exist in $HOME.
# - The script creates parent directories as needed and preserves file mode/timestamps.
#
# This script is intended to be run from the repository (it resolves the repo
# root based on the script's location).

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf 'Repository root: %s\n' "$REPO_ROOT"

# Helper: trim leading/trailing whitespace
trim() {
  local s="$1"
  # remove leading
  s="${s#"${s%%[![:space:]]*}"}"
  # remove trailing
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# Iterate .nix files
find "$REPO_ROOT" -type f -name '*.nix' -print0 | while IFS= read -r -d '' nixfile; do
  nix_dir="$(dirname "$nixfile")"

  # We'll read the file and manually track braces to find `home.file = { ... }` blocks.
  in_home_block=0
  home_brace_count=0

  # Use a file descriptor to allow safe nested reads
  exec 3< "$nixfile"
  while IFS= read -r line <&3 || [ -n "$line" ]; do
    if [ "$in_home_block" -eq 0 ]; then
      if [[ $line =~ home\.file[[:space:]]*=[[:space:]]*\{ ]]; then
        in_home_block=1
        # initialize brace count based on occurrences on this line
        open_count=$(grep -o '{' <<<"$line" | wc -l | tr -d ' ')
        close_count=$(grep -o '}' <<<"$line" | wc -l | tr -d ' ')
        home_brace_count=$((home_brace_count + open_count - close_count))
      fi
    else
      # update brace count for home block
      open_count=$(grep -o '{' <<<"$line" | wc -l | tr -d ' ')
      close_count=$(grep -o '}' <<<"$line" | wc -l | tr -d ' ')
      home_brace_count=$((home_brace_count + open_count - close_count))

      # detect an entry start: "some/path" = {
      if [[ $line =~ ^[[:space:]]*\"([^\"]+)\"[[:space:]]*=[[:space:]]*\{ ]]; then
        key="${BASH_REMATCH[1]}"
        entry_brace=1
        entry_content=""

        # read the rest of the entry until its closing brace
        while IFS= read -r l <&3 || [ -n "$l" ]; do
          entry_content+="$l
"
          open2=$(grep -o '{' <<<"$l" | wc -l | tr -d ' ')
          close2=$(grep -o '}' <<<"$l" | wc -l | tr -d ' ')
          entry_brace=$((entry_brace + open2 - close2))
          if [ "$entry_brace" -le 0 ]; then
            break
          fi
        done

        # Check if mutable = true exists in the entry block
        if grep -qE 'mutable[[:space:]]*=[[:space:]]*true' <<<"$entry_content"; then
          # Extract the source = ...; line (first occurrence)
          src_line="$(grep -oE 'source[[:space:]]*=[[:space:]]*[^;]+;' <<<"$entry_content" | head -n 1 || true)"
          if [ -z "$src_line" ]; then
            printf '[WARN] %s: entry for %s marked mutable but no source found\n' "$nixfile" "$key"
          else
            # Remove 'source =' and trailing semicolon
            src="$(sed -E 's/source[[:space:]]*=[[:space:]]*//; s/;[[:space:]]*$//; s/^[[:space:]]*//; s/[[:space:]]*$//' <<<"$src_line")"
            # Strip surrounding quotes if any
            src="${src#\"}"; src="${src%\"}"
            src="${src#\'}"; src="${src%\'}"

            home_file="$HOME/$key"

            # Resolve destination path relative to nix file directory when src is relative
            if [[ "$src" = /* ]]; then
              dest_path="$src"
            else
              # Normalize: if src begins with ./ remove, but keep ../ segments
              dest_path="$nix_dir/$src"
            fi

            # Collapse redundant components if possible (prefer the `realpath -m` if available)
            if command -v realpath >/dev/null 2>&1; then
              # use -m to resolve .. even if target does not exist
              dest_path="$(realpath -m "$dest_path")"
            else
              # Try a portable collapse using python if available
              if command -v python3 >/dev/null 2>&1; then
                dest_path="$(python3 -c 'import os,sys; print(os.path.normpath(sys.argv[1]))' "$dest_path")"
              else
                # fallback: leave as-is
                :
              fi
            fi

            if [ ! -e "$home_file" ]; then
              printf '[WARN] home file does not exist: %s (skipping)\n' "$home_file"
            else
              dest_dir="$(dirname "$dest_path")"
              mkdir -p "$dest_dir"
              cp -p "$home_file" "$dest_path"
              printf 'Copied: %s -> %s\n' "$home_file" "$dest_path"
            fi
          fi
        fi
      fi

      # If we've closed the home.file block, stop treating lines as inside it
      if [ "$home_brace_count" -le 0 ]; then
        in_home_block=0
        home_brace_count=0
      fi
    fi
  done

  exec 3<&-
done

printf 'Done.\n'
