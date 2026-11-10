# Verificação da 013. Painel: estrutura, menu e consulta de temas e subtemas

- **Data:** 2026-11-09
- **Resultado:** aprovada (status da spec: `verificada`)
- **Escopo revisado:** código de `aa9fa0d` a `5d28a9b` (`git diff`), não só as notas da implementação, com atenção às peças compartilhadas que mudaram (`AppBrand`, `AppButton.danger`, `AppIconButton`, `Messenger`, `CatalogStore.refresh()`) e às telas públicas que as usam. Um problema encontrado e corrigido (`3307acd`).
- **Como as telas com sessão foram vistas:** na cópia em caminho ASCII, com sessão, conteúdo e catálogo simulados (gravações só em memória, catálogo do ambiente de testes só lido, uma variante em que "Sair" falha e outra em que as contagens falham). Os arquivos simulados foram apagados da cópia ao fim e nunca entraram no repositório.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | No issues found |
| `fvm flutter test` (cópia ASCII) | 817 testes passaram (816 + 1 novo da correção) |
| `fvm dart format --set-exit-if-changed` nos 40 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII) | concluiu (antes e depois da correção) |
| `fvm flutter run -d web-server` (debug, cópia ASCII) | "Temas e subtemas" em 390, gaveta e escolha de tema, 768, 1280 com "Sair" falhando e diálogo de exclusão: nenhuma asserção, exceção nem `overflow` no registro nem no console |
| `git diff --stat aa9fa0d..HEAD` em `lib/core/models`, `lib/features/admin/panel/infra`, `lib/features/admin/login`, `firestore.rules`, `pubspec.yaml`, `pubspec.lock` | sem alterações |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | `/admin/painel` → `/admin/painel/objetos` com moldura e área de objetos de hoje | passou | Navegador em 1280: endereço trocado, barra, menu fixo de 248 px, cabeçalho "Objetos digitais" e seletor, "Novo Conteúdo" e tabela dentro da moldura |
| 2 | Contagens do menu iguais às do site; esqueleto; sem números no erro | passou | Menu com 190 / 35 / 74 / 42 / 39 e 31, iguais aos números da Home; com as contagens falhando, itens sem números; esqueleto coberto por `panel_sidebar_test.dart` |
| 3 | "Temas e subtemas" com 4 blocos, medalhão, caminho, "N objetos"; "Ver objetos"; "Tentar de novo" | passou | 4 blocos, 7 e 12 subtemas visíveis; erro mostra "Não conseguimos carregar as contagens." e "Tentar de novo", que pôs esqueletos no lugar dos selos e recarregou; "Ver objetos" coberto por `panel_themes_view_test.dart` |
| 4 | `?tema=` no menu, recarga mantém vista, valores desconhecidos ignorados, sem sessão volta ao login | passou | Menu → `?tema=natureza-meio-ambiente` e `?tema=cultura-politica`; recarga de `?tema=…&subtema=biomas` e de `/temas` mantém vista e destaque; `?tema=xyz&subtema=biomas` mostra "Objetos digitais" sem escolha; sem sessão `/admin/painel/temas` → `/admin`; `/admin/painel/xyz` mostra o 404 |
| 5 | "Ver site" em aba nova; "Sair"; falha ao sair mostra o aviso | passou | Falha simulada em 390 (pela gaveta) e 1280: aviso "Não deu para sair. Tente de novo." no rodapé; "Ver site" em aba nova coberto por `panel_top_bar_test.dart`; saída com sucesso por `panel_shell_test.dart` |
| 6 | Contagens se atualizam depois de criar, editar ou excluir | passou | Pelo formulário antigo, na moldura, em Biomas: criar levou o menu de 190/74 a 191/75 e a linha nova apareceu; editar trocou o título e manteve 191; excluir pelo diálogo voltou a 190/74, sem recarregar a página |
| 7 | Gaveta até 900 px: abre pelo botão, fecha ao escolher, fora e Esc, foco no lugar certo | passou | 390 e 768: abre pelo botão com foco no item atual; escolher um tema fecha e navega; Esc fecha e o foco volta ao botão, com anel e dica; toque fora por `panel_shell_test.dart` |
| 8 | Dica no hover e no foco; aviso curto anunciado; diálogo com foco em "Cancelar", Esc e devolução do foco | passou | Dica "Editar a ficha deste objeto" no hover; "Ver os objetos deste subtema" no foco por Tab; diálogo abre com anel em "Cancelar", Tab vai a "Deletar", Esc fecha; anúncio e devolução do foco por `messenger_test.dart` e `confirm_dialog_test.dart` |
| 9 | 390, 768, 1280 sem rolagem horizontal nem `overflow` (e-mail longo); contraste ≥ 4,5:1; teclado | passou | `scrollWidth` igual à janela em 390 e 768; em 1280 o e-mail de 83 caracteres cabe na barra sem corte nem faixa de `overflow`; contraste medido nos pixels da tela (ver abaixo); Tab percorre as linhas de subtema com anel visível |
| 10 | Tokens, sem `num_extension`, cor ou tamanho solto; área de objetos como antes; login e telas públicas sem mudança | passou (após correção) | `grep` no diff sem cor, fonte ou espaçamento soltos fora dos tokens; criar/editar/excluir funcionam; Home (390 e 1280), Contato, login e 404 iguais; escolher no seletor recriava o seletor e tirava o foco do teclado do campo: corrigido |

