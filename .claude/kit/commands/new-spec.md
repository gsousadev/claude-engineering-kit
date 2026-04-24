# Comando: /cek:new-spec

Cria uma nova especificação de feature seguindo o framework CEK.

## Instruções

Quando este comando for executado, faça o seguinte:

1. **Pergunte** ao usuário:
   - Nome da feature (será usado como nome do arquivo)
   - Objetivo em uma frase
   - Escopo: quais partes do projeto são afetadas?
   - Tem prazo ou dependência com outra feature?

2. **Pesquise o projeto** antes de escrever qualquer coisa:
   - Leia `specs/` para ver specs existentes e evitar conflitos de nomenclatura
   - Leia apenas os arquivos de rota/entrada relevantes ao escopo informado pelo usuário (primeiras 30 linhas)
   - Consulte `CLAUDE.local.md` para entender stack, paths e convenções do projeto

3. **Crie os dois arquivos** baseados nos templates:
   - `specs/SPEC-[nome-da-feature].md` (a partir de `specs/_TEMPLATE_SPEC.md`)
   - `specs/tasks/TASKS-[nome-da-feature].json` (a partir de `specs/tasks/_TEMPLATE_TASKS.json`)

4. **Preencha os templates** com as informações reais do projeto `{{PROJECT_NAME}}`. Não deixe placeholders genéricos — cada campo deve refletir este projeto. Use as convenções de `CLAUDE.local.md`.

5. **Informe o usuário** sobre:
   - Caminhos dos dois arquivos criados
   - Qual modelo usar para executar (Haiku para tasks mecânicas, Sonnet para design/arquitetura)
   - Contexto mínimo sugerido para o próximo chat de execução

## Token Economy

- Leia arquivos de referência apenas pelas seções necessárias (use offset/limit)
- Não leia node_modules, vendor, build, dist (ver .claudeignore)
- Se precisar de mais de 5 arquivos para preencher a spec, pare e pergunte — a feature provavelmente deve ser dividida
