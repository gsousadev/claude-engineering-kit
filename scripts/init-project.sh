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
mkdir -p "$PROJECT_ROOT/.claude/kit"
mkdir -p "$PROJECT_ROOT/specs/tasks"
mkdir -p "$PROJECT_ROOT/docs/decisions"

# 2. Baixar kit
echo "📦 Baixando kit..."
TEMP_KIT=$(mktemp -d)
trap "rm -rf $TEMP_KIT" EXIT

cd "$TEMP_KIT"
git clone --depth 1 --branch "$KIT_VERSION" "$KIT_REPO" . 2>/dev/null || {
  echo "❌ Erro: não conseguiu clonar $KIT_VERSION. Tente --kit-version main"
  exit 1
}
cd "$PROJECT_ROOT"

# 3. Copiar arquivos do framework para .claude/kit/ (sempre sobrescreve — são do kit)
echo "📋 Copiando framework para .claude/kit/..."

cp "$TEMP_KIT/.claude/kit/assistant.md" "$PROJECT_ROOT/.claude/kit/assistant.md"
echo "✓ .claude/kit/assistant.md"

cp "$TEMP_KIT/.claude/kit/workflow.md" "$PROJECT_ROOT/.claude/kit/workflow.md"
echo "✓ .claude/kit/workflow.md"

cp "$TEMP_KIT/template/docs/decisions/ADR-TEMPLATE.md" "$PROJECT_ROOT/docs/decisions/ADR-TEMPLATE.md"
echo "✓ docs/decisions/ADR-TEMPLATE.md"

mkdir -p "$PROJECT_ROOT/scripts"
cp "$TEMP_KIT/scripts/update-kit.sh" "$PROJECT_ROOT/scripts/update-kit.sh"
chmod +x "$PROJECT_ROOT/scripts/update-kit.sh"
echo "✓ scripts/update-kit.sh"

# 4. CLAUDE.md — cria ou faz append com @imports do kit
echo "📝 Configurando CLAUDE.md..."
KIT_CLAUDE_MARKER="# claude-engineering-kit"
KIT_CLAUDE_BLOCK="$KIT_CLAUDE_MARKER
@.claude/kit/assistant.md
@.claude/kit/workflow.md"

if [ ! -f "$PROJECT_ROOT/CLAUDE.md" ]; then
  cat > "$PROJECT_ROOT/CLAUDE.md" <<EOF
$KIT_CLAUDE_BLOCK

# Projeto

<!-- Adicione aqui instruções específicas do projeto -->
EOF
  echo "✓ CLAUDE.md (novo)"
elif grep -q "$KIT_CLAUDE_MARKER" "$PROJECT_ROOT/CLAUDE.md"; then
  echo "⊘ CLAUDE.md (bloco do kit já existe, preservado)"
else
  echo "" >> "$PROJECT_ROOT/CLAUDE.md"
  echo "$KIT_CLAUDE_BLOCK" >> "$PROJECT_ROOT/CLAUDE.md"
  echo "✓ CLAUDE.md (bloco do kit adicionado ao existente)"
fi

# 5. .claudeignore — cria ou faz append com padrões do kit
echo "📝 Configurando .claudeignore..."
KIT_IGNORE_MARKER="# claude-engineering-kit"
KIT_IGNORE_BLOCK="$KIT_IGNORE_MARKER
# Dependencies
node_modules/
vendor/
.venv/
venv/
env/

# Build outputs
dist/
build/
*.egg-info/
__pycache__/
*.pyc
.next/
.nuxt/
out/

# Package locks
package-lock.json
yarn.lock
composer.lock
Gemfile.lock
poetry.lock

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db

# Temp
tmp/
temp/
*.tmp

# Database
*.sqlite
*.sqlite3
*.db"

if [ ! -f "$PROJECT_ROOT/.claudeignore" ]; then
  echo "$KIT_IGNORE_BLOCK" > "$PROJECT_ROOT/.claudeignore"
  echo "✓ .claudeignore (novo)"
