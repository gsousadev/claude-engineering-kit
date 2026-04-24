#!/bin/bash
set -e

# update-kit.sh — Atualiza framework do projeto sem sobrescrever customizações locais
# Uso: ./scripts/update-kit.sh [--version v1.1.0]

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KIT_METADATA="$PROJECT_ROOT/.kit-metadata.json"
NEW_VERSION="${1:-main}"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --version)
      NEW_VERSION="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Validar que estamos em um projeto inicializado
if [ ! -f "$KIT_METADATA" ]; then
  echo "❌ Erro: .kit-metadata.json não encontrado"
  echo "Execute primeiro: scripts/init-project.sh"
  exit 1
fi

# Ler metadata
KIT_REPO=$(jq -r '.kit_repo' "$KIT_METADATA")
CURRENT_VERSION=$(jq -r '.kit_version' "$KIT_METADATA")

echo "🔄 Atualizando claude-engineering-kit"
echo "   Versão atual: $CURRENT_VERSION"
echo "   Nova versão:  $NEW_VERSION"
echo ""

# Validar que CLAUDE.local.md existe (projeto customizado)
if [ ! -f "$PROJECT_ROOT/CLAUDE.local.md" ]; then
  echo "⚠️  CLAUDE.local.md não existe. Pulando atualização."
  exit 1
fi

# Fazer backup de arquivos críticos
BACKUP_DIR="$PROJECT_ROOT/.kit-backup-$(date +%s)"
mkdir -p "$BACKUP_DIR"

echo "💾 Fazendo backup de customizações..."
cp "$PROJECT_ROOT/CLAUDE.local.md" "$BACKUP_DIR/CLAUDE.local.md"
cp "$PROJECT_ROOT/.claudeignore" "$BACKUP_DIR/.claudeignore" 2>/dev/null || true
echo "✓ Backup em $BACKUP_DIR"

# Baixar nova versão do kit
TEMP_KIT=$(mktemp -d)
trap "rm -rf $TEMP_KIT" EXIT

echo "📦 Baixando kit ($NEW_VERSION)..."
cd "$TEMP_KIT"
git clone --depth 1 --branch "$NEW_VERSION" "$KIT_REPO" . 2>/dev/null || {
  echo "❌ Erro: não conseguiu clonar $NEW_VERSION"
  echo "   Verifique a tag: git ls-remote --tags $KIT_REPO | grep $NEW_VERSION"
  exit 1
}
cd "$PROJECT_ROOT"

echo "✓ Kit baixado"
echo ""

# IMPORTANTE: Atualizar APENAS os arquivos do framework, NUNCA sobrescrever customizações
echo "📋 Atualizando framework (preservando customizações)..."

# .claude/CLAUDE.md — SEMPRE atualiza (é do kit)
echo "   Atualizando .claude/CLAUDE.md..."
cp "$TEMP_KIT/.claude/CLAUDE.md" "$PROJECT_ROOT/.claude/CLAUDE.md"
echo "   ✓ .claude/CLAUDE.md"

# CLAUDE.md — SEMPRE atualiza (é template)
echo "   Atualizando CLAUDE.md..."
cp "$TEMP_KIT/template/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"
echo "   ✓ CLAUDE.md"

# CLAUDE.local.md — NUNCA sobrescreve (é customização)
echo "   ⊘ CLAUDE.local.md (preservado)"

# .claudeignore — pode atualizar, mas preserva se foi customizado
if diff -q "$PROJECT_ROOT/.claudeignore" "$BACKUP_DIR/.claudeignore" >/dev/null 2>&1; then
  # Arquivo não foi mudado, atualiza
  echo "   Atualizando .claudeignore..."
  cp "$TEMP_KIT/template/.claudeignore" "$PROJECT_ROOT/.claudeignore"
  echo "   ✓ .claudeignore"
else
  # Arquivo foi customizado, pede ao usuário
  echo "   ⚠️  .claudeignore foi customizado localmente"
  echo "      Preserve (recomendado): y"
  echo "      Atualizar: n"
  read -p "      Escolha [y/n]: " CHOICE
  if [ "$CHOICE" = "n" ]; then
    cp "$TEMP_KIT/template/.claudeignore" "$PROJECT_ROOT/.claudeignore"
    echo "   ✓ .claudeignore (atualizado)"
  else
    echo "   ✓ .claudeignore (preservado)"
  fi
fi

# ADR template
echo "   Atualizando docs/decisions/ADR-TEMPLATE.md..."
cp "$TEMP_KIT/template/docs/decisions/ADR-TEMPLATE.md" "$PROJECT_ROOT/docs/decisions/ADR-TEMPLATE.md"
echo "   ✓ docs/decisions/ADR-TEMPLATE.md"

echo ""

# Atualizar metadata
echo "📝 Atualizando .kit-metadata.json..."
jq \
  --arg version "$NEW_VERSION" \
  --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '.kit_version = $version | .updated_at = $timestamp' \
  "$KIT_METADATA" > "$KIT_METADATA.tmp"
mv "$KIT_METADATA.tmp" "$KIT_METADATA"
echo "✓ .kit-metadata.json"

echo ""
echo "✅ Atualização completa!"
echo ""
echo "📊 Mudanças:"
echo "   Framework: $CURRENT_VERSION → $NEW_VERSION"
echo "   Customizações: preservadas ✓"
echo ""
echo "💡 Próximos passos:"
echo "   1. Revise as mudanças: git diff CLAUDE.md"
echo "   2. Se tudo ok: git add .claude CLAUDE.md .claudeignore .kit-metadata.json"
echo "   3. Commit: git commit -m 'chore: update claude-engineering-kit to $NEW_VERSION'"
echo ""
echo "   Backup disponível em: $BACKUP_DIR (pode deletar depois)"
echo ""
