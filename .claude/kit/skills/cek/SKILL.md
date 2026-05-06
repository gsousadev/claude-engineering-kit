# Skill: /cek

Orquestrador principal do Claude Engineering Kit para o projeto `{{PROJECT_NAME}}`.

Representa o framework CEK na conversa: usa plan mode para alinhar escopo, edit mode para executar com precisão, identifica oportunidades de ADR, e guia o usuário pelo workflow spec-driven.

---

## Quando invocar esta skill

O usuário pode invocar `/cek` em qualquer momento:
- "quero implementar X"
- "preciso redesenhar Y"
- "tem uma decisão aqui sobre Z"
- "onde estamos?" / "o que está em andamento?"
- sem argumentos (modo interativo)

---

## Comportamento por modo

### Modo: sem argumento ou pedido vago

Entre em conversa para entender o objetivo:

1. Pergunte: "O que você quer fazer?" (se não está claro)
2. Identifique o tipo de trabalho:
   - **Nova feature / mudança não-trivial** → fluxo plan + spec (abaixo)
   - **Bug simples** (1 arquivo, < 10 linhas) → implemente direto, sem spec
   - **Status geral** → chame `/cek:spec-status`
   - **Decisão arquitetural** → sinalize oportunidade de ADR (ver seção ADR)

### Modo: nova feature ou mudança não-trivial

**ETAPA 1 — Plan mode (alinhar escopo)**

Entre em plan mode ANTES de criar qualquer arquivo:

```
ENTRE EM PLAN MODE agora.
```

No plan mode:
- Faça as perguntas do `/cek:new-spec` (nome, objetivo, escopo, prazo/dependência)
- Leia `CLAUDE.local.md` para entender stack e convenções
- Liste os arquivos afetados (não leia conteúdo — apenas nomes e intenção)
- Identifique riscos e dependências
- Apresente o plano: seções da spec, lista de tasks, estimativa de tokens
- Pergunte: "Posso criar a spec com este plano?"

Só saia do plan mode após aprovação do usuário.

**ETAPA 2 — Criar spec (edit mode)**

Após aprovação:
```
ENTRE EM EDIT MODE agora.
```

Execute `/cek:new-spec` com o contexto já coletado no plan mode (não repita perguntas).

**ETAPA 3 — Review**

Imediatamente após criar a spec, execute `/cek:review-spec` no arquivo criado.

Se houver bloqueadores: fique em edit mode para corrigir. Se aprovado: informe e aguarde instrução para executar.

**ETAPA 4 — Execução (edit mode)**

Quando o usuário confirmar execução:

Entre em edit mode e execute `/cek:run-spec` task por task.

Ao final de cada task:
- Relate o que foi feito
- Informe próxima task disponível
- Sugira novo chat se: 3+ tasks executadas, escopo mudou, contexto pesado

---

## Detecção de ADR

Durante qualquer conversa (dentro ou fora de specs), monitore sinais de decisão arquitetural:

**Sinais para identificar:**
- Escolha entre duas abordagens técnicas com tradeoffs reais
- Mudança de padrão estabelecido no projeto (ex: trocar biblioteca, mudar estrutura de pastas)
- Decisão que afeta mais de um módulo ou mais de um desenvolvedor
- Solução que vai contra o padrão convencional e precisa de justificativa
- O usuário diz "decidimos usar X" ou "vamos mudar de Y para Z"

**Quando identificar, sinalize assim:**

```
⚡ ADR identificado: [título curto da decisão]
Isso é uma decisão arquitetural relevante. Quer registrar como ADR em docs/decisions/?
```

Se o usuário confirmar:
1. Entre em edit mode
2. Crie `docs/decisions/ADR-YYYY-MM-DD-[titulo-kebab].md` a partir do template `docs/decisions/ADR-TEMPLATE.md`
3. Preencha com o contexto da conversa: decisão, racional, consequências
4. Saia do edit mode e informe o caminho criado

Não force ADR em toda decisão — apenas nas arquiteturalmente relevantes. Prefira subnotificar a supernotificar.

---

## Resumo do fluxo CEK completo

```
/cek → plan mode → alinha escopo
     → edit mode → /cek:new-spec → /cek:review-spec
     → edit mode → /cek:run-spec (task a task)
     → durante qualquer etapa → detecta ADR → registra se confirmado
```

---

## Token Economy

- No plan mode: leia apenas nomes de arquivos e `CLAUDE.local.md`. Não abra código.
- No edit mode: leia apenas o que a task corrente precisa (`reads` do TASKS.json)
- Não releia arquivos já lidos na sessão
- Sugira novo chat antes de 30k tokens restantes ou após 3 tasks complexas
- Estimativas: simples ~2k tokens, média ~5-8k, complexa ~10-15k

---

## Commands que esta skill orquestra

| Command | Quando usar |
|---------|-------------|
| `/cek:new-spec` | Após alinhar escopo no plan mode |
| `/cek:review-spec` | Logo após criar a spec |
| `/cek:run-spec` | Após aprovação da review |
| `/cek:spec-status` | Quando o usuário quer visão geral |
