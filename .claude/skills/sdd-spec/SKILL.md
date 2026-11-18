---
name: sdd-spec
description: Cria a especificação (spec.md) de uma feature do redesign a partir de um pedido da pessoa ou de uma ideia da seção "Ideias futuras" de docs/architecture.md. Use quando a pessoa pedir para especificar, detalhar ou "começar" uma feature ou tela (por exemplo "spec da busca geral" ou "/sdd-spec copiar citação"). Não escreve código.
argument-hint: "<pedido ou ideia, ex.: busca geral do site>"
---

# sdd-spec

Transforma um pedido (ou uma ideia futura do histórico) numa especificação clara e conferível. **Não escreve código** e **não cria plano técnico**.

## Antes de começar
1. Leia `docs/architecture.md`: design system, rotas, convenções e comandos, mais as seções "Decisões de design e de produto", "Ideias futuras" e "Fluxo de trabalho com specs (SDD)" (fluxo, regras e numeração).
2. Identifique o pedido em `$ARGUMENTS`; a origem é o pedido da pessoa ou uma ideia da seção "Ideias futuras" de `docs/architecture.md`. Se for ambíguo, pergunte qual.
3. Veja `docs/specs/` (se a pasta não existir, não há spec em andamento) e a numeração em "Fluxo de trabalho com specs (SDD)" para achar o próximo número (`NNN`) e conferir se já existe spec para o pedido. Se existir, pergunte se é para atualizar.
4. Se houver tela equivalente no protótipo (link em "Referências visuais" de `docs/architecture.md`), use-o como referência opcional, e leia o código atual dos arquivos citados no item, para descrever o que muda em relação ao que existe. Se a tela tiver equivalente no Observatório (`../observatorio_geo_hist`), veja a documentação dele em `docs/` como referência.

## O que fazer
1. Crie `docs/specs/NNN-nome-curto/spec.md` com o modelo abaixo. Escreva para quem vai revisar: frases curtas, sem jargão de implementação.
2. Descreva **comportamento observável**, não estrutura de código. Nada de nomes de classes novas nem de arquitetura: isso é do plano.
3. Escreva critérios de aceite que possam ser conferidos como "passou" ou "não passou" (com larguras 390, 768 e 1280 px quando houver layout).
4. Tudo o que não estiver decidido vira **pergunta em aberto**. Não invente. Pergunte à pessoa (use `AskUserQuestion` quando forem poucas decisões objetivas) e registre as respostas na spec.
5. Ao terminar, mostre um resumo curto, liste as perguntas que ainda restam e **pare para aprovação**. Só mude o status para `aprovada` quando a pessoa disser que aprova.

## Modelo do `spec.md`

```markdown
# NNN. Título da feature

- **Status:** rascunho
- **Origem:** pedido da pessoa ou ideia futura (ex.: busca geral do site)
- **Protótipo:** aba correspondente (link em "Referências visuais" de docs/architecture.md) ou "não se aplica"
- **Criada em:** AAAA-MM-DD

## Objetivo
Uma ou duas frases: o que a pessoa que usa o site passa a conseguir ou ver, e por quê.

## Situação atual
Como funciona hoje (com os arquivos principais), em poucas linhas.

## Comportamento
O que muda, tela por tela ou seção por seção. Inclua textos reais da interface.

## Estados
- **Carregando:**
- **Vazio:**
- **Erro:**
- **Sem imagem / imagem com falha:** (quando houver imagens)
- **Casos de borda:** (0, 1, 2 e muitos itens, texto muito longo etc.)

## Responsivo
Comportamento em celular (390), tablet (768) e desktop (1280).

## Acessibilidade
Foco por teclado, nomes acessíveis, contraste, movimento reduzido.

## Dados e regras de negócio
Que dados a tela usa e o que não pode mudar (modelos, rotas, regras já existentes).

## Critérios de aceite
- [ ] Critério 1, conferível
- [ ] Critério 2

## Fora do escopo
O que fica de fora de propósito.

## Perguntas em aberto
- Nenhuma. (ou lista)

## Histórico de mudanças
- AAAA-MM-DD: criada.
```

## Regras
- Uma spec cobre uma entrega que a pessoa consiga revisar de uma vez. Se o item for grande (uma fase inteira), proponha dividir em várias specs e pergunte.
- Não copie documentos inteiros: referencie a origem e detalhe só o necessário.
- Siga as regras de design do `docs/architecture.md` nos critérios de aceite (tokens, contraste, estados obrigatórios).
- Se a spec vem de uma ideia futura, remova o item de "Ideias futuras" de `docs/architecture.md` só depois de a feature ser verificada.
