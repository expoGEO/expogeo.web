# 008. Página do subtema: busca, filtros e lista de objetos

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 2, entrega 2.2 (tela T-03)
- **Protótipo:** aba "Subtema" e, para os estados, aba "Estados" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Dentro de um subtema, a pessoa encontra rápido o objeto que procura (por palavra, por tipo ou por assunto), entende o que é cada um antes de abrir e acessa o recurso na fonte original.

## Situação atual
- `features/theme/pages/subtheme_page.dart`, já dentro do `SiteScaffold` novo, com fundo cinza, `SubthemeBanner` (cartão com "Voltar para {tema}", ilustração recortada e título em caixa alta) e `ContentGrid` de `ContentCard`. O cartão embute a ficha inteira e tem "Abrir conteúdo".
- Paginação por cursor no Firestore com "Página X de Y" e anterior/próxima (`ContentPaginationStore`, `ContentThemeRepository`, `content_theme_datasource.dart`, 20 por página). Só esta tela usa essa pilha. Erro em `SubthemeError`; `SubthemeContent` já não é usado por ninguém.
- Sem busca nem filtros.
- Endereço de subtema que não está na lista do tema cai no **primeiro subtema** do tema. É a causa do defeito registrado no histórico: `/representacoes-espaciais/movimentos-terra` mostra História da Cartografia, e `/cultura-politica/biomas` mostra o primeiro subtema de Cultura e Política em vez de uma página de "não encontrada".
- Já existem e são reaproveitados: catálogo único (`CatalogStore`, spec 004), carregado sob demanda desde a 007; `PageHeader` com `trailing` e `details` (spec 007); `AppMedallion`; `AppSkeleton`; `AppButton` (com "abre em nova aba" na leitura de tela); `typeLine` e `cardIcon` (spec 005). Do Observatório vêm o campo de busca, o chip de filtro, a caixa de estado e a comparação sem acento.
- Dados do dev conferidos em 2026-11-04 (190 objetos, 31 subtemas): de 4 a 10 objetos por subtema; todos com exatamente 3 assuntos, criador, colaborador e endereço `http`; tipos presentes: Site 165, Vídeo 22, Documento 2, Aplicativo 1; **nenhum objeto tem ano de emissão gravado** (o campo existe no modelo e nos arquivos de seed).

## Comportamento

### Cabeçalho
- Mesmo cabeçalho da página do tema: fundo de superfície com linha inferior, medalhão do subtema à direita (180 px no desktop). Fundo da página passa ao padrão (sem o cinza).
- Faixa superior com o botão discreto "← {Tema}" (volta ao tema) à esquerda e as migalhas "Início › {Tema} › {Subtema}" à direita. Quando não couberem lado a lado, as migalhas descem para a linha de baixo, à esquerda.
- Título do subtema (`h1`, nome em caixa normal, o do `SubthemeEnum`, como na 007) e a frase "N objetos digitais selecionados sobre {subtema em minúsculas}." (singular: "1 objeto digital selecionado sobre…").
- Título, migalhas, botão e medalhão aparecem na hora, porque vêm do código. Só a frase depende do catálogo.

### Busca
- Campo "Buscar por título, assunto ou autor" (placeholder) com ícone de lupa e botão "Limpar" quando houver texto.
- Procura em título, descrição, criador, colaborador, nota de conteúdo e assuntos. Ignora acentos e maiúsculas; várias palavras precisam aparecer todas (em qualquer campo). Só espaços contam como busca vazia.
- Filtra enquanto se digita, sem botão de enviar e sem espera.
- "Limpar" apaga o texto, mantém o tipo escolhido, volta a mostrar 6 e devolve o foco ao campo.

### Filtro por tipo
- Chips "Todos N" e um chip por tipo presente nos resultados da busca ("Site 4", "Vídeo 2"…), na ordem Site, Vídeo, Documento, Aplicativo, Imagem, Outro. Tipos sem resultado não aparecem. "Todos N" conta os resultados da busca, em qualquer tipo.
- Um tipo por vez. Escolher um tipo volta a mostrar 6. Se a busca mudar e o tipo escolhido sumir, volta para "Todos".

