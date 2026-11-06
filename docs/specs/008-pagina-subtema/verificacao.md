# Verificação da 008. Página do subtema

- **Data:** 2026-11-05
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `git diff 85869f4..ffb4000` (commits 936f891, 953abdc e ffb4000), não só as notas da implementação. Correção no commit `fix:` 6471022.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois da correção |
| `fvm flutter test` (cópia em caminho ASCII) | 467 testes passaram antes da correção; 468 depois (1 novo) |
| `fvm dart format --output=none --set-exit-if-changed` nos 33 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII, Firestore real do dev) | concluiu, antes e depois da correção |
| `fvm flutter run -d web-server` (debug, cópia ASCII, datasource alterado só nela) | nenhuma asserção, exceção nem `overflow` no console ou no log: 390, 600, 768, 1024 e 1280; lista completa com os 6 tipos, ano, "Ver ficha" e endereço inválido; vazio, erro, nova tentativa, esqueleto, singular |
| Consulta somente leitura ao Firestore do dev (`runQuery` de `contents` em todas as coleções) | 190 objetos; contagens, assuntos e buscas comparados com a tela (abaixo). Sem acento decomposto, sem variação de caixa nos assuntos |
| `grep` nos arquivos novos por `Color(0x`, `fontSize:` numérico, `EdgeInsets`/`SizedBox` com número, `.scale`, `Duration(`, `GestureDetector`, `num_extension` | nada |
| `grep` por `ContentPaginationStore`, `ThemeSetup`, `ContentThemeDatasource`, `ContentThemeRepository`, `ContentCard`, `ContentGrid`, `SubthemeBanner`, `SubthemeError`, `SubthemeContent`, `PaginationModel` em `lib/` e `test/` | só `lib/features/theme/REFACTORING_SUMMARY.md`, que sai na 016 |
| `git diff --stat` em `lib/features/admin`, `lib/features/catalog`, `lib/core/navigation`, `lib/core/models`, `lib/core/content`, `firestore.rules`, `pubspec.yaml`, `pubspec.lock` | vazio |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Os 31 subtemas abrem direto com voltar, migalhas, `h1`, frase e medalhão; placeholder | passou | Os 31 abertos pelo endereço (carga inteira da página, build release), nos 4 temas: `h1` em caixa normal e frase lidos na árvore de semântica, contagem igual à do Firestore nos 31. Singular "1 objeto digital selecionado sobre queimadas." com datasource de 1 objeto, em 390. Imagem de Biomas retirada da cópia servida: placeholder em 1280. |
| 2 | Voltar e migalhas | passou | Clique em "← Meio Ambiente e Natureza" leva a `/natureza-meio-ambiente`. Migalhas: testes de `subtheme_page_test.dart`, com rota na árvore. |
| 3 | Sem caixa e sem acento | passou | "CERRADO" dá os 2 de "cerrado"; "desperdicio" acha "Desperdício"; "agua" e "água" iguais no Firestore (0 em Biomas, 5 em Uso da Água). Testes do store. |
| 4 | Duas palavras em qualquer campo | passou | "sustentável prática" em Sustentabilidade mostra só "Abra as portas para o sustentável" (o outro objeto com "sustentável" fica de fora), com "Mostrando 1 de 1 objeto para “sustentável prática”" e chips "Todos 1", "Site 1". Igual ao cálculo sobre o Firestore. Seis campos: testes do store. |
| 5 | Filtra a cada tecla; "Limpar" | passou | "Limpar" só com texto; em 1280 limpa, mantém o tipo e o foco volta ao campo (capturas). A cada tecla: teste do campo. |
| 6 | Chips | passou | Sustentabilidade: "Todos 10", "Site 7", "Vídeo 3". "Vídeo" filtra para 3; com "desperdicio", "Todos 1", "Vídeo 1"; sem resultado, o tipo volta a "Todos 0". Ordem com os 6 tipos na tela, com datasource alterado. |
| 7 | Assuntos frequentes | passou | Sustentabilidade e Biomas: os 8 da tela iguais à ordem calculada sobre o Firestore (frequência, empate sem acento, "Árvore" antes de "Aves"), sem o nome do subtema. Clique e Enter preenchem a busca e voltam para "Todos". Sumir sem assuntos: teste. |
| 8 | Conteúdo da linha | passou | Tela do dev: tipo · formato, título, descrição, criador, domínio sem `www.`, etiquetas. Ano e criador ausente sem buraco, com datasource alterado, em 390 e 1280. Ver ressalva do ano. |
| 9 | Regra de "Ver ficha" e do título | passou | Dev: título é texto, nenhum "Ver ficha". Com `CatalogItem.route` alterado na cópia: título com link, "Ver ficha" na tela e Enter no título abre o destino. |
| 10 | "Acessar" | passou | Clique chama `window.open` com o endereço do objeto em aba nova (`https://www.embrapa.br/exposicao-caatinga`). Com endereço inválido, na cópia: mostra o texto e nenhum "Acessar". |
| 11 | Ordem, contagem, "Carregar mais" | passou | Ordem `_01` em diante nos subtemas vistos. "Mostrando 6 de 10 objetos"; o clique mostra os 10, o botão some e o foco vai ao primeiro novo, com anel visível e à vista na tela. Subtemas com até 6 sem o botão. |
| 12 | Busca sem resultado | passou | Caixa "Nenhum objeto encontrado", "Todos 0", assuntos visíveis; "Limpar busca" restaura "Todos 10" e devolve o foco ao campo. |
| 13 | Esqueleto e erro | passou | Datasource com atraso e com falha, em 390: frase em esqueleto e 3 linhas; erro com cabeçalho e sem frase. Em 1280, "Tentar de novo" na primeira falha carrega a lista (2 consultas no console). Sem cortar a rede de verdade, o que a tarefa permite. |
| 14 | Subtema sem objetos | passou | Datasource sem Biomas, em 390 e 1280: caixa com "Voltar a Meio Ambiente e Natureza", sem frase, busca, chips e assuntos. |
| 15 | 404 | passou | `/representacoes-espaciais/movimentos-terra`, `/cultura-politica/biomas` e `/cultura-politica/qualquer-coisa` abertos pelo endereço: "Página não encontrada", com o endereço mantido. |
| 16 | Troca de subtema | passou | Biomas com busca → tema → Queimadas com busca e rolada → `history.go(-2)` → Biomas sem busca, "Todos 7", 6 objetos, no topo; `history.go(2)` → Queimadas zerada. |
| 17 | Responsivo, contraste, teclado | passou | Disposição conferida em 390, 768 e 1280, mais 600 e 1024 com o nome mais longo; `scrollWidth` = largura. Contraste calculado: secundário 6,45 (superfície) e 7,01 (página), acento/página 4,87, laranja forte/superfície 6,26. Tab do início ao fim em 1280: navbar, voltar, migalhas, campo, "Limpar", chips, 8 assuntos, "Acessar" e rodapé, com anel em cada um. Depois da correção do Enter (abaixo). |
| 18 | Semântica | passou com ressalva | Árvore: um `H1`, `H3` por objeto, campo "Buscar neste subtema", grupo "Filtrar por tipo", "Site, 7 objetos", botão "Voltar para Meio Ambiente e Natureza", "Você está em", "abre em nova aba" (teste), "Temas" ativo. Contagem anunciada: `flt-announcement-polite` recebeu "Mostrando 2 de 2 objetos para “cerrado”". Estado dos chips: ver ressalva. |
| 19 | Paginação removida, regressões | passou | `grep` acima. `/`, tema e `/sobre` em 390 e 768, sem rolagem horizontal, como antes; 1280 na implementação e aqui pelo tema. `/admin` abre o login. `/contato` segue "não encontrada", como antes (rota da 010). |

