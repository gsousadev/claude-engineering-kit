# Comando: /cek:run-spec [arquivo]

Executa uma spec existente, task por task, em modo econômico de tokens.

## Uso

```
/cek:run-spec specs/SPEC-nome-da-feature.md
```

## Instruções

### Passo 1 — Carregue o contexto mínimo

Leia **nesta ordem**, parando assim que tiver o necessário:

1. O arquivo SPEC passado como argumento (completo — geralmente < 5KB)
2. O TASKS.json referenciado no cabeçalho da spec
3. `CLAUDE.local.md` — para comandos de teste e convenções do projeto `{{PROJECT_NAME}}`
4. **Apenas os arquivos listados em `reads` da task atual** — não leia outros

Não leia arquivos de vendor, build, node_modules (ver .claudeignore).

### Passo 2 — Identifique a próxima task

No TASKS.json, encontre a primeira task com `"status": "pending"` cujas `dependencies` estejam todas `"done"`.

Informe o usuário:
- ID e título da task
- Arquivos que serão lidos/modificados
- Estimativa de complexidade (simples/média/complexa)

Aguarde confirmação antes de executar.

### Passo 3 — Execute a task

1. Atualize o status para `"in-progress"` no TASKS.json
2. Leia apenas os arquivos listados em `reads` da task
3. Implemente o que está descrito em `details`
4. Verifique com o `test_strategy` da task (use `{{TEST_COMMAND}}` como base)
5. Se passar: atualize status para `"done"`, atualize `_summary` no TASKS.json
6. Se falhar: mantenha `"in-progress"`, relate o erro e aguarde instrução

### Passo 4 — Após cada task concluída

Informe:
- O que foi criado/modificado (lista de arquivos)
- Se há próxima task disponível ou dependências bloqueando
- **Sugestão de novo chat** se:
  - Já foram executadas 3+ tasks nesta sessão
  - O contexto está ficando longo (muitos arquivos lidos)
  - A próxima task é de escopo completamente diferente

Mensagem sugerida de novo chat:
```
Contexto para o próximo chat:
- Spec: specs/SPEC-[nome].md
- Tasks concluídas: [lista de IDs]
- Próxima task: [ID] — [título]
- Comando: /cek:run-spec specs/SPEC-[nome].md
```

## Token Economy

- Nunca leia um arquivo inteiro quando só precisa de uma função: use `offset` e `limit`
- Prefira `grep` a `cat` para localizar onde algo está definido
- Não releia arquivos já lidos nesta sessão
- Se um arquivo é > 200 linhas, leia apenas a seção relevante