### Assuntos frequentes
- Linha "Assuntos frequentes" com até 8 assuntos mais comuns do campo "assuntos" dos objetos do subtema (empate em ordem alfabética), sem o assunto igual ao nome do subtema, comparando sem acento nem maiúsculas. A lista é a do subtema inteiro: não muda com a busca nem com o tipo.
- Clicar num assunto põe esse texto na busca, volta o tipo para "Todos" e volta a mostrar 6.
- Some quando o subtema não tem assuntos.

### Contagem e lista
- Linha "Mostrando 6 de 9 objetos" (singular "Mostrando 1 de 1 objeto"), com ' para “{busca}”' quando houver busca, anunciada a leitores de tela quando muda. Não aparece quando nada foi encontrado.
- Cada objeto em linha:
  - ícone do tipo e rótulo "TIPO · FORMATO" em maiúsculas (mesma regra de omissão do cartão de objeto, spec 005);
  - título (`h3`), descrição;
  - criador, ano de emissão (quando houver) e o domínio do endereço, sem `www.` (ex.: `ibge.gov.br`);
  - até 4 assuntos em etiquetas (só leitura, não clicáveis);
  - ações "Ver ficha" (discreto, leva à página do objeto) e "Acessar ↗" (secundário, abre o recurso em aba nova).
- A linha ganha fundo de superfície ao passar o mouse. Nesse fundo, o rótulo e o título com link usam o laranja forte, porque o acento normal sobre a superfície dá 4,48:1. O título sem link segue na cor do texto, porque laranja é a cor do que é clicável. O título com link fica sublinhado no hover.
- **Destino da ficha até a spec 009:** o título e "Ver ficha" levam a `CatalogItem.route`, o único lugar que sabe o endereço do objeto. Hoje esse endereço é o próprio subtema, então um link ali não levaria a lugar nenhum. Enquanto o destino for a página em que a pessoa já está, o título aparece como texto e "Ver ficha" não aparece. Quando a 009 trocar `CatalogItem.route`, os dois passam a aparecer sem mudança nesta tela. "Acessar" funciona desde já.
- Ordem: pelo código de referência (`_01`, `_02`…), que é a ordem da curadoria.
- **"Carregar mais"** mostra mais 6 por vez; some quando não há mais. Busca, tipo ou assunto novos voltam a mostrar 6. Subtema com até 6 objetos nunca mostra o botão.
- Sem anterior/próxima nem número de página.

## Estados
- **Carregando:** cabeçalho sem a frase (esqueleto curto no lugar dela) e 3 esqueletos de linha de objeto (ícone, rótulo, título e descrição), como na aba "Estados". Busca, chips e assuntos não aparecem até os dados chegarem.
- **Busca sem resultado:** caixa "Nenhum objeto encontrado" — "Nada em {Subtema} combina com “{busca}”. Tente outra palavra ou veja todos os tipos." — com "Limpar busca" (limpa busca e tipo, volta a mostrar 6 e devolve o foco ao campo). Busca, chips ("Todos 0") e assuntos continuam visíveis.
- **Subtema sem objetos:** caixa "Nenhum objeto neste subtema ainda" com link "Voltar a {Tema}"; a frase do cabeçalho, busca, chips e assuntos não aparecem.
- **Erro:** caixa de erro "Não conseguimos carregar os objetos" — "Confira sua conexão com a internet e tente de novo." — com "Tentar de novo". O cabeçalho continua, sem a frase; busca, chips e assuntos não aparecem. "Tentar de novo" volta ao esqueleto e repete a consulta.
- **Sem imagem:** placeholder no medalhão do cabeçalho.
- **Subtema fora da lista do tema**, inexistente (`/cultura-politica/qualquer-coisa`) ou de outro tema (`/cultura-politica/biomas`): página de "não encontrada", mantendo o endereço (visual novo na spec 011). O mesmo vale para `/representacoes-espaciais/movimentos-terra`.
- **Troca de subtema** com a página aberta (voltar e avançar do navegador): a página recomeça do topo, sem busca, com "Todos" e 6 objetos.
- **Casos de borda:** objeto sem ano ou sem criador não deixa buraco na linha de dados; endereço que não é `http`/`https` válido mostra o texto do endereço no lugar do domínio e não mostra "Acessar"; endereço vazio não mostra domínio nem "Acessar"; descrição muito longa não é cortada na lista (só no cartão); objeto sem assuntos não mostra etiquetas; assunto vazio ou só com espaços é ignorado; domínio longo (até 44 caracteres nos dados) quebra sem rolagem horizontal.

