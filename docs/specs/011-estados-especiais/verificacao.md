# Verificação da 011. Estados especiais: carregando, vazio, erro e 404

- **Data:** 2026-11-08
- **Resultado:** aprovada (status da spec: `verificada`)
- **Escopo revisado:** código de `2fbebd4` a `7c79dde`, não só as notas da implementação, com atenção às telas que usam as peças alteradas (caixa de estado, navbar, esqueletos). Nenhuma correção foi necessária.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter test` (cópia em caminho ASCII) | 699 testes passaram |
| `fvm dart format --set-exit-if-changed` nos 24 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII) | concluiu |
| `fvm flutter run -d web-server` (debug, cópia ASCII) | 404, subtema e objeto em 390, 768 e 1280, e erro com nova tentativa no subtema e no objeto em 390: nenhuma asserção, exceção nem `overflow` no console |
| `grep` em `lib/` fora do painel por `CircularLoading`, `CircularProgressIndicator`, `ContentError`, `ContentEmpty`, `blueGradient` | só a própria definição e os botões antigos do painel (`PrimaryButton`/`SecondaryButton`), que nenhuma tela pública usa |
| `git diff --stat ae52bf8..HEAD` em `lib/features/admin`, `lib/core/navigation`, `lib/core/models`, `firestore.rules`, `pubspec.yaml` | sem alterações; `pubspec.lock` fora dos commits |

## Critérios de aceite
Build release servido localmente; telas no navegador embutido e em Chrome sem janela via CDP em 390, 768 e 1280 (a implementação tinha visto 375), com a semântica ligada para a árvore de leitura. Falha de rede simulada bloqueando `firestore.googleapis.com` no Chrome, sem mexer no código; latência alta para segurar o esqueleto. Protótipo lido da aba "Estados".

| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | 404 nos endereços | passou | `/nao-existe`, `/natureza-meio-ambiente/nao-existe`, `/cultura-politica/biomas`, `/natureza-meio-ambiente/biomas/nao-existe`, `/a/b/c/d` e um de 300 caracteres, nas três larguras: "404", título, texto e botão do protótipo, navbar e rodapé, endereço mantido na barra |
| 2 | "Ir para o início" | passou | clique a partir de `/natureza-meio-ambiente/nao-existe` leva a `/`, com o `h1` da Home |
| 3 | Navbar neutra na 404 | passou | nenhum `aria-current=true` na navbar larga; no menu do celular aberto em `/natureza-meio-ambiente/nao-existe`, Temas, Sobre e Contato com `current=false`. Contraprova: em `/natureza-meio-ambiente` "Temas" e o tema ficam ativos, em `/sobre` "Sobre" |
| 4 | `h1` único e "404" fora da leitura | passou | árvore com um só `h1` "Este lugar não está no mapa" e nenhum nó "404" |
| 5 | Erro com "Tentar de novo" | passou | sem rede: subtema e objeto com a caixa de erro (ícone de alerta, texto padrão, botão primário); Home com o erro compacto nos recentes. Com a rede de volta, "Tentar de novo" carrega a lista e o objeto |
| 6 | Retry sem empilhar | passou | teste do `CatalogStore` (três `ensureLoaded` depois de falha fazem uma só consulta); na tela, três cliques seguidos levam a uma lista única, mas o botão some no primeiro, então a prova é o teste |
| 7 | Cache vazio é erro | passou | sem rede de verdade (Firestore bloqueado) o subtema mostra o erro, não o vazio. Contraprova com conexão: build só na cópia que tira os objetos de Biomas depois da consulta ao servidor mostra "Nenhum objeto neste subtema ainda" com "Voltar a Meio Ambiente e Natureza" nas três larguras; a checagem olha o acervo inteiro e só vale para resposta do cache, então um subtema vazio com conexão continua vazio |
| 8 | Alerta e status | passou | caixa de erro com `role=alert`; caixa neutra (vazio, busca sem resultado, 404) com `role=status`; anúncio do título ao aparecer coberto por teste |
| 9 | Busca sem resultado | passou | "zzzqqq" em Biomas mostra "Nenhum objeto encontrado" com o texto do protótipo; "Limpar busca" volta a "Mostrando 6 de 7 objetos" |
| 10 | Esqueletos | passou | com latência alta: linhas do subtema, cartões dos recentes e ficha do objeto num nó `status` "Carregando…" cada, sem os blocos; brilho de 1,4 s e parada com "reduzir movimento" cobertos por teste do `AppSkeleton` |
| 11 | Componentes antigos e painel | passou | ver `grep` e `git diff` acima; a 404 antiga (degradê azul, medidas soltas) saiu |
| 12 | Responsivo e contraste | passou | sem rolagem horizontal nem `overflow` (release e debug) nas três larguras, inclusive com endereço de 300 caracteres. Contraste: texto secundário 7,0:1, "404" e botão 4,87:1, ícone de erro 5,6:1, título 17:1 |

## Regressões
Home, tema (Meio Ambiente e Natureza), subtema (Biomas), objeto (NMA_BIO_01), `/sobre` e `/contato` em 390, 768 e 1280, com dados reais: um `h1` em cada, sem rolagem horizontal; navbar e menu do celular com o item certo ativo. Home sem rede segue com as contagens escondidas e o erro compacto nos recentes.

## Problemas encontrados
Nenhum.

## Não conferido
- Painel admin: sem credenciais de teste; nenhum arquivo dele mudou.
- Leitores de tela reais (NVDA, VoiceOver): conferida só a árvore de semântica do navegador.
