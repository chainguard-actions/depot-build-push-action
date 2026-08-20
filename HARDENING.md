<!-- markdownlint-disable -->

# Hardening Report: depot--build-push-action/v1.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **depot--build-push-action/v1.17.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Both workflow files reference actions using mutable tags instead of pinned full-length commit SHAs, making them vulnerable to supply-chain attacks if the tag is moved.

- `.github/workflows/release-drafter.yml`: `uses: release-drafter/release-drafter@v6` (tag `v6`)
- `.github/workflows/release.yml`: `uses: actions/publish-action@v0.3.0` (tag `v0.3.0`)

These should be pinned to their full 40-character commit SHA, e.g. `uses: release-drafter/release-drafter@<sha> # v6`.

Locations:

- `.github/workflows/release-drafter.yml:11`
- `.github/workflows/release.yml:18`

### missing-permissions (severity: medium)

`.github/workflows/release-drafter.yml` has no top-level `permissions:` key and the single job `release-drafter` also has no job-level `permissions:` key. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (write access to all scopes on some repositories). A minimal explicit permissions block (e.g. `permissions: contents: write`) should be added.

Locations:

- `.github/workflows/release-drafter.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

1. Pinned release-drafter/release-drafter@v6 to full SHA 6a93d829887aa2e0748befe2e808c66c0ec6e4c7 in release-drafter.yml. 2. Pinned actions/publish-action@v0.3.0 to full SHA f784495ce78a41bac4ed7e34a73f0034015764bb in release.yml. 3. Added top-level `permissions: contents: write` block to release-drafter.yml to satisfy the missing-permissions finding (the action needs contents:write to create/update draft releases).