## Responsivo
Faixas do projeto: celular < 600, tablet de 600 a 1023, desktop ≥ 1024.
- **390:** medalhão (96 px) acima do botão e das migalhas; busca em largura total, chips abaixo com quebra de linha; ícone de 36 px; ações da linha abaixo do texto, na coluna do texto.
- **768:** como o celular, com busca até 520 px.
- **1280:** medalhão de 180 px; busca (até 520 px) e chips na mesma faixa, chips à direita; ícone de 44 px; ações à direita da linha, centralizadas na altura.

## Acessibilidade
- Campo de busca com rótulo "Buscar neste subtema".
- Chips como grupo "Filtrar por tipo", com estado de pressionado e a contagem na leitura ("Site, 4 objetos").
- Contagem em região que anuncia mudanças.
- Ao clicar em "Carregar mais", o foco vai para o primeiro objeto novo (o título com link; enquanto ele for texto, o "Acessar" desse objeto).
- "Acessar" anuncia que abre em aba nova. O botão "← {Tema}" anuncia "Voltar para {Tema}".
- `h1` com o nome do subtema; título de cada objeto como `h3`, igual ao protótipo.
- Migalhas com nome "Você está em". Medalhão decorativo. Item "Temas" ativo na navbar.
- Ícone do tipo decorativo (o tipo já está no rótulo). Texto secundário com contraste ≥ 4,5:1.

## Dados e regras de negócio
- Os objetos do subtema são o recorte do catálogo único da spec 004 (Q-04), filtrados no navegador, carregado também quando a pessoa entra direto pelo endereço. A paginação por cursor sai: nada mais a usa.
- Nenhum campo novo no Firestore; busca e assuntos usam campos existentes (`contentInfo.subjects` etc.). Nenhum modelo muda.
- Rotas `/:tema/:subtema` continuam iguais. Nenhuma rota é criada, nem a do objeto.
- Os subtemas válidos são os listados no `ThemeDataModel`. Movimentos da Terra continua no enum e fora do site (planejamento, seção 6; specs 004 e 007).
- Busca, tipo e quantidade mostrada valem só enquanto a página está aberta.

