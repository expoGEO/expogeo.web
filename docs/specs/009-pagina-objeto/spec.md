# 009. Página do objeto digital

- **Status:** aprovada
- **Item do planejamento:** Fase 2, entrega 2.3 (tela T-04, rota nova)
- **Protótipo:** aba "Objeto" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Cada objeto ganha um endereço próprio, que pode ser compartilhado, com a ficha completa da curadoria e a ação principal de acessar o recurso. Desde a 008 a ficha completa não aparece em nenhum lugar do site: a lista do subtema mostra só um resumo de cada objeto.

## Situação atual
- A lista do subtema (`features/theme/components/object_row.dart`, spec 008) mostra tipo, título, descrição, criador, ano, domínio, até 4 assuntos e "Acessar". O `ContentCard`, que embutia a ficha, saiu na 008.
- "Ver ficha" e o título com link estão prontos na lista, mas ocultos enquanto o destino é a própria página. Tudo depende de `CatalogItem.route`, hoje igual ao endereço do subtema. O cartão de objeto da Home (spec 005) e o exemplo 3 de "Como explorar" usam o mesmo `CatalogItem.route` e levam ao subtema.
- A rota `/:tema/:subtema/:conteúdo` segue comentada no `app_router.dart` e dependia de `extra` (não abria por link direto).
- No Firestore, cada objeto é um documento com **id automático** em `themes/{tema}/subthemes/{subtema}/contents`; o código de referência (ex.: `NMA_BH_03`) é o campo `id` do documento. O catálogo único (`CatalogStore`, spec 004) já carrega os 190 objetos, com tema e subtema tirados do caminho do documento, e abre sob demanda em qualquer tela.
- Já existem e são reaproveitados: `Breadcrumbs`, `AppButton` (com "abre em nova aba" e nome acessível próprio), `ObjectCard` e seu esqueleto, `StateMessageBox`, `AppSkeleton`, `typeLine`, `cardIcon`, `UrlUtils.isOpenable`, estilo `code` do tema, `NotFoundPage` (visual novo na spec 011). Do Observatório vem o padrão do botão de copiar (`CopyButton`).
- **Defeito encontrado na revisão:** o leitor do documento (`ContentResponseModel.fromJson`, no painel) só lê a preservação quando existe a chave `preservationOperation`, que nenhum dos 190 objetos tem; o dado real está em `preservationAction`. Por isso `content.preservationAction` chega sempre vazio ao site.
- **Dados do dev (190 objetos, lidos em 2026-11-05):** códigos únicos e todos no formato `XX_YY_00`, sem colisão ao trocar `_` por `-`; todos têm nota, colaborador, requisitos, regras de registro e preservação; nenhum tem ano de emissão; próxima revisão é sempre `2026-12-01`; todos os endereços são `https` válidos, o maior com 181 caracteres; 3 assuntos no máximo. A produção não foi consultada.

## Comportamento

### Endereço
- Rota nova `/:tema/:subtema/:codigo`, com o código em minúsculas e hífen (Q-01): por exemplo `/natureza-meio-ambiente/bacias-hidrograficas/nma-bh-03`.
- O código original também abre (`…/bacias-hidrograficas/NMA_BH_03`), assim como qualquer mistura de maiúsculas e de `_`/`-`, e o endereço passa a mostrar o formato com hífen.
- Os links internos do site sempre usam o formato com hífen.
- Abre direto pelo endereço, sem depender da tela anterior. Recarregar a página funciona.

### Topo
Sem fundo de superfície nem medalhão, numa coluna de leitura (diferente do cabeçalho de tema e subtema).
- Botão discreto "← {Subtema}" à esquerda e migalhas "{Tema} › {Subtema} › Objeto" à direita. Quando não couberem lado a lado, as migalhas descem de linha. O botão e a migalha do subtema levam ao subtema; a do tema, ao tema.
- Ícone do tipo e rótulo "TIPO · FORMATO" em maiúsculas (regra de omissão da spec 005: sem o formato quando ele é "Outro" ou igual ao tipo).
- Título (`h1`) e descrição em destaque.
- Botões **"Acessar o recurso ↗"** (primário, aba nova) e **"Copiar link"** (secundário). "Copiar link" copia o **endereço do recurso**, como no protótipo, e muda para "Link copiado" por cerca de 2 segundos.
- O endereço do recurso visível em texto pequeno abaixo dos botões, quebrando linha se for longo.

### Nota de conteúdo
- Quando houver, bloco em superfície com o rótulo "Nota de conteúdo" (ícone de documento) e o texto.

