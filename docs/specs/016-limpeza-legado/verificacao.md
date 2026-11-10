# Verificação da 016. Limpeza: código, tokens, fontes, pacotes e assets sem uso

- **Data:** 2026-11-10
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** `git diff origin/develop..HEAD` (5 commits de limpeza), com greps no código, auditoria de `assets/` e `pubspec.*`, e comparação lado a lado de dois builds release servidos: `origin/develop` (extraído com `git archive`) e o HEAD, ambos em cópias de caminho ASCII.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | No issues found |
| `fvm flutter test` (cópia ASCII) | 998 testes passando |
| `fvm dart format --output=none --set-exit-if-changed` nos `.dart` alterados | 0 alterados |
| `fvm flutter build web --release` (HEAD) | passou; `du -sk build/web` = **33992 KB** |
| `fvm flutter build web --release` (`origin/develop`) | passou; `du -sk build/web` = **49384 KB** |
| `fvm flutter run -d web-server` (debug) em `/contato`, 390 px | abre, sem erro no console |
| `pubspec.lock` da cópia após `pub get` x o da pasta original | idêntico |

## Critério do tamanho de build (CA2)
- Antes: 49384 KB. Depois: 33992 KB. Diferença de 15392 KB (cerca de 31%).
- O "antes" foi conferido de novo, de forma independente: o build de `origin/develop` deu os mesmos 49384 KB, então a base de comparação do 0.1 é a do estado original (as seis mudanças entre `develop` e o início da limpeza são só docs).
- Mesmo comando nos dois lados (`du -sk build/web`, build release limpo, sem `--no-tree-shake-icons`).

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | analyze sem avisos e testes passando | passou | tabela acima |
| 2 | build web menor que o anterior, com os dois tamanhos | passou | 49384 KB para 33992 KB |
| 3 | Sem Aleo, google_fonts, GoogleFonts, num_extension nem `.fontSize(` | passou | `grep -rniE` em `lib test pubspec.yaml assets`: vazio; `assets/fonts` só tem Bricolage, Figtree e `licenses` |
| 4 | Componentes e utilitários antigos fora | passou | grep da regex do gate A5 em `lib test`: vazio |
| 5 | Pacotes removidos fora; os que ficam, importados | passou | `pubspec.yaml` perdeu 10 dependências; `pubspec.lock` só perdeu 49 pacotes. Comparação programática das versões: nenhum bump, nenhum pacote novo; a única linha adicionada é `http` passando de direta a transitiva (Firebase) |
| 6 | Tokens antigos, `ContentType.color` e campo `color` fora | passou | grep dos nomes antigos em `lib test`: vazio; `grep -rn "color:" lib/core/content`: vazio |
| 7 | Faixa de ambiente igual, com token e estilo novos | passou, com um detalhe | Fundo `0xFFFDE047` igual ao antigo `primaryYellow`; texto de `gray900` (`18181B`) para `ink` (`1F1B18`), quase igual. A fonte da faixa passou de Aleo a Figtree (consequência de tirar a Aleo, prevista no plano). Lado a lado em 390, 768 e 1280: mesma altura, posição e cor |
| 8 | Nenhum asset sem referência | passou com ressalva | Ver "Problemas encontrados" (`movimentos_terra.webp`) |
| 9 | `pubspec.yaml` só com o que fica; `tool/images/` fora | passou | diff do pubspec só remove; `tool/images` não existe |
| 10 | Nada de regras, índices, firebase.json, `bin/`, navegação e modelos gravados | passou | `git diff origin/develop..HEAD --stat` nesses caminhos: vazio |
| 11 | Telas iguais em 390, 768 e 1280, sem rolagem horizontal nem overflow | passou, parcial | Ver abaixo |
| 12 | `REFACTORING_SUMMARY.md` apagado e README sem os termos | passou | arquivo inexistente; grep de carrossel, paginação, cursor, ContentPagination, google_fonts, aleo, convivem, tokens antigos e tool/images no README: vazio |

### Telas (CA11): build release de `origin/develop` x HEAD
- 768 px, nas duas versões: Contato, 404 e login do `/admin`: idênticos, exceto a fonte da faixa de ambiente.
- 1280 px, nas duas versões: Home, Sobre e objeto (`/natureza-meio-ambiente/biomas/nma-bio-01`): idênticos, exceto a faixa. Subtema aberto no HEAD, com dados e medalhão.
- 390 px: objeto e Contato (debug) no HEAD, `scrollWidth` = 390 = largura da janela, sem rolagem horizontal.
- Console no HEAD em release e debug: sem erro de layout nem de asset.

## Pontos em aberto da implementação
- **(a) "An unknown error occurred when fetching the script":** **já existe no build de `origin/develop`**. É o registro do service worker (`flutter_service_worker.js`) falhando no navegador embutido, que não o suporta. Mesma mensagem nos dois builds; não vem da limpeza. Nada a corrigir.
- **(b) Objeto individual e 768 px em Contato, 404 e login:** conferidos (seção Telas). Objeto aberto em 390 e 1280 px; Contato, 404 e login em 768 px.
- **(c) `AppImages.movimentosTerra`:** é a única entrada do enum sem uso (script que busca `AppImages.<nome>` em `lib` e `test`). O subtema `movimentos-terra` existe em `SubthemeEnum` mas não tem conteúdo listado, então a ilustração nunca é lida. `movimentos_terra.webp` é o único arquivo de `assets/` alcançável só por essa entrada. Os demais arquivos de `assets/` têm uso (ilustrações pelos temas e subtemas, logos pelos parceiros, ícones por nome montado no rodapé, fontes pelo pubspec). Ver ressalva.
- **(d) `pubspec.lock`:** só perdeu pacotes. Nenhuma versão mudou.
- **(e) Nada visível mudou:** confirmado nas telas acima, exceto a fonte da faixa de ambiente (Aleo para Figtree).
- **(f) Tamanho de build:** 49384 KB antes (confirmado no build de `develop`), 33992 KB depois.

## Problemas encontrados
- **Ressalva (detalhe):** `AppImages.movimentosTerra` e `assets/images/movimentos_terra.webp` seguem sem uso real, o que contraria o CA8 ao pé da letra. Mantidos de propósito: é arte do subtema "Movimentos da Terra", que existe no enum e deve ganhar conteúdo, e o teste de `AppImages` percorre todas as entradas. Decisão da pessoa: remover (entrada, arquivo e ajuste do teste) ou ligar a imagem ao subtema quando ele tiver objetos.
- **Detalhe:** a faixa de ambiente de testes muda de fonte (Aleo para Figtree). Inevitável ao tirar a Aleo; só aparece fora de produção.

## Não conferido
- Painel logado (lista, temas e editor de objeto): sem credenciais.
- Subtema, tema e Sobre em 390 px no HEAD foram vistos só pelo implementador; nesta rodada o 390 cobriu objeto e Contato.
