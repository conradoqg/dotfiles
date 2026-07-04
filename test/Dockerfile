# Fresh-install harness dos dotfiles (Linux). Uso:
#   docker build -f test/Dockerfile -t dotfiles-test .        # amd64 nativo
#   docker buildx build --platform linux/arm64 -f test/Dockerfile .   # arm64
#
# O build inteiro é o teste: se qualquer etapa falhar, o build falha.
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
# Ferramentas mínimas de um sistema "cru" + o que o instalador do chezmoi precisa.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git sudo ca-certificates locales && \
    rm -rf /var/lib/apt/lists/*

# Usuário não-root com sudo sem senha (simula uma máquina real; run_onchange usa sudo).
RUN useradd -m -s /bin/bash tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester
USER tester
WORKDIR /home/tester

# Working tree atual dos dotfiles como source do chezmoi.
COPY --chown=tester:tester . /home/tester/.local/share/chezmoi

# Token opcional do GitHub para elevar o rate limit da API (externals versionados).
ARG CHEZMOI_GITHUB_ACCESS_TOKEN=""
ENV CHEZMOI_GITHUB_ACCESS_TOKEN=${CHEZMOI_GITHUB_ACCESS_TOKEN}
ENV PATH="/home/tester/.local/bin:/home/tester/bin:${PATH}"

# 1) Instala chezmoi e aplica (usa o source já presente em ~/.local/share/chezmoi).
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply

# 2) Valida que os binários esperados foram instalados e executam.
RUN set -e; \
    echo "== validando binários =="; \
    for b in eza doggo gitui lazygit lazydocker duf yq ctop k9s micro broot fzf walk dysk jnv cloudflare-speed-cli btop; do \
        command -v "$b" >/dev/null 2>&1 || { echo "FALTOU: $b"; exit 1; }; \
    done; \
    eza --version >/dev/null; \
    btop --version >/dev/null; \
    command -v batcat >/dev/null && command -v fdfind >/dev/null; \
    test -f "$HOME/.oh-my-zsh/oh-my-zsh.sh"; \
    test -f "$HOME/.oh-my-zsh-custom/themes/powerlevel10k/powerlevel10k.zsh-theme"; \
    test ! -e "$HOME/.local/bin/exa" && test ! -e "$HOME/.local/bin/dog"; \
    echo "== chezmoi verify =="; \
    chezmoi verify --exclude=scripts; \
    echo "OK: fresh install validado"

# 3) Idempotência: segundo apply não deve reinstalar pacotes (run_onchange no-op).
RUN set -e; \
    out="$(chezmoi apply 2>&1)"; \
    echo "$out"; \
    if echo "$out" | grep -qi "apt: instalando"; then \
        echo "FALHA: run_onchange reexecutou apt no 2º apply (não idempotente)"; exit 1; \
    fi; \
    echo "OK: idempotente"

CMD ["/bin/zsh"]
