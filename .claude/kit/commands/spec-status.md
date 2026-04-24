# Comando: /cek:spec-status

Mostra o status de todas as specs e tasks do projeto `{{PROJECT_NAME}}`.

## Instruções

1. Liste todos os arquivos em `specs/` (excluindo `_TEMPLATE*`)
2. Para cada SPEC encontrado, leia apenas as primeiras 8 linhas (cabeçalho com status)
3. Para cada TASKS.json correspondente, leia apenas o campo `_summary`
4. Monte um relatório:

```
## Status das Specs — [data atual]

| Spec | Status | Tasks: done/total | Próxima task |
|------|--------|-------------------|--------------|
| SPEC-nome.md | in-progress | 3/8 | feature-04 |
| SPEC-outra.md | approved    | 0/5 | feature-01 |
```

5. Ao final, sugira:
   - Qual spec executar agora (prioridade high com status approved)
   - Se alguma spec está bloqueada (dependência não concluída)
   - Se o contexto atual está pesado e vale abrir novo chat para execução

## Token Economy

- Leia apenas as primeiras 8 linhas de cada SPEC (use `limit: 8`)
- Leia apenas o campo `_summary` de cada TASKS.json (use grep ou últimas linhas)
- Este comando inteiro não deve usar mais de 6 leituras de arquivo
