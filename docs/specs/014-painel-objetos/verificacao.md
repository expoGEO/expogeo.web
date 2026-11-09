# Verificação da 014. Painel: lista de objetos, filtros e exclusão

- **Data:** 2026-11-09
- **Resultado:** aprovada (status da spec: `verificada`)
- **Escopo revisado:** código de `db79ffc` a `3487d0e` (`git diff`), não só as notas da implementação, com atenção à leitura dos dados gravados (`ContentType`/`ContentFormat.fromString`, `ContentResponseModel.fromJson`, `CatalogItem.preservation`), que vale também para o site público, e às peças compartilhadas que a lista usa (`AppIconButton`, `AppSearchField`, `Messenger`, diálogo de confirmação). Um problema encontrado e corrigido (`a98cb4d`).
- **Como as telas com sessão foram vistas:** na cópia em caminho ASCII, com sessão simulada, gravações e exclusões só em memória (com variante em que falham) e o catálogo do dev só lido, mais dois objetos simulados gravados como o formulário grava (tipo `Vídeo`/`Documento` e formato `HTML`/`PDF` pelo rótulo, com `preservationAction`). Variantes de catálogo vazio, com erro e lento. Os arquivos simulados foram apagados da cópia ao fim e nunca entraram no repositório.
- **Dados reais do dev (consulta só de leitura, REST `runQuery` em `contents`):** 190 objetos; tipo sempre pelo nome (165 `site`, 22 `video`, 2 `documento`, 1 `aplicativo`), formato pelo nome (152 `outro`, 22 `video`, 7 `texto`, 6 `imagem`, 3 `html`); todos com `preservationAction` = "Atualização do link ao longo do tempo", `updateDate` 2026-12-01; nenhum com `preservationOperation`. Nenhum objeto gravado pelo rótulo no dev hoje.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | No issues found (antes e depois da correção) |
| `fvm flutter test` (cópia ASCII) | 905 testes passaram; 906 depois da correção (1 novo, que falha sem ela) |
| `fvm dart format --set-exit-if-changed` nos 34 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII) | concluiu |
| `fvm flutter run -d web-server` (debug, cópia ASCII) | lista em 1280, menu do filtro de tema, escolha de tema, 390 e 768: nenhuma asserção, exceção nem `overflow` no registro nem no console |
| `grep -rn "content_state\|ContentState" lib test` | nada: nenhum arquivo dependia de `content_state.dart` |
| `git diff --stat db79ffc..HEAD` em `*.rules`, `firestore*`, `content_form_dialog.dart`, `lib/core/navigation` | sem alterações |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Lista completa sem escolher tema, linhas com medalhão, título, código em pílula, subtema, criador, "inserido em", selo; mais recente primeiro; resumo | passou | 1280: "190 objetos" (192 com os 2 simulados, que vêm no topo por data), menu 35/74/42/39; linhas com todos os campos; primeiro real "Quantas pessoas moram no Brasil…" (4 fev 2026) |
| 2 | Busca por código (`nma_bh`, `nma-bh-03`), título, criador, assunto, com e sem acento, várias palavras | passou | `?q=nma_bh&tipo=site` → os 4 `NMA_BH` de tipo site (o dev tem 5, um é vídeo); `?q=nma-bh-03` → 1 objeto; título/criador/assunto/acentos por `panel_objects_store_test.dart` |
| 3 | Filtros combinam com a busca; subtema desativado sem tema e limpo ao trocar; " com os filtros atuais" | passou | "4 objetos com os filtros atuais" com busca e tipo; subtema cinza e indisponível sem tema; troca de tema pelo menu do filtro limpou o subtema (endereço só `?tema=`) |
| 4 | Tema do filtro e do menu sincronizados; "Ver objetos" abre tema e subtema | passou | Escolher "Natureza e Meio Ambiente" no filtro destacou o menu e mudou o título; "Ver objetos" de Pontos Cardeais → `?tema=representacoes-espaciais&subtema=pontos-cardeais`, 5 objetos |
| 5 | Filtros no endereço, recarga mantém, desconhecidos ignorados, sem sessão volta ao login | passou | Recargas de `?q=…&tipo=site` e `?tema=…&subtema=…` mantiveram tudo; `sim` desconhecido ignorado; sem sessão `/admin/painel/objetos?tema=…` → `/admin`; histórico sem entrada por letra por `panel_objects_view_test.dart` |
| 6 | "Mostrar mais" +12 e foco no primeiro novo; "Mostrando X de Y"; filtro volta aos 12 | passou | Pelo teclado (Tab até "Mostrar mais", Enter): "Mostrando 24 de 192", foco com anel no 13.º item ("Mapa dos Conflitos"); com leitor de tela, o foco do navegador também foi para ele; volta aos 12 por teste |
| 7 | "Abrir o recurso" em aba nova; desativado com a dica quando o endereço não serve | passou | Botão ativo nos objetos com `https://`; desativado, focável e com a dica por `panel_object_row_test.dart` (nenhum objeto do dev tem endereço inválido) |
| 8 | "Novo objeto" com e sem subtema; "Editar" e título abrem o formulário com campos como gravados, inclusive a preservação | passou | Sem subtema: aviso "Escolha o tema e o subtema nos filtros…" e foco com anel em "Todos os temas"; edição do objeto simulado abriu com "Vídeo", "HTML" e "Operação simulada gravada"/"1 de Outubro de 2026" |
| 9 | Salvar atualiza lista e contagens, mantém filtros, avisos; objeto gravado pelo rótulo com o tipo certo na lista e no site | passou | "Alterações salvas" depois de salvar; falha simulada: "Não deu para salvar. Confira a conexão e tente de novo."; objetos com `Vídeo`/`Documento` aparecem como Vídeo e Documento na lista, nos chips do subtema Censo Demográfico (Site 5, Vídeo 1, Documento 1) e na página do objeto ("VÍDEO · HTML", ação de preservação lida); objeto real CP_CD_01 continua "Site", "Outro", "Atualização do link…", "dez 2026"; "Objeto cadastrado" por teste |
| 10 | Excluir com textos novos, linha some, contagens, aviso; falha mantém a linha | passou | Diálogo "Excluir “…”?" com foco em "Cancelar"; Esc fechou e devolveu o foco ao botão; confirmar: linha sumiu, 192→191 e Cultura e Política 41→40, "Objeto excluído", foco no campo de busca; falha: "Não deu para excluir. Tente de novo." e a linha ficou. Exclusão real no Firestore não feita (sem credenciais; só simulada) |
| 11 | Esqueleto, vazio com filtros, sem nenhum objeto, erro com "Tentar de novo" | passou | Catálogo lento: 4 linhas-esqueleto com filtros visíveis e sem resumo; vazio: "Nenhum objeto cadastrado ainda" com "Novo objeto"; erro: "Não conseguimos carregar os objetos" com "Tentar de novo"; vazio com filtros por teste |
| 12 | Botões de ícone com nome e título do objeto e dica; filtros com nome; resumo anunciado | passou (após correção) | Árvore de semântica: "Editar “Mapa dos Conflitos”" com a dica; filtros "Buscar objetos", "Tema", "Subtema", "Tipo" por teste; segurar o Tab deixava dicas abertas pela tela: corrigido |
| 13 | 390, 768, 1280 sem rolagem horizontal nem `overflow` (título e criador longos); contraste ≥ 4,5:1; teclado e foco visível | passou | 390: cartões com ações na faixa tracejada, filtros em 2 colunas; 768: busca e três filtros embaixo; 1280: uma faixa; título simulado longo cortado em 2 linhas com reticências; debug sem `overflow`. Contraste medido nos pixels da tela (768): subtema 8,1:1, detalhes 8,4:1, selo 7,9:1, código 19,7:1, ícone abrir 9,5:1, excluir 8,9:1 |
| 14 | Tokens; área antiga fora; "Temas e subtemas", login e telas públicas como estavam | passou | `grep` no diff sem cor, fonte, espaçamento soltos nem `num_extension` (só a cor nova `lineStrong` no tema); seletor, tabela e estados antigos apagados; "Temas e subtemas", login, Home, tema, subtema, objeto e Contato vistos em 1280 sem mudança além do tipo certo |

## Problemas encontrados
- **Dicas presas ao segurar o Tab** (`lib/core/components/button/app_icon_button.dart`), gravidade: ajuste. A dica abre depois do quadro; se o foco já tinha saído do botão, ela abria mesmo assim e ninguém a fechava, e as dicas "Excluir: pede confirmação…" ficavam empilhadas pela lista. Corrigido em `a98cb4d` (só abre se o botão ainda tem o foco), com teste que falha sem a correção; conferido de novo na tela com 51 Tabs seguidos.
- **Detalhe aceito:** na linha de detalhes, quando ela quebra, o "·" pode ficar no fim de uma linha ou no começo da seguinte, como o `flex-wrap` do protótipo. Não corrigido.

## Não conferido
- Gravação e exclusão reais no Firestore do dev e "Objeto cadastrado" na tela: não há credenciais de teste; ficaram com datasource simulado (sucesso e falha) e com os testes de `panel_objects_view_test.dart`.
- Leitor de tela real (VoiceOver): a árvore de semântica foi lida no navegador, os anúncios do resumo ficam com os testes.
