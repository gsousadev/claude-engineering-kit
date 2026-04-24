# claude-engineering-kit

Framework replicável para trabalhar com Claude em engenharia de software — estrutura, economia de tokens, specs, e governance em um template versionado.

**Autor:** Guilherme Santos  
**Licença:** MIT

---

## O Que É

Este é um **repo de framework** que você instala uma vez por projeto. Ele fornece:

- ✅ Instruções para Claude (assistente principal + economia de tokens)
- ✅ Estrutura de specs (SPEC-driven workflow)
- ✅ Template de ADRs para decisões arquiteturais
- ✅ Scripts de inicialização e manutenção
- ✅ Padrão `.claudeignore` universal
- ✅ Versionamento semântico — evolua o framework sem quebrar projetos

**Nunca sobrescreve customizações locais** — quando você atualiza o kit, seus arquivos (CLAUDE.local.md, memory/, specs/) ficam intocados.

---

## Instalação Rápida

### Opção 1: Curl (recomendado para novo projeto)

```bash
cd meu-projeto/
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
```

Isso cria:
```
.claude/CLAUDE.md              ← Instruções do assistente
.claude/projects/{id}/memory/  ← Auto-memory do projeto
CLAUDE.md                       ← Spec-driven workflow
CLAUDE.local.md                 ← Customização do projeto (preencha isto)
.claudeignore                   ← Padrões universais
docs/decisions/                 ← ADRs
specs/                          ← Specs em andamento
scripts/update-kit.sh           ← Atualizar depois
```

### Opção 2: Clone manual (se quer revisar antes)

```bash
git clone https://github.com/gsousadev/claude-engineering-kit.git /tmp/kit
cd meu-projeto
cp -r /tmp/kit/template/* .
cp /tmp/kit/.claude .
cp /tmp/kit/scripts .
```

---

## Estrutura

```
claude-engineering-kit/
├── .claude/
│   ├── CLAUDE.md              # Instruções do assistente (portável, sênior)
│   └── projects/{id}/memory/  # Memória auto do projeto (vazio no kit)
├── template/
│   ├── CLAUDE.md              # Template de workflow
│   ├── CLAUDE.local.md        # Stub para customizar
│   ├── .claudeignore          # Ignore patterns
│   └── docs/decisions/        # Templates de ADR
├── scripts/
│   ├── init-project.sh        # Inicializa novo projeto
│   ├── update-kit.sh          # Atualiza framework (preserva customizações)
│   └── verify-structure.sh    # [futuro] Valida instalação
└── README.md
```

---

## Uso — Fluxo Diário

### 1. Primeira vez no projeto

```bash
# Inicializar kit
./scripts/init-project.sh

# Customizar para seu projeto
nano CLAUDE.local.md
# → Preencha: nome, stack, comandos, convenções, token budget

# Commit
git add CLAUDE.md CLAUDE.local.md .claudeignore docs/ scripts/
git commit -m "chore: initialize claude-engineering-kit"
```

### 2. Trabalhar com specs

Veja [CLAUDE.md](template/CLAUDE.md) para o workflow de specs:

```bash
# Criar spec (abra Claude Code e use /new-spec)
/new-spec task-name

# Revisar
/review-spec specs/SPEC-task-name.md

# Executar task a task
/run-spec specs/SPEC-task-name.md

# Ver status
/spec-status
```

### 3. Atualizar o kit depois (próxima versão)

```bash
./scripts/update-kit.sh --version v1.1.0
```

Isso:
- ✅ Baixa novo kit
- ✅ Atualiza `.claude/CLAUDE.md` (instruções)
- ✅ Atualiza `CLAUDE.md` (template)
- ✅ **NUNCA** toca `CLAUDE.local.md` (sua customização)
- ✅ **NUNCA** toca `memory/`, `specs/`, `docs/decisions/`

---

## Casos de Uso

### Novo projeto (fresh start)

