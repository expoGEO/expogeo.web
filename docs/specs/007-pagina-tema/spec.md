# 007. Página do tema

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 2, entrega 2.1 (tela T-02)
- **Protótipo:** aba "Tema" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Na página de um tema, a pessoa entende do que ele trata, vê quantos objetos há em cada subtema e escolhe por onde entrar, podendo trocar de tema sem voltar à Home.

## Situação atual
- `features/theme/pages/theme_page.dart`, já dentro do `SiteScaffold` novo (faixa, navbar e rodapé da Fase 0), com fundo cinza, `ThemeBanner` (cartão com "Voltar para início", ícone, título e descrição; sem medalhão nem migalhas) e `SubthemeGrid` de `SubthemeCard` (nome em caixa alta, imagem e botão "Explorar"; 1, 2 ou 3 colunas).
- Rotas `/:tema` fixas no `AppRouter` (`/representacoes-espaciais`, `/natureza-meio-ambiente`, `/espacos-urbanos-rurais`, `/cultura-politica`). Um endereço fora das rotas já cai na página de "não encontrada" (ainda a antiga; a nova vem na 011).
- Nenhuma contagem na página, mas o catálogo único já existe (`CatalogStore`, spec 004) e dá o total por tema e por subtema. Ele só é carregado pela Home; quem abre um tema direto pelo endereço ainda não dispara a carga.
- Já existem e são reaproveitados: `AppMedallion` com placeholder e tratamento de falha (Fase 0), `PageHeader` e `Breadcrumbs` (spec 006, sem medalhão nem contagens no cabeçalho), `AppSkeleton`, cartão inteiro clicável com foco único (spec 004) e o item "Temas" ativo na navbar em toda rota de tema.
- O `title` dos subtemas no `ThemeDataModel` está em caixa alta e difere em dois nomes do protótipo ("ESTRUTURAS E FORMAS DE RELEVO", "CONFLITOS DE TERRA"); o nome em caixa normal igual ao protótipo é o do `SubthemeEnum`, já usado nos mini-chips da Home.

## Comportamento

### Cabeçalho
- Fundo de superfície com linha inferior.
- Migalhas "Início › Temas › {Tema}" ("Temas" é texto, não link; o tema atual marcado).
- Título do tema (`h1`, o mesmo nome da Home e da navbar: "Meio Ambiente e Natureza"), descrição real do tema, sem espaço sobrando no fim, e as contagens "**N** subtemas" e "**N** objetos digitais" (singular quando for 1: "1 objeto digital").
- Medalhão grande do tema à direita (180 px no desktop).
- Sai o botão "Voltar para início": as migalhas fazem esse papel.

### Subtemas
- Título com a contagem: "7 subtemas" (singular quando for 1).
- Grade de cartões de subtema. Cada cartão: medalhão do subtema, nome em **caixa normal** e "N objetos" (singular quando for 1). Cartão inteiro clicável, leva ao subtema; sai o botão "Explorar". Hover com borda no acento, sombra, nome no acento e medalhão girando levemente; com "reduzir movimento", só borda, sombra e cor mudam.
- Ordem dos subtemas: a do `ThemeDataModel`.

### Outros temas
- No fim, rótulo "Outros temas" e chips com mini-medalhão e o nome dos outros 3 temas, cada um levando ao seu tema.

## Estados
- **Carregando:** cabeçalho, cartões e "Outros temas" aparecem na hora (vêm do código); só as contagens de objetos mostram esqueleto curto, no cabeçalho e em cada cartão. A página nunca espera os dados por inteiro.
- **Erro nas contagens:** os cartões mostram só medalhão e nome (sem "N objetos") e o cabeçalho omite "N objetos digitais", mantendo "N subtemas". Sem mensagem de erro e sem bloqueio de navegação. A consulta é tentada de novo ao abrir outra página que use o catálogo.
- **Vazio:** subtema sem objetos no Firestore (não acontece nos dados de hoje) mostra "Nenhum objeto ainda" no cartão e continua clicável.
- **Sem imagem / falha:** placeholder do medalhão, inclusive nos mini-medalhões de "Outros temas".
- **Tema inexistente** (`/qualquer-coisa`): página de "não encontrada" (visual novo na spec 011).
- **Casos de borda:** nome de subtema longo ("Estruturas e Formas do Relevo") quebra centralizado, em até 2 linhas em 390 px e sem nunca ser cortado (com texto a 200%, o cartão cresce); tema com 12 subtemas não estica cartões desiguais (altura igual por linha); última linha incompleta não alarga os cartões.

