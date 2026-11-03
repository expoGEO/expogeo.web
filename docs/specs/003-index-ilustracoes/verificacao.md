# Verificação da 003. `index.html`, ícones e ilustrações otimizadas

- **Data:** 2026-11-03
- **Resultado:** aprovada (status da spec: `verificada`)

Sem ressalvas de código. Fica pendente só a conferência da prévia real em aplicativo de mensagem, que depende do site publicado.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter test` | 118 testes passaram (inclui `app_images_test.dart`) |
| `fvm dart format --set-exit-if-changed` em `lib/main.dart`, `app_images.dart` e no teste | 0 arquivos alterados |
| `fvm flutter build web --release` | concluiu sem erro |
| `sed` do `deploy-dev.yml` sobre o `build/web/index.html` | `googletagmanager` some; `#carregamento`, `<title>` e `og:image` ficam |
| `python3 -I` + `sips` sobre `assets/images/` | 36 ilustrações 512 × 512; soma 13.569.956 → 1.399.974 bytes (89,7% menor); logos na mesma resolução e menores |
| `git diff --stat 9bc84a8 HEAD` em `lib/features/admin`, `lib/core/navigation`, `lib/core/models`, `pubspec.*`, `assets/images/*.png` | vazio |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Título e favicon novos na aba | passou | `document.title` = "expoGEO · Curadoria digital do saber geográfico" antes e depois do app carregar (`index.html:39` e `title` do `MaterialApp` em `lib/main.dart`); `/favicon.png` responde 200 com 2.371 bytes, 32 × 32 |
| 2 | Prévia em aplicativo de mensagem com título, descrição e imagem | passou nas tags; prévia real pendente | `og:*` (título, descrição, `og:image` absoluto 1200 × 630, `og:locale` pt_BR) e `twitter:*` lidos no navegador; `/og-image.png` responde 200 (72 KB) e está legível. A prévia real só pode ser vista com o site publicado (pendente para `dev.expogeo.com.br`) |
| 3 | Manifesto com nome, nome curto e cores; ícones "maskable" | passou | `web/manifest.json`: "expoGEO"/"expoGEO", `#C94400`, `#FFFFFF`, descrição, `lang` pt-BR, sem `orientation`; `Icon-maskable-192/512` existem, símbolo dentro da zona segura (imagem aberta) |
| 4 | Com rede lenta, símbolo em vez de tela branca; some sem piscar | passou | Servidor com atraso no `main.dart.js`: símbolo, nome e anel centralizados em 375/390, 768 e 1280; o `#carregamento` sai do DOM depois do primeiro quadro, com o app já desenhado. Com 22 s de atraso aparece o aviso de demora com "Recarregar", e o app substitui a tela quando carrega. "Reduzir movimento": a regra `@media (prefers-reduced-motion: reduce)` existe; forçando a regra a valer (`media.mediaText = 'all'`), o `animationName` do anel passa de `carregamento-giro` para `none`, o `transform` não muda em 500 ms e a transição vai a 0 s |
| 5 | Analytics entre os marcadores e removido no dev | passou | `analytics:inicio` e `analytics:fim` uma vez cada (`index.html:4` e `:19`), `#carregamento` fora do intervalo; `sed` do dev remove o `googletagmanager` |
| 6 | Ilustrações WebP ≤ 512 px, soma ≥ 80% menor | passou | 36 de 36 em 512 × 512; soma 89,7% menor. Só `movimentos_terra.webp` passou da meta de 60 KB (67.064 bytes), o que a spec trata como meta, não limite |
| 7 | Telas com WebP sem corte nem perda, inclusive Cultura e Política | passou | Rede: ilustrações chegam como `.webp` e o único PNG pedido é o `logo_simple.png`. Medalhão de Cultura e Política no menu Temas (1280) e na sanfona do celular (390), sem placeholder. Cartões de subtema e faixas sem corte em 390, 768 e 1280 |
| 8 | Seis logos de apoio em WebP, mesma resolução, menores | passou | UFU, FACED, PPGED, CAPES 512 × 216; FAPEMIG 703 × 355; CNPq 545 × 172 nos dois formatos; WebP de 57% a 68% menor. Ainda não aparecem em tela (voltam na 006) |

## Aceite da Fase 0
| Item | Situação | Evidência |
|---|---|---|
| Todas as páginas atuais abrem sem erro com navbar, rodapé e botões novos | passou | Em modo debug (`flutter run -d web-server`) a 1280: Home, os 4 temas, um subtema de cada tema, `/sobre`, `/contato` e um endereço inexistente (404 com navbar, rodapé e "Voltar ao início"), sem `EXCEPTION`, `overflow` nem erro no console. Release a 390 e 768 também sem problema visível. `/admin` abre o login (painel fora desta fase) |
| Navegação por teclado na navbar | passou | Release a 1280: Tab chega a Temas com anel de foco; Enter abre o menu com foco na primeira opção; Tab dentro do menu fecha e segue para Sobre, Contato e Observatório, todos com anel. Mesmo comportamento conferido na 002 |

## Problemas encontrados
- Comentário em inglês que só descrevia o bloco (`<!-- iOS meta tags & icons -->`) no cabeçalho reescrito do `web/index.html`. Gravidade: detalhe. **Corrigido** (removido) no commit `fix:` desta verificação.

## Observações
- No modo debug o Flutter avisa no console que substitui a `<meta name="viewport">`. A tag fica de propósito: sem ela a tela de carregamento apareceria minúscula no celular antes do Flutter assumir. Sem efeito para quem usa o site.
- A conferência do menu Temas pelo teclado depende de esperar a animação de abertura: uma captura logo após o Enter mostra a seta virada sem o menu.

## Não conferido
- **Prévia real em aplicativo de mensagem:** só com o site publicado. Pendente para o dev (`dev.expogeo.com.br`) depois do merge.
- **"Reduzir movimento" pelo sistema:** o navegador embutido não emula `prefers-reduced-motion`; a regra foi conferida pelo CSS e forçada por script (ver CA4). O ramo do script que remove a tela sem esmaecer não foi exercitado.
- **Painel admin na tela:** sem credenciais de teste; o painel não usa `AppImages` e não foi alterado.

## Fora do escopo (registrado)
- `/representacoes-espaciais/movimentos-terra` mostra o conteúdo de História da Cartografia porque Movimentos da Terra não está na lista de subtemas do tema. Defeito anterior à fase, previsto para a 008.

## Decisões tomadas sem a pessoa (modo autônomo)
- Status `verificada`: a prévia real em aplicativo de mensagem fica como pendência de conferência após o deploy, não como ressalva (não é defeito de código).
- O aviso de `viewport` no console de debug fica como está (ver Observações).
