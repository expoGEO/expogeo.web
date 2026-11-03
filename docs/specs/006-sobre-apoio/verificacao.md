# Verificação da 006. Página Sobre, resumo na Home, apoio e bloco do Observatório

- **Data:** 2026-11-03
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `git diff ad0ecc5..HEAD` (commits dd96eef e 2bd616f), não só as notas da implementação. Correções no commit 530e2a5.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found (antes e depois das correções) |
| `fvm flutter test` (cópia em caminho ASCII) | 220 testes, todos passaram (antes e depois das correções) |
| `fvm dart format --output=none --set-exit-if-changed` nos 25 `.dart` da entrega e nos 7 das correções | 0 alterados |
| `fvm flutter build web --release` (Firestore real) | concluiu, antes e depois das correções |
| `fvm flutter run -d web-server` (debug, cópia ASCII, com `faced.webp` apagado só na cópia) na Home e em `/sobre`, 390, 768 e 1280 | nenhuma asserção, exceção nem `overflow` no log nem no console; só o 404 esperado do `faced.webp` |
| `grep` no código novo por `Color(0x`, `fontSize:` numérico, `EdgeInsets`/`SizedBox` com número, `Duration(`, `GestureDetector`, `num_extension` | nada fora dos tokens |
| `grep` por `home_banner`, `HomeBanner`, `components/logo.dart` em `lib/` e `test/` | nada |
| `git diff --stat ad0ecc5..HEAD` | sem `lib/features/admin/`, `lib/features/catalog/`, `firestore.rules`, `pubspec.*`; em `app_router.dart` só a rota `/sobre` |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Resumo, apoio e bloco do Observatório depois de "Adicionados recentemente" | passou | Na tela (390, 768, 1280): recentes (em erro com o Firestore real, ressalva da 004/005), depois rótulo "SOBRE A EXPOGEO", título, texto, "Saiba mais sobre o projeto →", os três públicos, "Realização e apoio" e o bloco. `home_page.dart`; teste `home_about_section_test.dart`. |
| 2 | Os quatro caminhos abrem `/sobre` com a barra certa | passou | Por clique, com `location.pathname` = `/sobre` em todos: "Como fazemos a curadoria" (hero, 1280), "Sobre" da navbar (1280), "Sobre" do menu do celular (390), "Sobre a expoGEO" do rodapé (1280). "Saiba mais" pelo teste com GoRouter e pela árvore de acessibilidade (link para `/sobre`). |
| 3 | `/sobre` abre direto e ao recarregar, com todo o conteúdo | passou | Endereço digitado em 1280, 768 e 390 (servidor com fallback para `index.html`): cabeçalho, migalhas, três parágrafos, explicação do código, dois botões, apoio e bloco. |
| 4 | Migalhas "Você está em", "Início" leva à Home, "Sobre" página atual | passou | Árvore de acessibilidade: grupo "Você está em" com "Início" (link) e "Sobre, página atual". Clique em "Início" → `/`. |
| 5 | Um `h1` e os `h2` no Sobre | passou | Teste `about_page_test.dart` (um nó `headingLevel: 1`, três `h2`); código em `page_header.dart`, `about_page.dart`, `partners_section.dart`, `observatory_card.dart`. |
| 6 | Metadados e tese em aba nova, anunciados | passou | Nomes "Metadados da curadoria, abre em nova aba" e "Tese de doutorado, abre em nova aba" na árvore; destinos `AppLinks.curationMetadata` e `AppLinks.thesis`, os mesmos do rodapé (teste com lançador falso). Links não seguidos de fato. |
| 7 | Logos em cinza, acendem no hover e no foco, sem movimento com "reduzir movimento", nome completo | passou | Na tela: em repouso cinza e meio transparentes; hover acende com fundo branco, borda e sombra; **Tab** (1280) acende o logo da UFU com anel laranja visível. Os seis nomes completos com "abre em nova aba" na árvore. "Reduzir movimento" e o destino de cada logo pelos testes `partners_test.dart`. |
| 8 | Logo com falha mostra a sigla, mantém o link, sem buraco | passou (após correção) | Com `faced.webp` apagado na cópia: "FACED" no lugar do logo, grade de 3 colunas sem buraco em 768 e de 2 em 390, link "Faculdade de Educação da UFU, abre em nova aba". A sigla aparecia com o cinza transparente dos logos (contraste ~2,5:1); corrigido (ver abaixo). |
| 9 | Bloco na Home e no Sobre, botão abre o Observatório em aba nova | passou | Na tela nas duas páginas; nome "Visitar o Observatório, abre em nova aba"; destino `observatoriogeohistoria.net.br` pelo teste. **Tab** no botão sobre o fundo escuro: anel `#C94400` visível, contraste 3,59:1 com `#1C1917` (≥ 3:1 para contorno). |
| 10 | "Sobre" ativo na navbar e no menu do celular em `/sobre` | passou | Na tela: sublinhado laranja na navbar (1280) e "Sobre" em laranja no menu aberto (390). |
| 11 | Código em Figtree 600, 1/3/3 colunas, 200% sem corte | passou | Na tela: 1 coluna em 390, 3 em 768 e 1280. Estilo `code` (Figtree 600 tabular) em `reference_code_example.dart`. 200%: teste em 390 com texto a 200% sem `overflow`; o zoom do navegador não é ajustável no navegador embutido. |
| 12 | `home_banner.dart` apagado e sem import | passou | Arquivo e `logo.dart` removidos em 2bd616f; `grep` vazio. |
| 13 | 390/768/1280 sem rolagem horizontal nem `overflow`; colunas; contraste | passou (após correção) | `scrollWidth` = largura nas três larguras, Home e Sobre; resumo 1/1/2 e logos 2/3/6 colunas. Contraste (WCAG 2.1): accentStrong/surface 6,26; inkSecondary/surface 6,45; accent/page 4,87 (botão primário); footerHighlight e footerText sobre o fundo escuro acima de 9:1. |