### Ficha da curadoria
- Caixa com borda. Cabeçalho "Ficha da curadoria" com o código de referência em destaque, numa pílula com borda, no estilo de código do tema: **Figtree 600 com algarismos tabulares** (decisão da 001, com a 006). Não é fonte monoespaçada: o Flutter web não alcança as fontes do sistema.
- Grupos separados por linha, cada um com título e pares rótulo/valor; campos vazios ou só com espaços não aparecem e grupo sem nenhum campo some:
  - **Autoria:** Criador, Colaborador.
  - **Conteúdo:** Assuntos (em etiquetas, em largura total).
  - **Origem:** Tipo, Formato, Idioma, Requisitos, Inserido em (ex.: "12 mar 2025").
  - **Registro:** Código de referência (na mesma pílula), Ano de emissão, Regras de registro (quando vazio, mostra "Tema geral / Tema específico / Número de referência da curadoria expoGEO").
  - **Direitos e preservação:** Direitos, Ação de preservação, Próxima revisão do link (mês abreviado e ano, ex.: "dez 2026").
- Na ficha, Tipo e Formato mostram sempre o valor gravado, inclusive "Outro": a regra de omissão vale só para o rótulo do topo, como no protótipo.

### Outros objetos
- Seção em superfície, em largura normal de conteúdo, com o título "Outros objetos de {Subtema}" e até 3 cartões de objeto (spec 005) do mesmo subtema, seguindo a ordem do código, sem o atual. Link "Ver todos →" leva ao subtema.
- Some quando o subtema só tem esse objeto.
- Clicar num cartão abre a página daquele objeto, do topo.

### Ligações
- "Ver ficha" e o título na lista do subtema (spec 008), o cartão de objeto da Home (spec 005) e o exemplo 3 de "Como explorar" passam a levar a esta página. A troca é uma só, em `CatalogItem.route`.
- Na lista do subtema, o foco depois de "Carregar mais" passa ao título do primeiro objeto novo, que agora é link (regra da 008).

## Estados
- **Carregando:** botão de voltar e migalhas aparecem na hora, porque vêm do endereço. Esqueleto do rótulo, do título em duas linhas, da descrição, dos botões e da ficha. "Outros objetos" não aparece até os dados chegarem.
- **Erro:** botão de voltar e migalhas continuam. No lugar do resto, caixa de erro "Não conseguimos carregar o objeto" — "Confira sua conexão com a internet e tente de novo." — com "Tentar de novo" (primário, spec 011), que volta ao esqueleto e repete a consulta.
- **Não encontrado** (código que não existe ou que existe em outro subtema; subtema inexistente, de outro tema ou fora da lista do tema, como `movimentos-terra`): página de "não encontrada" (visual novo na spec 011). Com subtema inválido ela aparece na hora; com código inválido, depois de os dados chegarem.
- **Casos de borda:** objeto sem nota, sem colaborador, sem ano ou sem data de revisão não deixa grupo vazio nem rótulo solto. Sem descrição, o espaço dela some. Endereço do recurso inválido ou vazio desativa "Acessar o recurso" e "Copiar link" e mostra o texto visível "Endereço indisponível" abaixo dos botões, seguido do texto gravado, se houver. Navegador sem acesso à área de transferência mostra "Não deu para copiar. Selecione o endereço abaixo." e seleciona o texto do endereço. Título longo, endereço de 181 caracteres e idioma longo quebram linha sem rolagem horizontal.

## Responsivo
Faixas do projeto: celular < 600, tablet de 600 a 1023, desktop ≥ 1024. Coluna de leitura com largura de conteúdo de até 856 px (920 px no protótipo, contando as margens de 32 px).
- **390:** botões em largura total, um embaixo do outro; título do grupo da ficha acima dos pares; pares em uma coluna; outros objetos em 1 coluna.
- **768:** botões lado a lado; título do grupo à esquerda; pares em duas colunas; outros objetos em 2 colunas.
- **1280:** título do grupo à esquerda; pares em três colunas; outros objetos em 3 colunas.
- Grupo com menos pares que colunas divide a largura entre os que tem (`auto-fit` do protótipo).

## Acessibilidade
- Um `h1` (título do objeto); "Ficha da curadoria" e "Outros objetos de {Subtema}" como `h2`; grupos da ficha e títulos dos cartões como `h3`.
- Cada par da ficha é lido junto ("Criador: IBGE"). O Flutter web não gera lista de definição; os pares ficam na ordem do grupo.
- "Copiar link" anuncia "Link copiado" a leitores de tela; a falha anuncia a mensagem. "Acessar o recurso" anuncia que abre em aba nova. O botão "← {Subtema}" anuncia "Voltar para {Subtema}", e "Ver todos" anuncia "Ver todos os objetos de {Subtema}".
- Migalhas com nome "Você está em". Ícone do tipo decorativo. Item "Temas" ativo na navbar.
- Texto laranja sobre superfície usa o laranja forte (rótulo da nota, "Ver todos"), porque o acento normal ali dá 4,48:1.
- Tudo alcançável por teclado, com foco visível.

