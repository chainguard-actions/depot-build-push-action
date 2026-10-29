#!/bin/sh
# Fake Depot CLI used by the act tests.
# - `depot` (no args)      -> exit 0 (installed check)
# - `depot version`        -> print a fake version
# - `depot build ARGS...`  -> record ARGS (one per line), DEPOT_TOKEN and secrets,
#                             then write --iidfile / --metadata-file outputs.
# Set FAKE_DEPOT_FAIL=1 to make `depot build` fail.
LOG_DIR="${FAKE_DEPOT_LOG_DIR:-/tmp/fake-depot}"
mkdir -p "$LOG_DIR"

if [ $# -eq 0 ]; then
  echo "fake depot CLI"
  exit 0
fi

case "$1" in
  version)
    echo "depot 0.0.0-fake"
    exit 0
    ;;
  build)
    shift
    ;;
  *)
    echo "fake depot: unsupported command $1" >&2
    exit 1
    ;;
esac

: > "$LOG_DIR/args"
for a in "$@"; do
  printf '%s\n' "$a" >> "$LOG_DIR/args"
done
printf '%s' "${DEPOT_TOKEN:-}" > "$LOG_DIR/token"
: > "$LOG_DIR/secrets"

iid=""
meta=""
prev=""
for a in "$@"; do
  case "$prev" in
    --iidfile) iid="$a" ;;
    --metadata-file) meta="$a" ;;
    --secret)
      id=$(printf '%s' "$a" | sed -n 's/^id=\([^,]*\),src=.*$/\1/p')
      src=$(printf '%s' "$a" | sed -n 's/^id=[^,]*,src=\(.*\)$/\1/p')
      if [ "$id" = "GIT_AUTH_TOKEN" ]; then
        echo "GIT_AUTH_TOKEN=<redacted>" >> "$LOG_DIR/secrets"
      elif [ -f "$src" ]; then
        printf '%s=%s\n' "$id" "$(cat "$src")" >> "$LOG_DIR/secrets"
      else
        printf '%s=<missing>\n' "$id" >> "$LOG_DIR/secrets"
      fi
      ;;
  esac
  prev="$a"
done

if [ "${FAKE_DEPOT_FAIL:-}" = "1" ]; then
  echo "error: fake depot build failure" >&2
  exit 1
fi

if [ -n "$iid" ]; then
  printf 'sha256:fakeimageid0001' > "$iid"
fi
if [ -n "$meta" ]; then
  printf '%s\n' '{"containerimage.digest":"sha256:fakedigest0002","depot.build":{"buildID":"fakebuild123","projectID":"fakeproj456"}}' > "$meta"
fi
echo "fake depot build complete"
exit 0
