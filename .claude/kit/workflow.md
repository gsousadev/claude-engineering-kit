# Workflow — claude-engineering-kit

## Spec-Driven Workflow

**Toda tarefa não-trivial usa o framework de specs antes de escrever código.**

```
1. /new-spec    → cria SPEC-*.md + TASKS-*.json em specs/
2. /review-spec → valida antes de executar
3. /run-spec    → executa task a task (pode usar Haiku)
4. /spec-status → visão geral de tudo em andamento
```

Templates em [specs/_TEMPLATE_SPEC.md](specs/_TEMPLATE_SPEC.md) e [specs/tasks/_TEMPLATE_TASKS.json](specs/tasks/_TEMPLATE_TASKS.json).

**Quando NÃO usar spec:** correções de bug simples (1 arquivo, < 10 linhas), ajustes de texto, renomeações.

---

## Token Economy — Leia Isto Antes de Cada Sessão

- **Novo chat** quando: contexto > 3 tasks executadas, ou mudança de escopo (backend → frontend)
- **Arquivos grandes:** use `offset`/`limit` — nunca leia arquivo inteiro se precisar de 1 função
- **Grep antes de cat:** use `grep -n "NomeDaClasse"` para localizar antes de abrir o arquivo
- **Nunca leia:** `vendor/`, `node_modules/`, `dist/`, `*.lock` (ver [.claudeignore](.claudeignore))
- **Referências de padrão:** sempre leia o equivalente existente antes de criar algo novo
  - Novo controller? Leia `ProductController.php`
  - Novo componente Vue? Leia `ListProducts.vue`
  - Nova migration? Leia a última migration existente
