# SPEC: [Nome da Feature ou Tarefa]

> **Status:** draft | review | approved | in-progress | done  
> **Modelo sugerido:** Sonnet (design) → Haiku (implementação)  
> **Tasks:** [specs/tasks/TASKS-nome-da-feature.json](tasks/TASKS-nome-da-feature.json)  
> **Criado em:** YYYY-MM-DD  
> **Atualizado em:** YYYY-MM-DD

---

## 1. Objetivo

<!-- Uma frase clara. O que isso entrega e por quê importa. -->

**Exemplo:** Permitir que administradores importem registros em lote via CSV, reduzindo o tempo de cadastro de horas para minutos.

---

## 2. Contexto

<!-- Por que agora? O que existe hoje? Qual dor isso resolve? -->

- **Situação atual:** ...
- **Problema:** ...
- **Solução proposta:** ...
- **Fora do escopo:** ...

---

## 3. Arquitetura Afetada

<!-- Liste apenas os caminhos reais do projeto. Não descreva o que não muda. -->

| Arquivo | Ação | Observação |
|---------|------|------------|
| `src/...` | criar | ... |
| `src/...` | modificar | ... |

---

## 4. Requisitos Funcionais

<!-- RF = obrigatório. Cada item deve ser verificável. -->

- **RF-01:** ...
- **RF-02:** ...
- **RF-03:** ...

---

## 5. Requisitos Não-Funcionais

<!-- Apenas os que realmente impactam este escopo. -->

- **RNF-01 (Performance):** ...
- **RNF-02 (Segurança):** ...

---

## 6. Regras de Negócio

<!-- Invariantes que o código deve garantir. -->

- **RN-01:** ...
- **RN-02:** ...

---

## 7. Critérios de Aceite

<!-- Checklist que define "done". Executável por QA ou por teste automatizado. -->

- [ ] RF-01 funciona com dados válidos
- [ ] RF-01 rejeita dados inválidos com erro apropriado
- [ ] Nenhum teste existente quebrou

---

## 8. Pontos de Atenção / Riscos

<!-- O que pode dar errado? Dependências externas? Decisões técnicas não óbvias? -->

- **Risco 1:** ... → Mitigação: ...
- **Risco 2:** ... → Mitigação: ...

---

## 9. Referências

<!-- Links, issues, PRs, conversas relevantes. -->

- Issue #...
- [Documentação externa](https://...)

---

## 10. Contexto para Execução por Modelo Inferior

<!-- Esta seção é usada quando um modelo menor (Haiku) vai executar as tasks.
     Deve ser auto-suficiente: o modelo NÃO tem acesso ao histórico desta conversa. -->

**Para executar esta spec, leia na ordem:**
1. Este arquivo completo
2. `specs/tasks/TASKS-nome-da-feature.json` — lista de tasks com status
3. Apenas os arquivos listados na seção 3 que forem relevantes para a task atual

**Convenções deste projeto:**
<!-- Preencha com as convenções reais do projeto: stack, comandos, padrões de código -->
- Stack: ...
- Comandos de teste: ...
- Padrões de código: ...

**Verificação de conclusão por task:**
```bash
# Substitua pelo comando de teste real do projeto
```
