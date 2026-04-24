#!/bin/bash
set -e

# update-kit.sh — Atualiza framework do projeto sem sobrescrever customizações locais
# Uso: ./scripts/update-kit.sh [--version v1.1.0]

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KIT_MANIFEST="$PROJECT_ROOT/claude-kit.json"
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
if [ ! -f "$KIT_MANIFEST" ]; then
  echo "❌ Erro: claude-kit.json não encontrado"
  echo "Execute primeiro: scripts/init-project.sh"
  exit 1
fi

# Ler manifest
KIT_REPO=$(jq -r '.kit_repo' "$KIT_MANIFEST")
CURRENT_VERSION=$(jq -r '.kit_version' "$KIT_MANIFEST")

echo "🔄 Atualizando claude-engineering-kit"
echo "   Versão atual: $CURRENT_VERSION"
echo "   Nova versão:  $NEW_VERSION"
echo ""

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

# Atualizar apenas arquivos do framework em .claude/kit/ (sempre sobrescreve)
echo "📋 Atualizando .claude/kit/..."

mkdir -p "$PROJECT_ROOT/.claude/kit"
cp "$TEMP_KIT/.claude/kit/assistant.md" "$PROJECT_ROOT/.claude/kit/assistant.md"
echo "   ✓ .claude/kit/assistant.md"

cp "$TEMP_KIT/.claude/kit/workflow.md" "$PROJECT_ROOT/.claude/kit/workflow.md"
echo "   ✓ .claude/kit/workflow.md"

mkdir -p "$PROJECT_ROOT/.claude/kit/commands"
cp "$TEMP_KIT/.claude/kit/commands/"*.md "$PROJECT_ROOT/.claude/kit/commands/"
echo "   ✓ .claude/kit/commands/ (templates — não altera .claude/commands/cek/)"

cp "$TEMP_KIT/template/docs/decisions/ADR-TEMPLATE.md" "$PROJECT_ROOT/docs/decisions/ADR-TEMPLATE.md"
echo "   ✓ docs/decisions/ADR-TEMPLATE.md"

cp "$TEMP_KIT/scripts/update-kit.sh" "$PROJECT_ROOT/scripts/update-kit.sh"
chmod +x "$PROJECT_ROOT/scripts/update-kit.sh"
echo "   ✓ scripts/update-kit.sh"

echo ""
echo "   ⊘ CLAUDE.md (preservado — é do projeto)"
echo "   ⊘ CLAUDE.local.md (preservado — é do projeto)"
echo "   ⊘ .claudeignore (preservado — é do projeto)"
echo "   ⊘ specs/ (preservado)"
echo "   ⊘ docs/decisions/*.md (preservado)"
echo "   ⊘ .claude/commands/cek/ (preservado — customizações do projeto)"

# Atualizar manifest
echo ""
echo "📝 Atualizando claude-kit.json..."
jq \
  --arg version "$NEW_VERSION" \
  --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '.kit_version = $version | .updated_at = $timestamp' \
  "$KIT_MANIFEST" > "$KIT_MANIFEST.tmp"
mv "$KIT_MANIFEST.tmp" "$KIT_MANIFEST"
echo "✓ claude-kit.json"

echo ""
echo "✅ Atualização completa!"
echo ""
echo "📊 Framework: $CURRENT_VERSION → $NEW_VERSION"
echo "   Arquivos do projeto: intocados ✓"
echo ""
echo "💡 Próximos passos:"
echo "   1. git add claude-kit.json"
echo "   2. git commit -m 'chore: update claude-engineering-kit to $NEW_VERSION'"
echo ""
