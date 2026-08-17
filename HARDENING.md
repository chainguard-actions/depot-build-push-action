<!-- markdownlint-disable -->

# Hardening Report: depot--build-push-action/v1.18.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **depot--build-push-action/v1.18.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Workflow uses actions pinned to mutable tags instead of full 40-character commit SHAs, making the workflow vulnerable to supply-chain attacks if the tag is moved. Failing references: 'release-drafter/release-drafter@v6'

Locations:

- `.github/workflows/release-drafter.yml:12`

### unpinned-uses (severity: high)

Workflow uses actions pinned to mutable tags instead of full 40-character commit SHAs, making the workflow vulnerable to supply-chain attacks if the tag is moved. Failing references: 'actions/publish-action@v0.3.0'

Locations:

- `.github/workflows/release.yml:17`

### missing-permissions (severity: medium)

Workflow file has no top-level 'permissions:' key and the single job ('release-drafter') also has no job-level 'permissions:' key. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad (e.g., write access to contents). A minimal permissions block should be added.

Locations:

- `.github/workflows/release-drafter.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed all three findings: (1) Pinned release-drafter/release-drafter@v6 to SHA 6a93d829887aa2e0748befe2e808c66c0ec6e4c7 in release-drafter.yml; (2) Pinned actions/publish-action@v0.3.0 to SHA f784495ce78a41bac4ed7e34a73f0034015764bb in release.yml; (3) Added top-level permissions block (contents: write, pull-requests: write) to release-drafter.yml — these are the minimal permissions required by the release-drafter action to create draft releases and manage pull-request labels.

