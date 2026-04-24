# Comando: /cek:review-spec [arquivo]

Revisa uma spec antes da execução: valida completude, detecta riscos e sugere divisão se necessário.

## Uso

```
/cek:review-spec specs/SPEC-nome-da-feature.md
```

## Instruções

### O que revisar

**1. Completude**
- Todos os campos obrigatórios estão preenchidos (não há `...` ou `TODO`)?
- Critérios de aceite são verificáveis (checklist concreto)?
- Seção 10 (contexto para modelo inferior) está suficiente para execução autônoma?

**2. Consistência com o projeto**
- Consulte `CLAUDE.local.md` para verificar paths, convenções de nome e comandos
- Os arquivos mencionados na seção 3 seguem a estrutura real do projeto `{{PROJECT_NAME}}`?
- Há conflito com specs existentes em `specs/`?

**3. Granularidade das tasks**
- Cada task tem `reads` definidos (lista mínima de arquivos)?
- Cada task tem `test_strategy` executável com `{{TEST_COMMAND}}`?
- Alguma task cria mais de 3 arquivos? (provavelmente deve ser dividida)
- Há dependências circulares no grafo de tasks?

**4. Riscos e dependências externas**
- A spec depende de algo que ainda não existe no projeto?
- Há mudanças de schema de banco? (precisa de migration + rollback plan)
- Há mudanças que quebram contratos existentes (API, interfaces)?

### Output esperado

```
## ✅ Aprovado
- [lista do que está bem]

## ⚠️ Sugestões
- [melhorias não-bloqueantes]

## ❌ Bloqueadores
- [o que DEVE ser corrigido antes de executar]
```

Se não houver bloqueadores: marque o status da spec como `review` → `approved` no cabeçalho.

## Token Economy

- Use `grep -l` para encontrar arquivos relevantes, não `cat` do arquivo inteiro
- Não leia corpos de arquivos para verificar conflitos — nomes são suficientes
- Este comando não deve usar mais de 4 leituras de arquivo