## Critérios de aceite
- [x] Os 31 subtemas abrem direto pelo endereço com botão de voltar, migalhas, `h1` em caixa normal, frase com a contagem correta (singular e plural) e medalhão; ilustração ausente mostra o placeholder.
- [x] "← {Tema}" e a migalha do tema levam ao tema; "Início" leva à Home.
- [x] Buscar "cartografia" e "CARTOGRAFIA" dá o mesmo resultado; buscar com e sem acento ("agua"/"água") também.
- [x] Busca com duas palavras só mostra objetos que tenham as duas, em qualquer campo (título, descrição, criador, colaborador, nota, assuntos).
- [x] A lista filtra a cada tecla; "Limpar" aparece só com texto, limpa a busca, mantém o tipo e devolve o foco ao campo.
- [x] Os chips mostram só os tipos presentes, na ordem da spec, com contagem certa, filtram a lista e voltam para "Todos" quando o tipo escolhido some.
- [x] "Assuntos frequentes" mostra até 8 assuntos, do mais comum ao menos comum com empate alfabético, sem o nome do subtema; clicar preenche a busca e volta para "Todos"; some sem assuntos.
- [x] A linha de cada objeto mostra tipo · formato, título, descrição, criador, ano (quando houver), domínio e até 4 assuntos, e sem ano não deixa buraco.
- [x] Com destino igual ao subtema, o título é texto e "Ver ficha" não aparece; com `CatalogItem.route` apontando para outro endereço, o título é link, "Ver ficha" aparece e ambos levam a ele.
- [x] "Acessar" abre o endereço do objeto em aba nova e não aparece com endereço inválido.
- [x] A lista segue a ordem do código; "Mostrando X de Y" está certo; "Carregar mais" acrescenta 6 por vez, leva o foco ao primeiro novo e some no fim; mudar busca, tipo ou assunto volta a 6.
- [x] Busca sem resultado mostra o estado vazio e "Limpar busca" restaura a lista com "Todos".
- [x] Esqueleto ao carregar; erro com "Tentar de novo" que funciona (testar offline e voltar); o cabeçalho continua nos dois casos.
- [x] Subtema sem objetos mostra a caixa com "Voltar a {Tema}", sem busca, chips, assuntos e frase.
- [x] Subtema inexistente, de outro tema e `/representacoes-espaciais/movimentos-terra` mostram a página de "não encontrada", e não o conteúdo de outro subtema.
- [x] Trocar de subtema pelo voltar e avançar do navegador recomeça sem busca, com "Todos", 6 objetos e no topo.
- [x] Em 390, 768 e 1280 px, o layout segue a seção Responsivo, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; tudo alcançável por teclado com foco visível.
- [x] Um único `h1`, títulos dos objetos como `h3`, rótulo do campo, grupo de chips com estado de pressionado, contagem em região anunciada, "Voltar para {Tema}", "abre em nova aba" e item "Temas" ativo na navbar.
- [x] Não há mais anterior/próxima nem número de página, e nada no código usa a paginação por cursor; `/`, tema e `/sobre` seguem como antes.