## Responsivo
Faixas do projeto: celular < 600, tablet de 600 a 1023, desktop ≥ 1024.
- **390:** cabeçalho com o medalhão (96 px) acima das migalhas e do texto; grade em **2 colunas**; chips de outros temas quebram linha.
- **768:** cabeçalho em uma coluna com o medalhão (96 px) acima; grade em 3 colunas, com o nome do subtema e o respiro do cartão iguais aos do celular em toda a faixa de tablet.
- **1280:** cabeçalho em duas colunas; grade em 4 colunas (cartões de ~220 px no mínimo).

## Acessibilidade
- `h1` com o nome do tema; "N subtemas" e "Outros temas" como `h2`; nome do subtema no cartão como `h3`.
- Migalhas com nome "Você está em".
- Medalhões decorativos dentro de cartões com nome (sem texto alternativo repetido).
- Cartões e chips com foco visível e um ponto de foco cada; o `h3` continua título dentro do link do cartão.
- Enquanto a contagem carrega, a leitura de tela não anuncia número nenhum.
- Item "Temas" ativo na navbar.

## Dados e regras de negócio
- Título, descrição, subtemas e ilustrações: `ThemeDataModel`. O nome do subtema em caixa normal é o do `SubthemeEnum`. Nenhum modelo muda.
- Contagens por subtema e por tema: do catálogo único da spec 004 (Q-04), carregado também quando a pessoa entra direto pela página do tema. A soma por subtema bate com o "N objetos digitais" do cabeçalho e com o cartão do tema na Home.
- Números esperados no dev (spec 004): Representações Espaciais 35 (7 subtemas), Meio Ambiente e Natureza 74 (12), Espaços Urbanos e Rurais 42 (6), Cultura e Política 39 (6).
- Movimentos da Terra segue fora da página: não está no `ThemeDataModel`, e são os subtemas listados nele que aparecem e contam.
- Rotas atuais continuam iguais.

## Critérios de aceite
- [ ] As 4 rotas de tema abrem direto pelo endereço (e ao recarregar) com cabeçalho, migalhas, descrição real, contagens e medalhão; "Início" leva à Home e "Temas" é só texto.
- [ ] O título da grade mostra o número certo de subtemas, com singular/plural.
- [ ] Cada cartão mostra medalhão, nome em caixa normal igual ao do protótipo e "N objetos" igual ao do Firestore do dev, com singular/plural; o cartão inteiro leva ao subtema e o hover segue o Comportamento.
- [ ] A soma dos cartões é igual ao "N objetos digitais" do cabeçalho e ao cartão do tema na Home.
- [ ] "Outros temas" mostra os outros 3 temas e leva a cada um.
- [ ] Contagens com esqueleto ao carregar e somem sem quebrar a página quando a consulta falha.
- [ ] Subtema sem objetos mostra "Nenhum objeto ainda" e continua clicável.
- [ ] Ilustração ausente mostra o placeholder (medalhão do cabeçalho, dos cartões e dos chips).
- [ ] Em 390 px a grade tem 2 colunas; em 768, 3; em 1280, 4. Sem rolagem horizontal nem `overflow`.
- [ ] Navegação por teclado por migalhas, cartões e chips, com foco visível e um ponto de foco por cartão e por chip; contraste ≥ 4,5:1.
- [ ] Títulos em `h1`, `h2` e `h3` como em Acessibilidade, migalhas com nome "Você está em" e item "Temas" ativo na navbar.
- [ ] Endereço de tema inexistente mostra a página de "não encontrada".

