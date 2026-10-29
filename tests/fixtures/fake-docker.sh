#!/bin/sh
# Fake docker: intercepts `docker buildx build` (records args), passes other commands through.
LOG_DIR="${FAKE_DEPOT_LOG_DIR:-/tmp/fake-depot}"
mkdir -p "$LOG_DIR"
if [ "$1" = "buildx" ] && [ "$2" = "build" ]; then
  shift 2
  : > "$LOG_DIR/docker-args"
  for a in "$@"; do
    printf '%s\n' "$a" >> "$LOG_DIR/docker-args"
  done
  prev=""
  for a in "$@"; do
    if [ "$prev" = "--metadata-file" ]; then
      printf '%s\n' '{"containerimage.digest":"sha256:fallbackdigest0003"}' > "$a"
    fi
    prev="$a"
  done
  echo "fake docker buildx build complete"
  exit 0
fi
for d in /usr/bin /usr/local/bin; do
  if [ -x "$d/docker" ]; then
    exec "$d/docker" "$@"
  fi
done
exit 0
