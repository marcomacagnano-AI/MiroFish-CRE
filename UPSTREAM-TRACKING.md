# MiroFish-CRE — Upstream Tracking Log

Track upstream `666ghj/MiroFish` changes weekly. Run `./scripts/upstream-diff.sh` and log results here.

## Log

| Date | Upstream HEAD | New Commits | License Status | Notable Changes | Action |
|------|---------------|-------------|----------------|-----------------|--------|
| 2026-04-17 | `fa0f6519` | 0 (pin) | AGPL-3.0 ✅ | Initial fork baseline. 55.8k stars, 260 commits. | Forked + pinned |

## Alert Thresholds

| Signal | Severity | Response |
|--------|----------|----------|
| LICENSE file hash changes | 🚨 CRITICAL | Immediate review. Freeze all upstream porting. |
| CLA or CONTRIBUTOR_LICENSE_AGREEMENT appears | 🚨 CRITICAL | Shanda collecting IP assignment — relicense imminent. |
| README mentions "Enterprise", "Commercial License", "BSL", "SSPL" | ⚠️ HIGH | Evaluate scope. May indicate upcoming dual-license. |
| New major version tag (v2.0+) | ⚠️ HIGH | New major versions are common relicense points. |
| Repo visibility changes to private | 🚨 CRITICAL | Our fork is complete and independent. No action needed but log it. |
| Normal feature commits | ℹ️ INFO | Evaluate for cherry-pick into cairn/main. |