## Dados e regras de negócio
- O objeto é procurado pelo código, dentro do subtema do endereço, no catálogo único da spec 004 (Q-04), sem diferenciar maiúsculas nem `_`/`-`. Não depende do id automático do documento.
- Datas: `originInfo.insertionDate` e `preservationAction.updateDate`, formatadas em português abreviado, sem conversão de fuso.
- A preservação é lida do campo `preservationAction` do documento pelo catálogo, sem passar pelo leitor do painel (ver "Situação atual"). Objeto com esse campo malformado continua no site, sem os dois itens de preservação.
- Nenhum campo novo; nada é gravado. `ContentModel`, `ContentResponseModel`, regras do Firestore e o painel não mudam.
- É a única rota nova; as demais seguem iguais.

## Critérios de aceite
- [ ] Abrir o endereço de um objeto numa aba nova mostra a página completa, sem passar pelo subtema, e recarregar funciona.
- [ ] `…/nma-bh-03`, `…/NMA_BH_03` e `…/nma_BH-03` abrem o mesmo objeto; os dois últimos passam a mostrar o endereço com hífen, e o voltar do navegador não prende a pessoa no endereço antigo.
- [ ] O topo mostra voltar, migalhas, ícone, tipo · formato com a regra de omissão, título, descrição, "Acessar o recurso", "Copiar link" e o endereço visível; voltar e migalhas levam ao subtema e ao tema.
- [ ] "Acessar o recurso" abre o endereço em aba nova; "Copiar link" copia o endereço do recurso, mostra "Link copiado" e volta ao texto original depois de cerca de 2 segundos.
- [ ] Sem acesso à área de transferência, aparece "Não deu para copiar. Selecione o endereço abaixo." e o endereço fica selecionado.
- [ ] Endereço inválido ou vazio desativa os dois botões e mostra "Endereço indisponível".
- [ ] A nota de conteúdo aparece só quando existe.
- [ ] A ficha mostra o código em destaque (Figtree 600, algarismos tabulares) e todos os campos preenchidos do objeto, nos grupos certos, inclusive ação de preservação e próxima revisão ("dez 2026") com os dados reais do dev.
- [ ] Campos vazios e grupos vazios não aparecem; "Regras de registro" vazio mostra o texto padrão; formato "Outro" aparece na ficha e não no rótulo do topo.
- [ ] "Outros objetos" mostra até 3 objetos do mesmo subtema, na ordem do código, sem o atual; some com um objeto só; "Ver todos" leva ao subtema; abrir um cartão mostra aquele objeto, do topo.
- [ ] Na lista do subtema, "Ver ficha" e o título levam a esta página, o foco de "Carregar mais" vai ao título do primeiro novo, e a lista segue sem `overflow` em 390, 768 e 1280 px.
- [ ] O cartão da Home e o exemplo 3 de "Como explorar" levam a esta página.
- [ ] Código inexistente, código de outro subtema, subtema de outro tema e `movimentos-terra` mostram a página de "não encontrada", e não outro objeto.
- [ ] Esqueleto ao carregar, com voltar e migalhas à vista; erro com "Tentar de novo" que funciona.
- [ ] Em 390, 768 e 1280 px, o layout segue a seção Responsivo, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.
- [ ] Tudo alcançável por teclado com foco visível; um único `h1`, `h2` e `h3` como na seção Acessibilidade; "Voltar para {Subtema}", "abre em nova aba", "Link copiado" anunciado e item "Temas" ativo na navbar.
- [ ] Rotas existentes, Home, tema, subtema e `/sobre` seguem como antes; nada no painel, nos modelos de conteúdo ou nas regras do Firestore mudou.

## Fora do escopo
- Visualizar o recurso dentro do site (vídeo, PDF) — continua abrindo na fonte.
- Compartilhar em redes sociais.
- Editar a ficha pela página.
- Título da aba e prévia em aplicativos de mensagem por objeto.
- Corrigir `ContentResponseModel.fromJson` (painel, specs 014 e 015).
- Gravar ano de emissão ou outros dados no Firestore: é dado, não tela.
- Visual novo da página de "não encontrada" (spec 011).
- Guardar busca e filtros do subtema ao voltar da ficha.