```bash
mkdir meu-novo-projeto && cd $_
git init
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
nano CLAUDE.local.md  # customize
git add .
git commit -m "initial commit with claude-engineering-kit"
```

### Projeto existente (sem kit ainda)

```bash
cd projeto-legado/
# Se já tem git:
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
git add .
git commit -m "chore: install claude-engineering-kit"

# Se não tem git:
git init
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
```

### Atualizar para nova versão do kit

```bash
cd projeto-com-kit/
./scripts/update-kit.sh --version v1.1.0
git diff CLAUDE.md  # revise mudanças
git add .claude CLAUDE.md .kit-metadata.json
git commit -m "chore: upgrade claude-engineering-kit to v1.1.0"
```

---

## Troubleshooting

### "❌ .kit-metadata.json não encontrado"

Você rodou `update-kit.sh` em um projeto que não foi inicializado com o kit.  
**Solução:** Execute `init-project.sh` primeiro.

### "❌ Erro: não conseguiu clonar $VERSION"

A tag não existe no repo ou está escrita errado.  
**Solução:**
```bash
# Listar tags disponíveis:
git ls-remote --tags https://github.com/gsousadev/claude-engineering-kit.git

# Depois rodar update-kit.sh com versão correta:
./scripts/update-kit.sh --version v1.0.0
```

### "⚠️ CLAUDE.local.md não existe"

O projeto não foi inicializado corretamente.  
**Solução:**
```bash
# Restaurar do backup (se existe .kit-backup-*):
cp .kit-backup-*/CLAUDE.local.md .

# Ou refazer manualmente baseado em template:
cp template/CLAUDE.local.md CLAUDE.local.md
nano CLAUDE.local.md
```

### Script de curl não roda / ssh key error

Você está usando SSH e não tem chave configurada.  
**Solução:** Use HTTPS ou configure SSH:
```bash
# SSH (garanta que ~/.ssh/config aponta para GitHub)
curl -s https://... | bash

# Ou manual:
git clone https://github.com/gsousadev/claude-engineering-kit.git /tmp/kit
cp -r /tmp/kit/scripts .
./scripts/init-project.sh
```

---

## Contribuindo / Mantendo

Se quer melhorar o kit:

1. **Fork ou clone** o repo
2. **Mude e teste** em um projeto dummy
3. **Commit + tag**:
   ```bash
   git add .
   git commit -m "chore: add feature X"
   git tag v1.1.0
   git push origin main v1.1.0
   ```
4. **Projetos usam** `./scripts/update-kit.sh --version v1.1.0`

---

## Versioning

Semântico: `MAJOR.MINOR.PATCH`

- **MAJOR:** mudanças breaking (estrutura, remoção de arquivo)
- **MINOR:** features novas (template novo, script melhorado)
- **PATCH:** fixes (typo, script bug)

Update sempre funciona para MINOR/PATCH sem quebra.

---

## Licença

MIT. Use livremente.

---

## FAQ

**P: Posso customizar CLAUDE.md (instruções do assistente)?**  
R: Sim. Copie para `CLAUDE.md` (já acontece na init) e customize. O kit não sobrescreve depois.

**P: Posso desabilitar specs? Meu projeto é muito simples.**  
R: Sim. Simplesmente não use `/new-spec`. O kit é flexível.

**P: E se não quiser auto-memory?**  
R: O `.claude/projects/{id}/memory/` é opcional. Claude trata como ignore se vazio.

**P: Como faço deploy? Devo commitar .claude/ ?**  
R: Sim, `CLAUDE.md` e `CLAUDE.local.md` devem estar no git. `.claudeignore` garante que Claude não lê `node_modules/`, `vendor/`, etc. durante análise.

**P: Posso ter múltiplos projetos com versões diferentes do kit?**  
R: Sim. Cada projeto tem seu `.kit-metadata.json` — cada um atualiza independente.

---

## Suporte

Problemas? Abra issue em: https://github.com/gsousadev/claude-engineering-kit/issues

