#!/bin/bash
# MiroFish-CRE Upstream Monitor
# Run weekly: detects license changes, new commits, and commercial language upstream.
# Usage: ./scripts/upstream-diff.sh [repo-dir]
set -euo pipefail

REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo "=== MiroFish Upstream Monitor — $(date -I) ==="
echo ""

# Fetch upstream without merging
git fetch upstream main --quiet 2>/dev/null || {
  echo "❌ Failed to fetch upstream. Is the 'upstream' remote configured?"
  echo "   Run: git remote add upstream https://github.com/666ghj/MiroFish.git"
  exit 1
}

# 1. LICENSE change detection (CRITICAL)
UPSTREAM_LICENSE_HASH=$(git show upstream/main:LICENSE 2>/dev/null | sha256sum | cut -d' ' -f1)
PINNED_LICENSE_HASH=$(git show agpl-pin-2026-04-17:LICENSE 2>/dev/null | sha256sum | cut -d' ' -f1)

if [ -z "$PINNED_LICENSE_HASH" ]; then
  echo "⚠️  Pin tag 'agpl-pin-2026-04-17' not found. Cannot compare license."
elif [ "$UPSTREAM_LICENSE_HASH" != "$PINNED_LICENSE_HASH" ]; then
  echo "🚨 CRITICAL: LICENSE FILE HAS CHANGED UPSTREAM"
  echo "   Pinned hash:  $PINNED_LICENSE_HASH"
  echo "   Current hash: $UPSTREAM_LICENSE_HASH"
  echo "   ACTION REQUIRED: Review license change immediately"
  echo ""
  echo "   Diff:"
  git diff agpl-pin-2026-04-17:LICENSE upstream/main:LICENSE || true
else
  echo "✅ LICENSE unchanged (AGPL-3.0)"
fi

echo ""

# 2. New commits since our pin
NEW_COMMITS=$(git rev-list agpl-pin-2026-04-17..upstream/main --count 2>/dev/null || echo "?")
echo "📊 New upstream commits since pin: $NEW_COMMITS"

if [ "$NEW_COMMITS" != "?" ] && [ "$NEW_COMMITS" -gt 0 ]; then
  echo ""
  echo "Latest 15 upstream commits:"
  git log agpl-pin-2026-04-17..upstream/main --oneline --no-decorate -15
  echo ""

  # 3. Check for concerning file changes
  CHANGED_FILES=$(git diff agpl-pin-2026-04-17..upstream/main --name-only 2>/dev/null)

  LICENSE_FILES=$(echo "$CHANGED_FILES" | grep -iE "LICENSE|CLA|CONTRIBUTOR|TERMS|COMMERCIAL|ENTERPRISE|PRICING" || true)
  if [ -n "$LICENSE_FILES" ]; then
    echo "🚨 ALERT: License/commercial-related files changed upstream:"
    echo "$LICENSE_FILES" | sed 's/^/   /'
    echo ""
  fi

  # 4. Check README for new commercial language
  for README_FILE in README.md README-EN.md; do
    UPSTREAM_README=$(git show "upstream/main:$README_FILE" 2>/dev/null || echo "")
    if [ -n "$UPSTREAM_README" ]; then
      COMMERCIAL_HITS=$(echo "$UPSTREAM_README" | grep -ciE "enterprise|commercial.license|BSL|SSPL|dual.license|paid.plan|subscription|pricing" || true)
      if [ "$COMMERCIAL_HITS" -gt 0 ]; then
        echo "⚠️  Commercial language detected in upstream $README_FILE ($COMMERCIAL_HITS matches)"
        echo "$UPSTREAM_README" | grep -iE "enterprise|commercial.license|BSL|SSPL|dual.license|paid.plan|subscription|pricing" | head -5 | sed 's/^/   /'
        echo ""
      fi
    fi
  done

  # 5. Summary of changed areas
  echo "📁 Changed file areas (top 10 directories):"
  echo "$CHANGED_FILES" | xargs -I{} dirname {} | sort | uniq -c | sort -rn | head -10 | sed 's/^/   /'
fi

echo ""
echo "=== Monitor complete — $(date -I) ==="