## Pontos da implementação olhados de novo
- **Temas não vistos:** Representações Espaciais e Espaços Urbanos e Rurais agora conferidos; os 31 subtemas foram abertos.
- **Regressão de `PageHeader`/`AppButton`:** ver critério 19.
- **Subtema vazio em 390 e 1280 e erro em 390:** vistos.
- **Comparação com o protótipo:** feita na implementação, com tokens tirados das abas; aqui, só as medidas e os estados que mudaram de largura. Sem diferença nova.

## Problemas encontrados e correções
- **Enter tirava o foco do campo de busca** (ajuste). Campo com `TextInputAction.search` e sem `onEditingComplete`: o Flutter solta o foco, e os Tab seguintes não mostravam anel em lugar nenhum. Reproduzido na tela e por teste novo. Corrigido na primeira tentativa, com `onEditingComplete` vazio em `AppSearchField`. Conferido: teste novo passa; na tela, Enter e depois Tab vão ao "Limpar".

## Ressalvas
- **Chips anunciados como interruptor** (detalhe). O critério pede "estado de pressionado". O `toggled` do Flutter sai como `role=switch` com `aria-checked`: o estado é lido, com outro nome. Não houve tentativa de código: a versão 3.35.5 do motor web não emite `aria-pressed` em nenhum lugar (`grep` no `flutter_web_sdk`), e o Observatório faz igual.
- **Ano de emissão** (dado). Nenhum dos 190 objetos do dev tem o campo, então o ano não aparece com os dados reais. Na tela só com datasource alterado. A produção não foi consultada; gravar o dado está fora do escopo.
- **"Ver ficha" depende da 009.** Conferido com rota alterada na cópia. A verificação da 009 precisa olhar esta lista de novo, como pede o plano.
- Fora do escopo, anteriores: os títulos do rodapé são `h2`, e não há `h2` entre o `h1` e os `h3` (decisão da spec); a navbar transborda com texto a 200%; a página de "não encontrada" segue com o visual antigo até a 011.

## Não conferido
- Painel admin: não muda e não há credenciais de teste. A tela de login abre.
- Texto a 200% no navegador: coberto por testes da linha, de 320 a 1280.
- Rede cortada de verdade: erro conferido com datasource alterado, como a tarefa permite.
- "Reduzir movimento" do esqueleto: componente anterior, sem mudança.