## Aceite da Fase 1
A Home (004, 005, 006) e o Sobre reproduzem o protótipo em 390, 768 e 1280 px: mesma ordem de seções, colunas e empilhamentos da spec, cores e componentes do redesign. Estados de carregando e erro nas contagens e nos recentes conferidos na 004 e na 005; com o Firestore real os recentes mostram o erro (ressalva aberta). As diferenças conhecidas são as decididas nas specs (código de referência em Figtree, não monoespaçado; logos em 2/3/6 colunas fixas). O protótipo foi lido pelo código-fonte (`read_artifact`): o link não abre no navegador embutido, que pede login.

## Regressões
Home das specs 004 e 005 (hero, temas, "Como explorar", recentes em erro), navbar, menu do celular, rodapé, página de tema (`/representacoes-espaciais`, aberta pelo rodapé) e página não encontrada abrem como antes.

## Problemas encontrados e correções
- **Bloco do Observatório mais estreito que a página no tablet** (ajuste). Empilhado, a coluna media só a largura do texto (máx. 560 px + padding) e o cartão ficava centralizado com 648 px em vez de 688 px, desalinhado das outras seções, na Home e no Sobre. O teste não pegava porque dava ao cartão largura justa. Corrigido com largura total no cartão; o teste passou a usar restrição frouxa, como no `PageContent`, e confere a largura (falhava antes, passa depois). Conferido de novo na tela em 768, 390 e 1280.
- **Sigla de logo com falha sem contraste** (ajuste). A sigla passava pelo filtro cinza com opacidade 0,55. Agora o logo que falha sai do filtro; teste novo confere que a sigla não tem `ColorFiltered` acima (falhava antes, passa depois).
- **Comentários que só repetiam o nome** (detalhe) em `ReadingColumn`, `ObservatoryCard`, `ReferenceCodeExample` e nos tokens dos círculos: removidos.

## Ressalvas e pendências
- (004/005) Regra de leitura por grupo de coleções não publicada no dev: os recentes mostram o erro com dados reais.
- Fora do escopo, anteriores à Fase 1: a navbar, de altura fixa, transborda com texto a 200%; os títulos das colunas do rodapé são `h2`, e no Sobre somam-se aos três `h2` da página.
- O logo acende pelo foco só no modo de destaque de teclado lido no momento do foco; se o modo mudar com o foco parado, o estado só se atualiza no próximo hover ou foco (detalhe, sem efeito visto na tela).

## Não conferido
- Painel admin: sem credenciais de teste.
- Destinos externos seguidos de fato (metadados, tese, Observatório, sites das instituições): conferidos pelo nome acessível e por teste, sem abrir as abas.
- Zoom de 200% do navegador: coberto por testes com texto a 200%.
- "Reduzir movimento" na tela: coberto por teste.