## Fora do escopo
- Página do subtema (spec 008).
- Editar descrição ou ilustração de tema pelo painel.
- Visual novo da página de "não encontrada" e o esqueleto de medalhões da aba "Estados" (spec 011).
- Corrigir os `title` em caixa alta do `ThemeDataModel`.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)
- Nome do subtema no cartão: decidido no modo autônomo: usar o nome do `SubthemeEnum`, porque é igual ao protótipo nos 31 subtemas e já é o usado na Home (spec 004); o `title` do modelo é caixa alta e tem dois nomes diferentes.
- Nome do tema na tela: decidido no modo autônomo: usar o `title` do `ThemeModel` ("Meio Ambiente e Natureza"), porque é o do protótipo, da navbar, do rodapé e da Home (spec 005).
- Cabeçalho em 768 px: decidido no modo autônomo: manter uma coluna com medalhão de 96 px, como a spec já aprovada e a 008 ("768: como o celular"), porque o protótipo não tem visão de tablet; pela regra dele (duas colunas acima de 700 px) o medalhão ficaria ao lado.
- Esqueleto de medalhões da aba "Estados": decidido no modo autônomo: não usar aqui, porque os cartões vêm do código e a página nunca espera os dados; a frase condicional saiu para o critério poder ser conferido. O esqueleto segue na spec 011.
- "Outros temas" como `h2`: decidido no modo autônomo: manter `h2` com a aparência de rótulo do protótipo (lá é um parágrafo), porque a spec aprovada pede o título e isso ajuda a leitura de tela.
- Limite de 2 linhas no nome do subtema: decidido no modo autônomo: não cortar o nome, porque o protótipo não corta e em larguras menores que 390 px ou com texto a 200% um limite esconderia parte dele.
- Singular no cabeçalho: decidido no modo autônomo: aplicar "1 subtema" e "1 objeto digital", porque a grade e os cartões já têm singular; o protótipo só não mostra o caso.
- Medalhão e migalhas no celular: decidido na verificação: medalhão acima das migalhas, como a spec já dizia. O `.top-row{order:-2}` do protótipo só existe no cabeçalho do subtema e fica dentro de um `div`, fora da grade, então não tem efeito; a aba "Tema" nem usa essa classe. Na aba renderizada em 390 px o medalhão vem antes das migalhas.
- Nome do subtema no tablet: decidido na verificação: 16 px e respiro lateral de 10 px em toda a faixa, e não 18,4 px só acima de um limite, porque em 600 px o cartão tem 165 px e "Sustentabilidade" partia no meio, e o README pede tamanhos fixos por faixa. O protótipo não tem o caso: com `auto-fill` ele cai para 2 colunas em 600 px.
- Tamanho dos chips de "Outros temas": decidido no modo autônomo: altura mínima de 44 px em vez dos cerca de 36 px do protótipo, porque é o alvo de toque usado nos demais links do projeto.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
- 2026-11-04: revisada diante das Fases 0 e 1 (modo autônomo, sem a pessoa). "Situação atual" atualizada (scaffold, catálogo, medalhão, `PageHeader`, 404). Definidos o nome do subtema (`SubthemeEnum`) e do tema (`ThemeModel`), o singular no cabeçalho, o medalhão de 96 px em 768, o hover do protótipo, a carga do catálogo na entrada direta e os números esperados no dev. Saiu a frase condicional do esqueleto de medalhões e o limite rígido de 2 linhas. Critérios: 3 novos (subtema sem objetos, títulos e navbar, 404), total de 12. Segue aprovada.
- 2026-11-04: implementada, sem divergências da spec.
- 2026-11-04: verificada com ressalvas (ver verificacao.md). Nome do subtema e respiro do cartão menores em toda a faixa de tablet; descrição do `PageHeader` com largura máxima de leitura; ordem do medalhão no celular confirmada.