### Contraste medido na tela
Captura em 390 px (2× pixels) e cálculo WCAG entre o fundo predominante e o pixel mais contrastante do texto, além da conta pelos tokens (o valor que vale é o menor):

| Onde | Na tela | Pelos tokens |
|---|---|---|
| Contagem do item atual (`inkSecondary` sobre `accentSoft`) | 9,0:1 | 6,3:1 |
| Nome do item atual (`accentStrong` sobre `accentSoft`) | 9,6:1 | 6,1:1 |
| Contagens e "CURADORIA" do menu sobre `page` | 9,9 a 10,7:1 | 7,0:1 |
| Resumo e "7 subtemas · 35 objetos" sobre `surface` | 9,2 a 10,6:1 | 6,5:1 |
| Caminho do subtema sobre `page` | 11,2:1 | 7,0:1 |
| Selo "N objetos" e ícone "Ver objetos" na linha em hover | 8,4 a 9,8:1 | 6,8:1 |
| Aviso de erro (branco sobre `error`) | não medido na tela (o aviso some antes da captura) | 6,5:1 |
| "Ver site" (`accent` sobre `page`) | — | 4,9:1 |

## Problemas encontrados
- **Seletor recriado a cada escolha feita nele** (`legacy_objects_area.dart`): a chave do `ThemeSubthemeSelector` era o par tema/subtema, então escolher pelo próprio seletor recriava o widget e o foco do teclado saía do campo usado (regressão de teclado na área de objetos). Gravidade: ajuste. **Corrigido** em `3307acd` (1ª tentativa): o seletor só é recriado quando a escolha muda por fora (endereço ou menu). Conferido com teste novo em `panel_objects_view_test.dart` (falha no código anterior, passa no novo) e no navegador: escolher tema e subtema no seletor e depois um tema pelo menu atualiza tudo.

## Observações fora do escopo da 013
- O formulário antigo grava o tipo e o formato pelo rótulo (`'Site'`, `'HTML'`), mas a leitura compara pelo nome (`site`, `html`): um objeto criado pelo formulário volta como "Outro". Vem de `content_model.dart` (modelos não mudam nesta entrega); fica para a 015, junto da chave de preservação, que também volta vazia ao editar.
- A tabela antiga usa texto cinza claro (`gray400`) e rolagem horizontal em 390; é a área de hoje, substituída pela 014.

## Não conferido
- Leitor de tela real (VoiceOver/NVDA): nomes, estados e anúncios conferidos só pela árvore de semântica nos testes.
- "Ver site" abrindo de fato uma aba nova no navegador: só pelo teste com o `url_launcher` falso.
