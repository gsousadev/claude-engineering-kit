#!/bin/bash
set -e

# init-project.sh — Inicializa novo projeto com claude-engineering-kit
# Uso: curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash -s -- [--kit-version v1.0.0]

KIT_REPO="https://github.com/gsousadev/claude-engineering-kit.git"
KIT_VERSION="${1:-main}"
PROJECT_ROOT="$(pwd)"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --kit-version)
      KIT_VERSION="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

echo "🚀 Inicializando claude-engineering-kit ($KIT_VERSION) em $PROJECT_ROOT"

# 1. Criar estrutura de diretórios
echo "📁 Criando diretórios..."
mkdir -p .claude/projects/"$(date +%s)"/memory
mkdir -p specs/tasks
mkdir -p docs/decisions

# 2. Baixar kit (via git clone + filtrar arquivos necessários)
echo "📦 Baixando kit..."
TEMP_KIT=$(mktemp -d)
trap "rm -rf $TEMP_KIT" EXIT

cd "$TEMP_KIT"
git clone --depth 1 --branch "$KIT_VERSION" "$KIT_REPO" . 2>/dev/null || {
  echo "❌ Erro: não conseguiu clonar $KIT_VERSION. Tente --kit-version main"
  exit 1
}
cd "$PROJECT_ROOT"

# 3. Copiar framework para projeto (NUNCA sobrescreve CLAUDE.local.md se existir)
echo "📋 Copiando framework..."

# .claude/CLAUDE.md (sempre copia do kit)
cp "$TEMP_KIT/.claude/CLAUDE.md" "$PROJECT_ROOT/.claude/CLAUDE.md"
echo "✓ .claude/CLAUDE.md"

# CLAUDE.md (template)
if [ ! -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  cp "$TEMP_KIT/template/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"
  echo "✓ CLAUDE.md (novo)"
else
  echo "⊘ CLAUDE.md (já existe, pulando)"
fi

# CLAUDE.local.md (stub, nunca sobrescreve)
if [ ! -f "$PROJECT_ROOT/CLAUDE.local.md" ]; then
  cp "$TEMP_KIT/template/CLAUDE.local.md" "$PROJECT_ROOT/CLAUDE.local.md"
  echo "✓ CLAUDE.local.md (novo)"
else
  echo "⊘ CLAUDE.local.md (já existe, pulando)"
fi

# .claudeignore (sempre copia)
cp "$TEMP_KIT/template/.claudeignore" "$PROJECT_ROOT/.claudeignore"
echo "✓ .claudeignore"

# 4. Copiar estrutura de decisões
echo "📐 Copiando templates de ADR..."
cp "$TEMP_KIT/template/docs/decisions/ADR-TEMPLATE.md" "$PROJECT_ROOT/docs/decisions/ADR-TEMPLATE.md"
echo "✓ docs/decisions/ADR-TEMPLATE.md"

# 5. Copiar scripts de manutenção
echo "🔧 Copiando scripts de manutenção..."
mkdir -p scripts
cp "$TEMP_KIT/scripts/update-kit.sh" "$PROJECT_ROOT/scripts/update-kit.sh"
chmod +x "$PROJECT_ROOT/scripts/update-kit.sh"
echo "✓ scripts/update-kit.sh"

# 6. Criar .kit-metadata para rastrear versão
cat > "$PROJECT_ROOT/.kit-metadata.json" <<EOF
{
  "kit_version": "$KIT_VERSION",
  "kit_repo": "$KIT_REPO",
  "initialized_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
echo "✓ .kit-metadata.json"

# 7. Git init + commit
echo ""
echo "📚 Preparando git..."
if [ ! -d "$PROJECT_ROOT/.git" ]; then
  git -C "$PROJECT_ROOT" init
  echo "✓ git init"
fi

git -C "$PROJECT_ROOT" add .claude CLAUDE.md CLAUDE.local.md .claudeignore docs/decisions scripts .kit-metadata.json 2>/dev/null || true
git -C "$PROJECT_ROOT" commit -m "chore: initialize claude-engineering-kit ($KIT_VERSION)" 2>/dev/null || {
  echo "⊘ git commit (repo vazio ou sem mudanças)"
}

# 8. Próximos passos
echo ""
echo "✅ Pronto! Próximos passos:"
echo ""
echo "1. Customize CLAUDE.local.md com o contexto do seu projeto"
echo "2. Atualize memory/ com padrões específicos (se necessário)"
echo "3. Commit: git add CLAUDE.local.md && git commit -m 'chore: customize CLAUDE.local.md'"
echo ""
echo "Para atualizar o kit depois: ./scripts/update-kit.sh"
echo ""