## Fora do escopo
- Página do objeto e sua rota (spec 009).
- Busca em todos os subtemas ou no site inteiro.
- Guardar busca e filtros no endereço (pode virar melhoria futura).
- Visual novo da página de "não encontrada" (spec 011).
- Gravar o ano de emissão no Firestore do dev: é dado, não tela.
- Remover pacotes sem uso e o `REFACTORING_SUMMARY.md` (spec 016).

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)
- `/representacoes-espaciais/movimentos-terra`: decidido no modo autônomo: mostrar a página de "não encontrada", sem incluir Movimentos da Terra no `ThemeDataModel`, porque o subtema não está no protótipo, não tem nenhum objeto no dev nem no seed, nada no site leva a ele, e incluí-lo mudaria modelo e contagens já conferidas (35 objetos, 7 subtemas). O defeito vem do `orElse` que cai no primeiro subtema, e sai com ele.
- Destino de "Ver ficha" até a 009: decidido no modo autônomo: o título vira texto e "Ver ficha" fica oculto enquanto `CatalogItem.route` for a própria página, porque um link que não muda nada parece quebrado, uma rota nova é da 009 (fora do escopo) e abrir o recurso duplicaria "Acessar". Com a 009 os dois aparecem sem tocar nesta tela, e a condição pode sair ali. A branch da fase só vai para o PR com a 009 pronta.
- Frase do cabeçalho enquanto carrega, com erro e com 0 objetos: decidido no modo autônomo: esqueleto ao carregar e omitida nos outros dois, porque a 007 já trata o cabeçalho assim (o que vem do código aparece na hora, a contagem some na falha) e, com 0, a caixa de estado já diz o mesmo.
- Busca, chips e assuntos ao carregar e com erro: decidido no modo autônomo: não aparecem, porque chips e assuntos dependem dos dados e a aba "Estados" do protótipo mostra só as linhas e a caixa.
- Quantidade de esqueletos: decidido no modo autônomo: 3 linhas, porque a aba "Estados" mostra uma amostra e 3 ocupam a altura típica sem pular tanto quando os 6 chegam.
- "Limpar" do campo: decidido no modo autônomo: mantém o tipo; "Limpar busca" da caixa limpa os dois, porque é o que o protótipo faz nos dois casos.
- Faixa de tablet: decidido no modo autônomo: manter "768: como o celular" para o cabeçalho e para a linha do objeto (ícone de 36 px e ações abaixo), porque a spec aprovada e a 007 já decidiram assim e o README pede tamanhos fixos por faixa. O protótipo não tem visão de tablet: pela regra dele (limite em 640 px) as ações ficariam à direita em 768.
- Faixa superior do cabeçalho: decidido no modo autônomo: botão à esquerda e migalhas à direita na mesma linha, com quebra, e medalhão acima de tudo em celular e tablet, porque é a `.top-row` do protótipo e a verificação da 007 mostrou que o `order:-2` dela não tem efeito.
- Assunto na comparação com o subtema: decidido no modo autônomo: ignorar acento e maiúsculas, porque é o que o protótipo faz (`norm`).
- Aspas: decidido no modo autônomo: usar aspas curvas “ ” nas frases com a busca, como o protótipo.
- Endereço inválido ou vazio: decidido no modo autônomo: sem "Acessar", porque seria um botão morto; não acontece nos dados de hoje.
- Altura dos chips: decidido no modo autônomo: chips de tipo com 44 px de altura mínima, como os de "Outros temas" na 007; assuntos com pílula de cerca de 32 px (pouco maior que a do protótipo), porque são muitos, a linha ficaria pesada com 44 e 32 px passam do mínimo de 24 px de alvo.
- Títulos de nível 2: decidido no modo autônomo: não acrescentar `h2` entre o `h1` e os `h3`, porque nem o protótipo nem a spec aprovada têm um título visível ali. Fica para a revisão de títulos, junto com os `h2` do rodapé.
- Ano de emissão no dev: decidido no modo autônomo: manter o ano na linha, como o protótipo e o modelo pedem, e conferir por teste, porque nenhum dos 190 objetos do dev tem o campo. Ressalva registrada no plano: a produção não foi consultada.
- Pilha da paginação: decidido no modo autônomo: remover nesta entrega os componentes e a pilha que ficam sem uso (inclusive `ThemeSetup`), porque o item 2.2 do planejamento diz "Sai a paginação por cursor" e a 007 fez o mesmo com o que deixou sem uso. Pacotes e `REFACTORING_SUMMARY.md` seguem para a 016.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
- 2026-11-04: revisada diante das Fases 0 e 1 e da 007 (modo autônomo, sem a pessoa). "Situação atual" atualizada (scaffold, catálogo, cabeçalho, causa do defeito, dados do dev). Tratada a pendência de `/representacoes-espaciais/movimentos-terra`: 404. Definidos: destino de "Ver ficha" até a 009, faixa superior do cabeçalho, frase ao carregar e com erro, estados de busca e chips, comportamento de "Limpar", tablet, troca de subtema, aspas curvas, endereço inválido, altura dos chips e remoção da pilha de paginação. Critérios: de 13 para 19 (campos e "Limpar", "Ver ficha", "Acessar", subtema sem objetos, troca de subtema, títulos e leitura de tela, paginação removida). Segue aprovada.
- 2026-11-05: implementação (modo autônomo). Hover da linha: o laranja forte no título vale só quando ele é link, para não pintar de laranja um texto não clicável enquanto a 009 não chega. Segue implementada.
- 2026-11-05: verificada com ressalvas (ver verificacao.md). Enter no campo de busca mantém o foco. Chips saem como interruptor (`aria-checked`) porque o motor web não emite `aria-pressed`.
