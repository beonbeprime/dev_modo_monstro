#!/bin/bash
# Sync script - sincroniza trabalho entre Claude Code Desktop e Web
# Uso: ./scripts/sync.sh [pull|push|status]

set -e

BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
REMOTE="origin"

retry_with_backoff() {
    local max_retries=4
    local delay=2
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        if "$@"; then
            return 0
        fi
        echo "Tentativa $attempt falhou. Aguardando ${delay}s..."
        sleep $delay
        delay=$((delay * 2))
        attempt=$((attempt + 1))
    done
    echo "Erro: todas as $max_retries tentativas falharam."
    return 1
}

case "${1:-status}" in
    pull)
        echo ">> Baixando últimas mudanças de $REMOTE/$BRANCH..."
        retry_with_backoff git pull $REMOTE $BRANCH --rebase 2>/dev/null || echo "Nenhuma mudança remota encontrada."
        echo ">> Sync completo. Repositório atualizado."
        ;;
    push)
        echo ">> Salvando e enviando todas as mudanças..."
        git add -A
        if git diff --cached --quiet; then
            echo "Nenhuma mudança para enviar."
        else
            git commit -m "sync: atualização automática $(date '+%Y-%m-%d %H:%M')"
            retry_with_backoff git push -u $REMOTE $BRANCH
            echo ">> Mudanças enviadas com sucesso."
        fi
        ;;
    save)
        echo ">> Commitando mudanças locais (sem push)..."
        git add -A
        if git diff --cached --quiet; then
            echo "Nenhuma mudança para salvar."
        else
            git commit -m "save: checkpoint local $(date '+%Y-%m-%d %H:%M')"
            echo ">> Checkpoint salvo."
        fi
        ;;
    status)
        echo "== Status de Sincronização =="
        echo "Branch: $BRANCH"
        echo ""
        git status --short
        echo ""
        echo "Últimos commits:"
        git log --oneline -5 2>/dev/null || echo "(nenhum commit ainda)"
        ;;
    *)
        echo "Uso: $0 [pull|push|save|status]"
        echo "  pull   - Baixar últimas mudanças do remoto"
        echo "  push   - Commitar e enviar tudo para o remoto"
        echo "  save   - Commitar localmente sem push"
        echo "  status - Mostrar status atual"
        ;;
esac
