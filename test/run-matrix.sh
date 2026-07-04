#!/usr/bin/env bash
# Roda o fresh-install harness para uma ou mais arquiteturas.
#   ./test/run-matrix.sh                 # amd64 + arm64
#   ./test/run-matrix.sh linux/amd64     # só amd64
# Defina CHEZMOI_GITHUB_ACCESS_TOKEN para evitar o rate limit da API do GitHub.
set -euo pipefail
cd "$(dirname "$0")/.."

PLATFORMS="${1:-linux/amd64,linux/arm64}"
token_arg=()
[ -n "${CHEZMOI_GITHUB_ACCESS_TOKEN:-}" ] && \
    token_arg=(--build-arg "CHEZMOI_GITHUB_ACCESS_TOKEN=${CHEZMOI_GITHUB_ACCESS_TOKEN}")

# Para arquiteturas não-nativas, registra o qemu binfmt uma vez (idempotente).
host_arch="$(uname -m)"
for plat in ${PLATFORMS//,/ }; do
    case "$plat" in
        linux/arm64) want=aarch64 ;;
        linux/amd64) want=x86_64 ;;
        *) want="" ;;
    esac
    if [ -n "$want" ] && [ "$want" != "$host_arch" ]; then
        echo "==> registrando emulação qemu para $plat"
        docker run --privileged --rm tonistiigi/binfmt --install "${plat#linux/}" >/dev/null 2>&1 || true
    fi
done

for plat in ${PLATFORMS//,/ }; do
    echo "==================== build $plat ===================="
    docker build --platform "$plat" -f test/Dockerfile \
        "${token_arg[@]}" \
        -t "dotfiles-test:${plat//\//-}" .
done
echo "==================== matriz OK ===================="
