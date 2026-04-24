# CLAUDE.local.md — Contexto do Projeto

<!-- INSTRUÇÃO: Este arquivo é customizado por projeto. Defina aqui:
     - Nome e objetivo do projeto
     - Stack técnico (linguagens, frameworks, BD)
     - Comandos principais (test, lint, serve, deploy)
     - Estrutura de diretórios e convenções obrigatórias
     - Token budget estimado
     - Última sessão com Claude
-->

## Projeto

**[Nome do Projeto]** — [descrição em 1 frase]

**Stack:**
- Backend: [tecnologia + versão]
- Frontend: [tecnologia + versão]
- Infra: [BD, cache, etc.]

---

## Comandos

### Backend
```bash
# [exemplo de teste]
# [exemplo de lint]
# [exemplo de build/serve]
```

### Frontend
```bash
# [exemplo de teste]
# [exemplo de lint]
# [exemplo de serve dev]
```

### Completo (se Makefile/docker-compose)
```bash
make up          # sobe stack
make down        # para stack
make test        # roda testes
```

---

## Arquitetura

[Descreva estrutura de diretórios + camadas principais]

| Caminho | Papel |
|---------|-------|
| `src/` | [role] |
| `tests/` | [role] |

---

## Token Economy — Cálculo de Sessão

**Base:** [200k total / 5h = padrão, customize se diferente]

**Fórmula estimativa por task:**
- **Simples** (1 arquivo, < 50 linhas): ~2,000 tokens
- **Média** (2-3 arquivos, < 200 linhas): ~5,000–8,000 tokens
- **Complexa** (4+ arquivos, refatoring): ~10,000–15,000 tokens

---

## Convenções Obrigatórias

[Defina padrões específicos do projeto:]
- Nomenclatura (português/inglês, snake_case/camelCase)
- Estrutura de arquivos
- Padrões de erro/log
- Auth/multi-tenant rules
- Soft deletes, foreign keys, etc.

---

## Última Sessão

<!-- Atualize após cada sessão produtiva -->
- **YYYY-MM-DD:** [resumo do que foi feito]

