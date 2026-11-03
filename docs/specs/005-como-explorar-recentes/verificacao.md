# Verificação da 005. Home: Como explorar e Adicionados recentemente

- **Data:** 2026-11-03
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `git diff 3db7c8b..HEAD` (commits ed7010a, d3b5588, 3435a4b, 8aa33a5), não só as notas da implementação.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter test` (cópia em caminho ASCII) | 188 testes, todos passaram |
| `fvm dart format --output=none --set-exit-if-changed` nos 15 `.dart` alterados | 0 alterados |
| `fvm flutter build web --release` (Firestore real; datasource falso com atraso + falha na 1ª chamada; sucesso; lista vazia) | os quatro concluíram |
| `fvm flutter run -d web-server` (debug, datasource falso) em 390, 768 e 1280 | nenhuma asserção, exceção nem `overflow` no log; console sem erros |
| Script REST no `expogeo-dev` (leitura por subtema) | 190 objetos; Biomas 7; menor código NMA_BIO_01 "aVoar Cerrado"; 6 mais recentes CP_RA_02, CP_CD_05, CP_GP_05, CP_IC_08, EUR_CT_01, EUR_CT_02 |
| `grep` no código novo por cor, fonte, espaçamento ou duração soltos, `num_extension`, `GestureDetector` | nada fora dos tokens |
| `git diff --stat` em admin, rotas, `content_model.dart`, `firestore.rules`, `pubspec.*` | sem mudanças |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Três passos com os textos da spec e exemplos levando ao destino certo | passou | Na tela (1280): rótulo, título e os três passos com os textos da spec. Cliques: "Meio Ambiente e Natureza" → `/natureza-meio-ambiente`; "Biomas" → `/natureza-meio-ambiente/biomas`; "aVoar Cerrado" → `/natureza-meio-ambiente/biomas` (subtema até a 009). Teste `home_explore_section_test.dart`. |
| 2 | Contagem de Biomas e título do exemplo 3 vêm dos dados | passou com ressalva | "Biomas · 7 objetos" e "aVoar Cerrado", iguais ao script, com dados do dev servidos por datasource falso; código lê `countBySubtheme` e `firstOf(biomas)`. **Conferir após publicar a regra.** |
| 3 | Os 6 objetos de inserção mais recente | passou com ressalva | Os 6 cartões na mesma ordem do script (desempate por código crescente). Teste do `latest(6)`. **Conferir no Firestore do dev após publicar a regra.** |
| 4 | Cartão com tipo · formato (omissão), título, descrição em 2 linhas, mini-medalhão, subtema e criador | passou | "VÍDEO" (vídeo/vídeo) e "SITE" (formato "Outro") omitidos certo; título até 3 linhas; descrição cortada em 2 com reticências; mini-medalhão do subtema; "Regiões Administrativas · Instituto Brasileiro de Geografia e Estatística (IBGE)" em caixa normal. |
| 5 | Clique no cartão leva ao objeto (ao subtema até a 009) | passou | Clique no rodapé do cartão "MST 40 anos" → `/espacos-urbanos-rurais/conflitos-terra`; Tab com anel visível e Enter no cartão "Exposição Brasil 200 anos" → `/cultura-politica/geopolitica`. Árvore de acessibilidade: um link por cartão com o h3 dentro; h2 nas duas seções; h3 nos passos. |
| 6 | Esqueleto, seção oculta sem dados, erro com "Tentar de novo" que funciona | passou | Com atraso: 6 esqueletos no formato do cartão e esqueletos curtos nos exemplos 2 e 3. Falha: erro compacto "Não conseguimos carregar os objetos recentes", exemplo 2 só "Biomas", sem exemplo 3; "Tentar de novo" → esqueletos → cartões e contagens do hero de volta. Vazio: sem a seção e sem exemplo 3, "Biomas · 0 objetos". Firestore real (`PERMISSION_DENIED`): erro compacto, resto da Home segue. Rede desligada não testada (ver abaixo). |
| 7 | 390, 768 e 1280 sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1 | passou | `scrollWidth` = largura em 390, 768 e 1280; passos em 1, 1 e 3 colunas; cartões em 1, 2 e 3 colunas; erro compacto quebra em 390. Contraste (WCAG 2.1): accent/page 4,87 (rótulo do tipo, links dos exemplos), accentStrong/surface 6,26 (rótulo da seção), accentStrong/accentSoft 6,11 (número), inkSecondary/page 7,01, inkSecondary/surface 6,45 (texto dos passos, mensagem de erro), ink/surface 15,71. |

## Protótipo
Aba "Home": filete escuro de 2 px sobre cada passo, título 20, caixa "Ex.:" branca com borda e link laranja; cartão com quadrado do ícone 40/11, rótulo 12,5 em maiúsculas, título 18, descrição 15 em 2 linhas, rodapé 13,5 com mini-medalhão 22 e filete. Diferenças já decididas e registradas: número em círculo (spec), passos em 1 coluna em 768 (spec; o protótipo troca em 760).

## Regressões (004 e telas vizinhas)
Hero (contagens 190 / 31 / 4 e anel) e cartões dos temas como na 004 em 390, 768 e 1280; página de tema, subtema e 404 abrem normalmente. Painel admin: não conferido na tela (sem credenciais de teste); nenhum arquivo dele mudou.

## Problemas encontrados
- Nenhum no código da 005. Observação sem ação: o "Q" do título "Quantas pessoas…" parece sublinhado; é a cauda do glifo da fonte Bricolage Grotesque, não um estilo.

## Ressalvas
- CA2 e CA3 conferidos com dados do dev lidos por subtema e servidos por datasource falso (só no scratchpad). **Conferir na Home do dev após publicar a regra** de leitura por grupo de coleções (e na produção antes do merge na `main`).
- Falha de rede real (navegador offline) não testada: o navegador embutido não permite desligar a rede. A falha simulada no datasource e o `PERMISSION_DENIED` real cobrem o mesmo caminho de erro e o "Tentar de novo".

## Não conferido
- Painel admin na tela (sem credenciais de teste).
- Dados reais via `collectionGroup` (regra não publicada no dev).
