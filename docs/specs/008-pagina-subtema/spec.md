# 008. Página do subtema: busca, filtros e lista de objetos

- **Status:** aprovada
- **Item do planejamento:** Fase 2, entrega 2.2 (tela T-03)
- **Protótipo:** aba "Subtema" e, para os estados, aba "Estados" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Dentro de um subtema, a pessoa encontra rápido o objeto que procura (por palavra, por tipo ou por assunto), entende o que é cada um antes de abrir e acessa o recurso na fonte original.

## Situação atual
- `features/theme/pages/subtheme_page.dart` com `SubthemeBanner`, "Voltar para {tema}" e `ContentGrid` de `ContentCard`. O cartão embute a ficha inteira e tem "Abrir conteúdo".
- Paginação por cursor no Firestore com "Página X de Y" e anterior/próxima (`ContentPaginationStore`, `content_theme_datasource.dart`, 20 por página).
- Sem busca nem filtros.
- Cada subtema tem de 4 a 10 objetos nos dados de seed (190 no total).

## Comportamento

### Cabeçalho
- Botão discreto "← {Tema}" (volta ao tema) e migalhas "Início › {Tema} › {Subtema}".
- Título do subtema (`h1`) e a frase "N objetos digitais selecionados sobre {subtema em minúsculas}." (singular: "1 objeto digital selecionado sobre…").
- Medalhão do subtema à direita.

### Busca
- Campo "Buscar por título, assunto ou autor" com ícone de lupa e botão "Limpar" quando houver texto.
- Procura em título, descrição, criador, colaborador, nota de conteúdo e assuntos. Ignora acentos e maiúsculas; várias palavras precisam aparecer todas (em qualquer campo).
- Filtra enquanto se digita, sem botão de enviar.

### Filtro por tipo
- Chips "Todos N" e um chip por tipo presente nos resultados da busca ("Site 4", "Vídeo 2"…), na ordem Site, Vídeo, Documento, Aplicativo, Imagem, Outro. Tipos sem resultado não aparecem.
- Um tipo por vez. Se a busca mudar e o tipo escolhido sumir, volta para "Todos".

### Assuntos frequentes
- Linha "Assuntos frequentes" com até 8 assuntos mais comuns do campo "assuntos" dos objetos do subtema (empate em ordem alfabética), sem o assunto igual ao nome do subtema.
- Clicar num assunto põe esse texto na busca e volta o tipo para "Todos".
- Some quando o subtema não tem assuntos.

### Contagem e lista
- Linha "Mostrando 6 de 9 objetos" (com ' para "{busca}"' quando houver busca), anunciada a leitores de tela quando muda.
- Cada objeto em linha:
  - ícone do tipo e rótulo "Tipo · Formato" (mesma regra de omissão do cartão de objeto, spec 005);
  - título (link para a página do objeto), descrição;
  - criador, ano de emissão (quando houver) e o domínio do endereço (ex.: `ibge.gov.br`);
  - até 4 assuntos em etiquetas;
  - ações "Ver ficha" (discreto, leva à página do objeto) e "Acessar ↗" (secundário, abre o recurso em aba nova).
- Ordem: pelo código de referência (`_01`, `_02`…), que é a ordem da curadoria.
- **"Carregar mais"** mostra mais 6 por vez; some quando não há mais. Busca, tipo ou assunto novos voltam a mostrar 6.
- Sem anterior/próxima nem número de página.

## Estados
- **Carregando:** esqueleto de linhas de objeto (ícone, rótulo, título e descrição), como na aba "Estados".
- **Busca sem resultado:** caixa "Nenhum objeto encontrado" — "Nada em {Subtema} combina com "{busca}". Tente outra palavra ou veja todos os tipos." — com "Limpar busca" (limpa busca e tipo).
- **Subtema sem objetos:** caixa "Nenhum objeto neste subtema ainda" com link "Voltar a {Tema}"; busca, chips e assuntos não aparecem.
- **Erro:** caixa "Não conseguimos carregar os objetos" — "Confira sua conexão com a internet e tente de novo." — com "Tentar de novo".
- **Sem imagem:** placeholder no medalhão do cabeçalho.
- **Subtema inexistente** ou de outro tema (`/cultura-politica/biomas`): 404 (spec 011).
- **Casos de borda:** objeto sem ano não mostra o separador vazio; endereço inválido mostra o texto do endereço no lugar do domínio; descrição muito longa não é cortada na lista (só no cartão); assunto com vírgula sobrando é ignorado.

## Responsivo
- **390:** medalhão acima do título; busca em largura total, chips abaixo com quebra de linha; ações da linha abaixo do texto.
- **768:** como o celular, com busca até 520 px.
- **1280:** busca e chips na mesma faixa; ações à direita da linha.

## Acessibilidade
- Campo de busca com rótulo "Buscar neste subtema".
- Chips como grupo "Filtrar por tipo", com estado de pressionado.
- Contagem em região que anuncia mudanças.
- Ao clicar em "Carregar mais", o foco vai para o primeiro objeto novo.
- "Acessar" anuncia que abre em aba nova.
- Título de cada objeto como `h3`.

## Dados e regras de negócio
- Os objetos do subtema são o recorte do catálogo único da spec 004 (Q-04), filtrados no navegador. A paginação por cursor sai desta tela.
- Nenhum campo novo no Firestore; busca e assuntos usam campos existentes (`contentInfo.subjects` etc.).
- Rotas `/:tema/:subtema` continuam iguais.

## Critérios de aceite
- [ ] Os subtemas abrem direto pelo endereço com cabeçalho, frase com a contagem correta e medalhão.
- [ ] "← {Tema}" e as migalhas levam ao tema e à Home.
- [ ] Buscar "cartografia" e "CARTOGRAFIA" dá o mesmo resultado; buscar com e sem acento ("agua"/"água") também.
- [ ] Busca com duas palavras só mostra objetos que tenham as duas.
- [ ] Os chips mostram só os tipos presentes, com contagem certa, e filtram a lista.
- [ ] "Assuntos frequentes" mostra até 8 assuntos sem o nome do subtema; clicar preenche a busca.
- [ ] A linha de cada objeto mostra tipo · formato, título, descrição, criador, ano, domínio, até 4 assuntos, "Ver ficha" e "Acessar".
- [ ] "Acessar" abre o endereço do objeto em aba nova.
- [ ] "Carregar mais" acrescenta 6 por vez e some no fim; mudar a busca volta a 6.
- [ ] Busca sem resultado mostra o estado vazio e "Limpar busca" restaura a lista.
- [ ] Esqueleto ao carregar e erro com "Tentar de novo" que funciona (testar offline e voltar).
- [ ] Subtema inexistente mostra o 404.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; tudo alcançável por teclado.

## Fora do escopo
- Página do objeto (spec 009).
- Busca em todos os subtemas ou no site inteiro.
- Guardar busca e filtros no endereço (pode virar melhoria futura).

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