## Perguntas em aberto
- Nenhuma. (Respondidas: Q-01, `nma-bh-03` no endereço, aceitando o código original; Q-04, catálogo único da spec 004.)
- Fonte do código de referência: decidido no modo autônomo: Figtree 600 com algarismos tabulares, no estilo `code` do tema, porque a 001 decidiu assim e a 006 já aplicou. A pílula do protótipo fica, só muda a fonte.
- Preservação sempre vazia no site: decidido no modo autônomo: o catálogo lê `preservationAction` do documento e o entrega junto do objeto, sem tocar em `ContentResponseModel`, porque o protótipo e o planejamento pedem os dois campos, os dados existem nos 190 objetos, e alterar modelo ou painel está fora do que esta entrega pode fazer. A correção de uma linha no leitor fica para o painel (014 e 015); depois dela, a leitura no catálogo pode sair.
- Código com grafia diferente, quando não existe: decidido no modo autônomo: o endereço é normalizado antes de consultar os dados, então `…/XYZ_1` mostra a página de "não encontrada" em `…/xyz-1`, porque normalizar no roteador evita piscar o endereço antigo e não depende do catálogo. É a única diferença em relação ao "mantendo o endereço" da 008.
- Topo: decidido no modo autônomo: bloco próprio, sem o cabeçalho de tema e subtema, porque o protótipo usa `article-head` numa coluna de 920 px, sem superfície nem medalhão. As migalhas não têm "Início", como no protótipo.
- Carregando: decidido no modo autônomo: voltar e migalhas na hora, resto em esqueleto e sem "Outros objetos", porque a 007 e a 008 mostram na hora o que vem do código, e o protótipo não tem esse estado.
- Erro: decidido no modo autônomo: texto e botão primário da spec 011 e da caixa de erro do protótipo, com voltar e migalhas mantidos, como no subtema.
- Volta de "Link copiado": decidido no modo autônomo: cerca de 2 segundos (1,8 s), a duração do `CopyButton` do Observatório. A spec já pedia a volta; o protótipo não volta.
- Falha ao copiar: decidido no modo autônomo: manter a mensagem da spec, porque o protótipo mostra "copiado" até na falha, o que seria falso.
- Endereço inválido: decidido no modo autônomo: "Endereço indisponível" como texto visível, e não dica ao passar o mouse, porque botão desativado não recebe foco e a dica ficaria invisível no teclado e no toque; "Copiar link" também desativa, porque copiaria algo que não é link. Não acontece nos dados de hoje.
- Ficha nas faixas: decidido no modo autônomo: título do grupo à esquerda em tablet e desktop e acima no celular, com 1, 2 e 3 colunas de pares por faixa, porque dá o mesmo resultado do protótipo em 390, 768 e 1280 e segue a regra de tamanhos por faixa do README. O limite do protótipo é 640 px; aqui vale 600 px.
- Grupo com poucos pares: decidido no modo autônomo: dividir a largura entre os pares, como o `auto-fit` do protótipo.
- Formato "Outro" na ficha: decidido no modo autônomo: aparece, porque o protótipo o mostra e a ficha descreve o que está gravado.
- Mês da próxima revisão: decidido no modo autônomo: abreviado ("dez 2026"), como o protótipo e "Inserido em".
- Lista de definição: decidido no modo autônomo: cada par lido junto como um só nó, porque o Flutter web não emite `dl`.
- Botões em 390: decidido no modo autônomo: manter a largura total da spec aprovada, um ajuste para toque; o protótipo só quebra linha.
- Rótulo da nota: decidido no modo autônomo: texto, não título, como no protótipo, para não criar `h2` antes da ficha.
- Laranja sobre superfície: decidido no modo autônomo: laranja forte no rótulo da nota e em "Ver todos", porque a regra de 4,5:1 vem antes do protótipo, como na 008.
- Troca de objeto: decidido no modo autônomo: página recomeça do topo, com "Copiar link" no estado inicial, como a troca de subtema da 008.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-01 e Q-04 respondidas.
- 2026-10-27: aprovada.
- 2026-11-05: revisada diante das Fases 0 e 1, da 007 e da 008 (modo autônomo, sem a pessoa). "Situação atual" reescrita (`ContentCard` removido, ficha só nesta página, `CatalogItem.route`, dados do dev). Encontrado o defeito da preservação no leitor do painel; a leitura passa pelo catálogo. Código de referência em Figtree 600 com algarismos tabulares, não monoespaçado. Exemplo 3 de "Como explorar" e cartões passam a esta página. Definidos: topo sem cabeçalho de tema, voltar e migalhas ao carregar e com erro, textos do erro, volta de "Link copiado", endereço inválido, ficha por faixa, largura de 856 px, formato "Outro", mês abreviado, leitura dos pares, laranja forte e troca de objeto. Critérios: de 11 para 17 (falha ao copiar, endereço inválido, campos vazios, Home separada da lista, teclado e leitura de tela, regressões). Segue aprovada.
