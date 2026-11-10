# Verificação da 012. Login do painel

- **Data:** 2026-11-08
- **Resultado:** aprovada (status da spec: `verificada`)
- **Escopo revisado:** código de `6db7ced` a `396759a` (`git diff`), não só as notas da implementação, com atenção às peças compartilhadas que mudaram (`AppButton`, `FormTextField`) e às telas públicas que as usam. Nenhuma correção foi necessária.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter test` (cópia em caminho ASCII) | 755 testes passaram |
| `fvm dart format --set-exit-if-changed` nos 24 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII) | concluiu; também com `--dart-define=APP_ENV=prod` |
| `fvm flutter run -d web-server` (debug, cópia ASCII) | login em 390 e 1280×600 com aviso de credenciais e e-mail de 76 caracteres; `/contato` em 390 com mensagem de várias linhas: nenhuma asserção, exceção nem `overflow` no registro |
| `git diff --stat 6db7ced..HEAD` em `lib/features/admin/panel`, `lib/core/components/field`, `lib/core/utils/validators`, `pubspec.yaml`, `pubspec.lock`, `firestore.rules` | sem alterações |

## Critérios de aceite
Build release servido localmente e aberto no navegador embutido em 390, 768 e 1280 (e 1280×600), com a semântica ligada para a árvore de leitura. Erros e sessão conferidos com um datasource de autenticação simulado, só na cópia ASCII (apagado no fim, nunca no worktree): nenhuma senha foi enviada ao Firebase. Protótipo lido da aba "Login".

| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Duas colunas com os textos | passou | a 1280: coluna escura com círculos, marca, "PAINEL DA CURADORIA", "Cuide da curadoria da expoGEO.", texto de apoio e "Sem acesso?…"; cartão "Entrar" com o texto, campos, "Entrar" e "Voltar ao site". A 390 e 768, faixa no topo só com marca, rótulo e título |
| 2 | Validação sem Firebase | passou | envio vazio mostra "Escreva o e-mail, como nome@exemplo.com." e "Escreva a senha." com o cursor no e-mail; com a simulação, "  teste@exemplo.com  " e a senha "errada" chegaram ao datasource como `teste@exemplo.com` (aparado), sem regra de senha |
| 3 | Avisos de erro | passou | simulação: credencial inválida → "E-mail ou senha não conferem. Confira e tente de novo."; muitas tentativas → "Muitas tentativas seguidas…"; campos mantidos. Desativado e conexão cobertos pelos testes de `loginErrorMessage` e da página (cada falha com sua mensagem) |
| 4 | "Entrando…" sem repetição | passou | Enter duas vezes seguidas: botão "Entrando…" com indicador e uma só chamada ao datasource (contador no console) |
| 5 | Painel e recarregar com sessão | passou | senha certa (simulada) leva a `/admin/painel`; build com sessão recuperada depois de 500 ms abre `/admin` direto no painel; "Sair" nos dois casos volta ao login, sem aviso e com a senha vazia; `/admin/painel` sem sessão volta a `/admin` |
| 6 | "Voltar ao site" e marca | passou | os dois cliques levam a `/` com a Home |
| 7 | Mostrar/esconder senha | passou | nó `role=switch`, `aria-label` "Mostrar senha", `aria-checked=false`; pelo Tab recebe o anel e mostra a dica; teste do botão cobre Enter, Espaço e a troca de nome e estado |
| 8 | Responsivo, contraste e foco | passou | `scrollWidth` igual à janela em 390; nada cortado em 1280×600 (a página rola). Contraste: "Sem acesso?" 6,3:1 e texto de apoio 11,7:1 sobre o fundo escuro, rótulo laranja 8,4:1, texto secundário 6,5:1, aviso 5,6:1, "Voltar ao site" 6,8:1, botão 4,87:1. Tab: marca, e-mail, senha, mostrar senha, Entrar, Voltar ao site, com anel visível (também coberto por teste) |
| 9 | Faixa de ambiente | passou | "Ambiente de testes" no build padrão; ausente no build com `APP_ENV=prod` |
| 10 | Tokens e não regressão | passou | sem `Color(`, `fontSize:` ou medida solta fora do tema, sem `num_extension`, `GestureDetector` nem menção a spec em comentário; ver "Regressões" |

## Regressões
`AppButton` e `FormTextField` mudaram. Home (botões do hero), `/sobre`, `/contato` e 404 em 1280 no build release sem diferença visível. `/contato`: envio vazio mostra os quatro erros como antes; em debug a 390, a mensagem com várias linhas quebra dentro da caixa, sem `overflow`. Sem `isLoading`, o botão calcula foco e semântica como antes (`focusable` igual a `!inactive`).

## Problemas encontrados
Nenhum.

Observações, sem correção:
- O protótipo pinta "Voltar ao site" em cinza; a tela usa o laranja dos clicáveis (regra do `docs/specs/README.md`), como decidido no plano.
- Com a semântica ligada, o `document.activeElement` do navegador não acompanha o foco do Flutter a cada Tab (efeito do motor web); a ordem foi conferida pelo anel na tela e pelo teste.

## Não conferido
- Login real no Firebase: sem credenciais de teste; o caminho foi conferido com o datasource simulado.
- Firebase bloqueado no navegador: o limite de 3 s de `restoredUser` está coberto por teste do repositório.
- Texto a 200% e leitores de tela reais (NVDA, VoiceOver): conferida só a árvore de semântica do navegador.