elif grep -q "$KIT_IGNORE_MARKER" "$PROJECT_ROOT/.claudeignore"; then
  echo "⊘ .claudeignore (bloco do kit já existe, preservado)"
else
  echo "" >> "$PROJECT_ROOT/.claudeignore"
  echo "$KIT_IGNORE_BLOCK" >> "$PROJECT_ROOT/.claudeignore"
  echo "✓ .claudeignore (bloco do kit adicionado ao existente)"
fi

# 6. .gitignore — cria ou faz append com arquivos do framework
echo "📝 Configurando .gitignore..."
KIT_GIT_MARKER="# claude-engineering-kit — arquivos do framework"
KIT_GIT_BLOCK="$KIT_GIT_MARKER
.claude/kit/
docs/decisions/ADR-TEMPLATE.md
scripts/update-kit.sh
.kit-backup-*"

if [ ! -f "$PROJECT_ROOT/.gitignore" ]; then
  echo "$KIT_GIT_BLOCK" > "$PROJECT_ROOT/.gitignore"
  echo "✓ .gitignore (novo)"
elif grep -q "$KIT_GIT_MARKER" "$PROJECT_ROOT/.gitignore"; then
  echo "⊘ .gitignore (bloco do kit já existe, preservado)"
else
  echo "" >> "$PROJECT_ROOT/.gitignore"
  echo "$KIT_GIT_BLOCK" >> "$PROJECT_ROOT/.gitignore"
  echo "✓ .gitignore (bloco do kit adicionado ao existente)"
fi

# 7. CLAUDE.local.md — nunca sobrescreve
if [ ! -f "$PROJECT_ROOT/CLAUDE.local.md" ]; then
  cp "$TEMP_KIT/template/CLAUDE.local.md" "$PROJECT_ROOT/CLAUDE.local.md"
  echo "✓ CLAUDE.local.md (novo)"
else
  echo "⊘ CLAUDE.local.md (já existe, preservado)"
fi

# 8. claude-kit.json — manifest declarativo
cat > "$PROJECT_ROOT/claude-kit.json" <<EOF
{
  "kit_version": "$KIT_VERSION",
  "kit_repo": "$KIT_REPO",
  "initialized_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
echo "✓ claude-kit.json"

# 9. Git init + commit apenas arquivos do projeto
echo ""
echo "📚 Preparando git..."
if [ ! -d "$PROJECT_ROOT/.git" ]; then
  git -C "$PROJECT_ROOT" init
  echo "✓ git init"
fi

git -C "$PROJECT_ROOT" add \
  CLAUDE.md \
  CLAUDE.local.md \
  claude-kit.json \
  .gitignore \
  .claudeignore \
  specs/ \
  docs/decisions/ \
  2>/dev/null || true

git -C "$PROJECT_ROOT" commit -m "chore: initialize claude-engineering-kit ($KIT_VERSION)" 2>/dev/null || {
  echo "⊘ git commit (repo vazio ou sem mudanças)"
}

# 10. Resumo
echo ""
echo "✅ Pronto!"
echo ""
echo "Versionar estes (são do projeto):"
echo "  CLAUDE.md         ← @imports do kit + instruções do projeto"
echo "  CLAUDE.local.md   ← customize com stack, contexto, convenções"
echo "  claude-kit.json   ← manifest do kit (versão, repo)"
echo "  .claudeignore     ← padrões do kit + customizações do projeto"
echo "  specs/            ← specs do projeto"
echo "  docs/decisions/   ← ADRs do projeto"
echo ""
echo "Não versionar (gerenciados pelo kit — já no .gitignore):"
echo "  .claude/kit/      ← framework encapsulado"
echo "  scripts/update-kit.sh"
echo "  docs/decisions/ADR-TEMPLATE.md"
echo ""
echo "Próximos passos:"
echo "  1. Customize CLAUDE.local.md com o contexto do seu projeto"
echo "  2. git add CLAUDE.local.md && git commit -m 'chore: customize CLAUDE.local.md'"
echo ""
echo "Para atualizar o kit depois: ./scripts/update-kit.sh"
echo ""
