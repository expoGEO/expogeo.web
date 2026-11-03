# Verificação da 002. Botões, faixa do Observatório, navbar e rodapé

- **Data:** 2026-10-29
- **Resultado:** aprovada

Verificação feita em modo autônomo, sobre os commits `cad2076`, `3aed45b` e `7357459`, com leitura do código (não só do `tasks.md`). `analyze`, `test` e os builds rodaram numa cópia do projeto em caminho ASCII (o "ó" do caminho original quebra o `analyze`). Telas abertas no navegador embutido, no build de release servido com fallback para `index.html` e uma vez em debug.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` | No issues found! (antes e depois da correção) |
| `fvm flutter test` | 23 testes passando antes; 27 depois (4 novos de hover dos botões) |
| `fvm dart format --output=none --set-exit-if-changed` nos 32 `.dart` alterados desde `179f31f` | 0 arquivos alterados |
| `fvm flutter build web --release` | concluído (antes e depois da correção) |
| `fvm flutter run -d web-server` (debug) | Home, subtema, tema com menu aberto, `/contato` com painel e sanfona, em 390, 768 e 1280 px: nenhuma exceção, asserção ou `overflow` no log nem no console |
| `git diff 179f31f..HEAD --stat -- lib/features/admin` | vazio; em `app_router.dart` só a constante `about` |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Todas as páginas atuais abrem sem erro com faixa, navbar, rodapé e botões novos | passou | Release em 1280: Home, os 4 temas (`representacoes-espaciais`, `natureza-meio-ambiente`, `espacos-urbanos-rurais`, `cultura-politica`), um subtema de cada (`fuso-horario`, `biomas`, `conflitos-terra`, `povos-originarios`), `/sobre`, `/contato` e `/nao-existe`: todas com faixa, navbar, rodapé e `AppButton` ("Explorar", "Voltar para início", "Voltar ao início"). `/sobre` e `/contato` caem na 404 com navbar e rodapé, como a spec prevê |
| 2 | Três botões com hover, foco visível e desativado | passou | Tela: "Explorar" escurece no hover (`#A33600`), "Observatório" (discreto) ganha fundo acento suave, anel de foco por teclado em "Visitar", marca, Temas, Sobre, Contato, Observatório e "Voltar para início". Secundário só aparece no estado de erro do subtema; hover dele conferido por teste novo (`app_button_test.dart`, grupo "hover": primário, secundário, discreto e desativado sem mudança). Desativado: teste de opacidade, toque e semântica |
| 3 | Menu Temas com 4 temas, medalhão, "N subtemas" (7, 12, 6, 6) e link | passou | Menu aberto por clique e por hover: 7, 12, 6 e 6 subtemas; clique em "Meio Ambiente e Natureza" leva a `/natureza-meio-ambiente`. Cultura e Política mostra o placeholder do medalhão (ver Observações) |
| 4 | Menu abre e fecha por teclado; Esc devolve o foco a "Temas" | passou | Tab até Temas; seta para baixo abre e foca a primeira opção; seta anda; Esc fecha com o foco em Temas; Enter abre; Tab dentro do menu fecha e vai para Sobre. Teste de widget `navbar_dropdown_test.dart` cobre o mesmo |
| 5 | Item ativo em tema, subtema, Sobre e Contato | passou | Temas sublinhado nos 4 temas e nos 4 subtemas; Sobre em `/sobre`; Contato em `/contato` (navbar em 1280 e painel em 390) |
| 6 | Até 900 px, botão de menu abre o painel com sanfona; acima, não | passou | 768 e 390: botão de menu, painel lateral com sanfona "Temas" (aberta de início em página de tema, fechada em `/sobre`, abre ao toque com os 4 temas e contagens); Esc fecha e o foco volta ao botão (anel e dica "Abrir menu"). 1280: itens inline, sem botão de menu |
| 7 | Rodapé com quatro colunas, links, ano atual e externos em aba nova | passou | 4 colunas em 1280, 2 + 2 em 768, 1 em 390; "© 2026"; `window.open` interceptado: metadados, tese, "Visitar o site", Instagram, Facebook, YouTube, "Observatório" da navbar e "Visitar" da faixa com alvo de nova aba e os endereços de `AppLinks` (iguais aos do rodapé antigo e aos do Observatório); e-mail com `mailto:expogeoufu@gmail.com` e alvo `_self` |
| 8 | Sem rolagem horizontal nem `overflow` em 390/768/1280 | passou | `scrollWidth` igual à largura da janela em 390 e 768; nenhum `overflow` nas telas nem no console do debug |
| 9 | Contraste ≥ 4,5:1 em faixa, navbar e rodapé | passou | Tabela da tarefa G2 (WCAG 2.1), conferida contra os tokens: menor valor 4,87 (acento sobre branco) |
| 10 | Nenhum valor solto de cor, fonte ou espaçamento no código novo | passou | `grep` no diff: sem `Color(0x` fora do tema, sem `fontSize:` com número, `EdgeInsets`/`SizedBox` só com tokens. Ficam alturas de linha (`height: 1.x`) nos estilos, como no Observatório. O cartão da 404 mantém os valores antigos (ver Observações) |

## Problemas encontrados
- Comentários que só descreviam o código (`AppBrand`, `AppMedallion`, `NavbarSliver`, `NavbarMobileMenu`, `ObservatoryStrip`, `SiteScaffold` e o vão do `NavbarDropdown`), contra as regras de comentário. Detalhe. **Corrigido** (`383ef40`); `analyze`, `test` e build limpos depois.
- O hover do botão secundário não tinha como ser visto na tela (só aparece no estado de erro). Ajuste. **Resolvido** com teste de widget do hover dos três botões (`383ef40`).

## Observações (sem correção)
- A ilustração de Cultura e Política aparece como placeholder no menu e no painel porque o arquivo é `cultura_política.png` (com acento) e não bate com `AppImages`. Previsto para a 003; o placeholder é o estado "Imagem com falha" da spec. O console mostra um 404 desse arquivo.
- O cartão da 404 mantém margens, raios e cores soltos do código anterior (só foi reindentado ao entrar no `SiteScaffold`); o conteúdo das páginas está fora do escopo.
- Em 375 px a faixa encurta o texto com reticências; em 390 cabe inteiro.
- O Shift+Tab do navegador embutido chega ao Flutter sem o evento da tecla Shift e anda para a frente. Com eventos de teclado completos (Shift pressionado antes do Tab, via script) o foco volta normalmente; não é defeito do app.
- O clique do mouse no "Temas" também focou a primeira opção com anel em uma das tentativas (o modo de destaque do Flutter ainda estava em teclado); mesmo comportamento do Observatório.

## Não conferido
- Painel admin logado: sem credenciais de teste. Garantia estrutural: nenhum arquivo de `lib/features/admin/` mudou.
- Abertura real das abas externas e do cliente de e-mail: conferidos o endereço e o alvo passados ao `window.open`, sem abrir os sites.
