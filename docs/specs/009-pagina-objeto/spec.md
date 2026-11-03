# 009. Página do objeto digital

- **Status:** aprovada
- **Item do planejamento:** Fase 2, entrega 2.3 (tela T-04, rota nova)
- **Protótipo:** aba "Objeto" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Cada objeto ganha um endereço próprio, que pode ser compartilhado, com a ficha completa da curadoria e a ação principal de acessar o recurso. Hoje a ficha fica espremida no cartão e não tem link.

## Situação atual
- A ficha aparece dentro do `ContentCard` da lista do subtema.
- A rota `/:tema/:subtema/:conteúdo` está comentada no `app_router.dart` e dependia de `extra` (não abria por link direto).
- No Firestore, cada objeto é um documento com **id automático** em `themes/{tema}/subthemes/{subtema}/contents`; o código de referência (ex.: `NMA_BH_03`) é o campo `id` do documento.

## Comportamento

### Endereço
- Rota nova `/:tema/:subtema/:codigo`, com o código em minúsculas e hífen (Q-01): por exemplo `/natureza-meio-ambiente/bacias-hidrograficas/nma-bh-03`.
- O código original também abre (`…/bacias-hidrograficas/NMA_BH_03`) e passa a mostrar o endereço no formato com hífen.
- Os links internos do site sempre usam o formato com hífen.
- Abre direto pelo endereço, sem depender da tela anterior.

### Topo
- Botão discreto "← {Subtema}" e migalhas "{Tema} › {Subtema} › Objeto".
- Ícone do tipo e rótulo "Tipo · Formato" (regra de omissão da spec 005).
- Título (`h1`) e descrição em destaque.
- Botões **"Acessar o recurso ↗"** (primário, aba nova) e **"Copiar link"** (secundário). "Copiar link" copia o **endereço do recurso** e muda para "Link copiado" por alguns segundos.
- O endereço do recurso visível em texto pequeno abaixo dos botões, quebrando linha se for longo.

### Nota de conteúdo
- Quando houver, bloco em superfície "Nota de conteúdo" com o texto.

### Ficha da curadoria
- Cabeçalho "Ficha da curadoria" com o código de referência em destaque (fonte monoespaçada).
- Grupos, cada um com título e pares rótulo/valor; campos vazios não aparecem:
  - **Autoria:** Criador, Colaborador.
  - **Conteúdo:** Assuntos (em etiquetas).
  - **Origem:** Tipo, Formato, Idioma, Requisitos, Inserido em (ex.: "12 mar 2025").
  - **Registro:** Código de referência, Ano de emissão, Regras de registro (quando vazio, mostra "Tema geral / Tema específico / Número de referência da curadoria expoGEO").
  - **Direitos e preservação:** Direitos, Ação de preservação, Próxima revisão do link (mês e ano).

### Outros objetos
- Seção em superfície "Outros objetos de {Subtema}" com até 3 cartões de objeto (spec 005) do mesmo subtema, seguindo a ordem do código, sem o atual. Link "Ver todos →" leva ao subtema.
- Some quando o subtema só tem esse objeto.

### Ligações
- "Ver ficha" e o título na lista do subtema (spec 008), o cartão de objeto da Home (spec 005) e o passo 3 de "Como explorar" passam a levar a esta página.

## Estados
- **Carregando:** esqueleto do topo (rótulo, título em duas linhas, descrição, botões) e da ficha.
- **Erro:** caixa "Não conseguimos carregar o objeto" com "Tentar de novo".
- **Não encontrado** (código que não existe, ou que existe em outro subtema): 404 (spec 011).
- **Casos de borda:** objeto sem nota, sem colaborador, sem ano ou sem data de revisão não deixa grupo vazio nem rótulo solto; endereço do recurso inválido desativa "Acessar o recurso" com a dica "Endereço indisponível"; navegador sem acesso à área de transferência mostra "Não deu para copiar. Selecione o endereço abaixo." e seleciona o texto.

## Responsivo
- **390:** botões em largura total, um embaixo do outro; ficha em uma coluna; outros objetos em 1 coluna.
- **768:** botões lado a lado; ficha em duas colunas; outros objetos em 2 colunas.
- **1280:** coluna de leitura de até ~920 px; ficha em três colunas por grupo; outros objetos em 3 colunas.

## Acessibilidade
- Um `h1` (título do objeto); "Ficha da curadoria" e "Outros objetos" como `h2`; grupos da ficha como `h3`; pares como lista de definição.
- "Copiar link" anuncia "Link copiado" a leitores de tela.
- "Acessar o recurso" anuncia que abre em aba nova.
- Item "Temas" ativo na navbar.

## Dados e regras de negócio
- O objeto é procurado pelo código no catálogo único da spec 004 (Q-04), sem diferenciar maiúsculas nem `_`/`-`. Não depende do id automático do documento.
- Datas: `originInfo.insertionDate` e `preservationAction.updateDate`, formatadas em português abreviado.
- Nenhum campo novo; nada é gravado.

## Critérios de aceite
- [ ] Abrir o endereço de um objeto numa aba nova mostra a página completa (sem passar pelo subtema).
- [ ] `…/nma-bh-03` e `…/NMA_BH_03` abrem o mesmo objeto; o segundo passa a mostrar o endereço com hífen.
- [ ] Topo com tipo · formato, título, descrição, "Acessar o recurso", "Copiar link" e o endereço visível.
- [ ] "Acessar o recurso" abre o endereço em aba nova; "Copiar link" copia e mostra "Link copiado".
- [ ] A ficha mostra o código em destaque e todos os campos preenchidos do objeto, nos grupos certos; campos vazios não aparecem.
- [ ] A nota de conteúdo aparece só quando existe.
- [ ] "Outros objetos" mostra até 3 objetos do mesmo subtema, sem o atual, e "Ver todos" leva ao subtema.
- [ ] Na lista do subtema, "Ver ficha" e o título levam a esta página; o cartão da Home também.
- [ ] Código inexistente ou de outro subtema mostra o 404.
- [ ] Esqueleto ao carregar e erro com "Tentar de novo" que funciona.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.

## Fora do escopo
- Visualizar o recurso dentro do site (vídeo, PDF) — continua abrindo na fonte.
- Compartilhar em redes sociais.
- Editar a ficha pela página.

## Perguntas em aberto
- Nenhuma. (Respondidas: Q-01, `nma-bh-03` no endereço, aceitando o código original; Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-01 e Q-04 respondidas.
- 2026-10-27: aprovada.
