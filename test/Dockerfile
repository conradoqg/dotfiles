# Dotfiles fresh-install harness (Linux). Usage:
#   docker build -f test/Dockerfile -t dotfiles-test .                # native amd64
#   docker build --platform linux/arm64 -f test/Dockerfile .          # arm64 (needs qemu)
#
# The whole build IS the test: if any step fails, the build fails.
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
# Minimal tools of a bare system + what the chezmoi installer needs.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git sudo ca-certificates locales && \
    rm -rf /var/lib/apt/lists/*

# Non-root user with passwordless sudo (simulates a real machine; run_onchange uses sudo).
RUN useradd -m -s /bin/bash tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester
USER tester
WORKDIR /home/tester

# Current dotfiles working tree as the chezmoi source.
COPY --chown=tester:tester . /home/tester/.local/share/chezmoi

# Optional GitHub token to raise the API rate limit (versioned externals).
ARG CHEZMOI_GITHUB_ACCESS_TOKEN=""
ENV CHEZMOI_GITHUB_ACCESS_TOKEN=${CHEZMOI_GITHUB_ACCESS_TOKEN}
ENV PATH="/home/tester/.local/bin:/home/tester/bin:${PATH}"
# Skip heavy/network provisioners (docker-ce, cloud CLIs, AI CLIs) in the harness;
# they are validated on real machines. Core externals + apt are still exercised.
ENV DOTFILES_NO_PROVISION=1

# 1) Install chezmoi and apply (uses the source already at ~/.local/share/chezmoi).
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply

# 2) Validate that the expected binaries were installed and run.
RUN set -e; \
    echo "== validating binaries =="; \
    for b in eza doggo gitui lazygit lazydocker duf yq ctop k9s micro broot fzf \
             walk dysk jnv cloudflare-speed-cli btop \
             rg zoxide delta miniserve fortio globalping ngrok kubectl terraform; do \
        command -v "$b" >/dev/null 2>&1 || { echo "MISSING: $b"; exit 1; }; \
    done; \
    eza --version >/dev/null; \
    btop --version >/dev/null; \
    command -v batcat >/dev/null && command -v fdfind >/dev/null; \
    test -f "$HOME/.oh-my-zsh/oh-my-zsh.sh"; \
    test -f "$HOME/.oh-my-zsh-custom/themes/powerlevel10k/powerlevel10k.zsh-theme"; \
    test ! -e "$HOME/.local/bin/exa" && test ! -e "$HOME/.local/bin/dog"; \
    echo "== chezmoi verify =="; \
    chezmoi verify --exclude=scripts; \
    echo "OK: fresh install validated"

# 3) Idempotency: a second apply must not reinstall packages (run_onchange no-op).
RUN set -e; \
    out="$(chezmoi apply 2>&1)"; \
    echo "$out"; \
    if echo "$out" | grep -qi "apt: installing"; then \
        echo "FAIL: run_onchange re-ran apt on the 2nd apply (not idempotent)"; exit 1; \
    fi; \
    echo "OK: idempotent"

CMD ["/bin/zsh"]
