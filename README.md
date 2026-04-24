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

**Nunca sobrescreve customizações locais** — quando você atualiza o kit, seus arquivos (`CLAUDE.md`, `CLAUDE.local.md`, `specs/`, `docs/decisions/`) ficam intocados.

---

## Estrutura no Projeto Consumidor

```
meu-projeto/
├── CLAUDE.md                  ← versionar — @imports do kit + instruções do projeto
├── CLAUDE.local.md            ← versionar — stack, contexto, convenções (preencha isto)
├── claude-kit.json            ← versionar — manifest do kit (versão, repo)
├── .claudeignore              ← versionar — padrões do kit + customizações do projeto
├── .gitignore                 ← versionar — inclui bloco que ignora .claude/kit/
├── specs/                     ← versionar — specs do projeto
├── docs/decisions/            ← versionar — ADRs do projeto
│
└── .claude/
    └── kit/                   ← NÃO versionar — gerenciado pelo kit (como node_modules)
        ├── assistant.md       ← instruções do assistente
        └── workflow.md        ← spec-driven workflow
```

---

## Instalação

### Novo projeto

```bash
mkdir meu-projeto && cd $_
git init
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
```

O script cria toda a estrutura, configura os `@imports` no `CLAUDE.md` e adiciona `.claude/kit/` ao `.gitignore`.

### Projeto existente

```bash
cd meu-projeto/
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash
```

O script detecta o que já existe e **nunca sobrescreve**:

| Arquivo | Comportamento |
|---------|--------------|
| `CLAUDE.md` | Faz **append** do bloco `@.claude/kit/assistant.md` + `@.claude/kit/workflow.md` |
| `.claudeignore` | Faz **append** do bloco de padrões do kit |
| `.gitignore` | Faz **append** do bloco que ignora `.claude/kit/` |
| `CLAUDE.local.md` | Cria apenas se não existir |
| `specs/`, `docs/decisions/` | Cria apenas se não existir |

---

## Fluxo Diário

### 1. Primeira vez no projeto

```bash
# Inicializar kit
curl -s https://raw.githubusercontent.com/gsousadev/claude-engineering-kit/main/scripts/init-project.sh | bash

# Customizar para seu projeto
nano CLAUDE.local.md
# → Preencha: nome, stack, comandos, convenções, token budget

# Commit
git add CLAUDE.md CLAUDE.local.md claude-kit.json .claudeignore .gitignore docs/ specs/
git commit -m "chore: initialize claude-engineering-kit"
```

### 2. Trabalhar com specs

```bash
/new-spec task-name      # cria SPEC-task-name.md
/review-spec             # valida antes de executar
/run-spec                # executa task a task
/spec-status             # visão geral
```

### 3. Atualizar o kit

```bash
./scripts/update-kit.sh --version v1.1.0
# Só atualiza .claude/kit/ — seus arquivos ficam intocados
git add claude-kit.json
git commit -m "chore: update claude-engineering-kit to v1.1.0"
```

---

## O Que o Update Toca (e o Que Não Toca)

| Arquivo | Update toca? |
|---------|-------------|
| `.claude/kit/assistant.md` | ✅ sempre atualiza |
| `.claude/kit/workflow.md` | ✅ sempre atualiza |
| `docs/decisions/ADR-TEMPLATE.md` | ✅ sempre atualiza |
| `scripts/update-kit.sh` | ✅ sempre atualiza |
| `claude-kit.json` | ✅ atualiza versão |
| `CLAUDE.md` | ❌ nunca toca |
| `CLAUDE.local.md` | ❌ nunca toca |
| `.claudeignore` | ❌ nunca toca |
| `specs/` | ❌ nunca toca |
| `docs/decisions/*.md` | ❌ nunca toca |

---

## Troubleshooting

### "❌ claude-kit.json não encontrado"

Você rodou `update-kit.sh` em um projeto não inicializado com o kit.  
**Solução:** Execute `init-project.sh` primeiro.

### "❌ Erro: não conseguiu clonar $VERSION"

A tag não existe ou está escrita errado.  
```bash
# Listar tags disponíveis:
git ls-remote --tags https://github.com/gsousadev/claude-engineering-kit.git
./scripts/update-kit.sh --version v1.0.0
```

### Claude não está lendo as instruções do kit

Verifique se `CLAUDE.md` contém os `@imports`:
```markdown
# claude-engineering-kit
@.claude/kit/assistant.md
@.claude/kit/workflow.md
```
Se não tiver, adicione manualmente ou re-execute `init-project.sh` (vai fazer append).

---

## Versioning

Semântico: `MAJOR.MINOR.PATCH`

- **MAJOR:** mudanças breaking (estrutura, remoção de arquivo)
- **MINOR:** features novas (template novo, script melhorado)
- **PATCH:** fixes (typo, script bug)

---

## Licença

MIT. Use livremente.
