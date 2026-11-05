# Execução da Fase 2

- **Início:** 2026-11-04
- **Branch:** refactor/redesign-fase-2 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 007-pagina-tema | 2.1 | feita | feita | feita | verificada com ressalvas (12/12 critérios) |
| 008-pagina-subtema | 2.2 | feita | feita | feita | verificada com ressalvas (19/19, CA18 com ressalva) |
| 009-pagina-objeto | 2.3 | feita | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (fase) As specs 007 a 009 já existiam, aprovadas em 2026-10-27: cada sessão de spec faz uma revisão rápida contra o código atual em vez de recriar a spec.
- (fase) Base `develop`: a Fase 1 e o PR #10 já foram integrados nela.
- (007) Nome do subtema vem do `SubthemeEnum`; cabeçalho em 768 com uma coluna e medalhão de 96 px; `PageHeader` ganha `trailing` e `details`; `ThemePage` chama `ensureLoaded()`; chips com 44 px (protótipo: cerca de 36). Detalhes na spec.
- (007) Tablet usa o nome e o respiro do celular nos cartões (18,4 → 16 px em 768) para não partir palavras.
- (008) `/representacoes-espaciais/movimentos-terra` passa a dar 404 (subtema fora do `ThemeDataModel`, zero objetos no dev e no seed), junto com subtema inexistente ou de outro tema. Antes caía no primeiro subtema.
- (008) "Ver ficha" ligado a `CatalogItem.route`: oculto até a 009. Paginação por cursor sai nesta entrega. Linha em hover usa `accentStrong` (accent sobre surface dá 4,48:1).
- (009) Código de referência em Figtree 600 tabular; quatro rotas irmãs, uma por tema, com `redirect` que normaliza o código; página sem `PageHeader` nem store; endereço inválido desativa os botões e mostra "Endereço indisponível".
- (009) `ContentResponseModel.fromJson` testa `preservationOperation`, chave que nenhum dos 190 objetos do dev tem: o catálogo lê `preservationAction` à parte, sem tocar no modelo do painel. Correção do painel fica para 014/015.

## Ressalvas
- (007) Nome longo parte a palavra abaixo de ~346 px e com texto a 200%, sem corte; a saída pediria nova faixa de largura.
- (007) Texto a 200% e "reduzir movimento" conferidos só por teste; painel admin não conferido.
- (008) Chips de tipo anunciam `aria-checked`, não "pressionado": o motor web 3.35.5 não emite `aria-pressed`.
- (008) Ano de emissão não aparece no dev: nenhum dos 190 objetos tem o dado (visto só com datasource alterado; produção não consultada).
- (008) Texto a 200% no navegador e rede cortada de verdade não conferidos; painel admin sem credenciais (`/admin` abre o login).

## Ocorrências
- `pubspec.lock` chegou com alteração solta (transitivos `characters`, `matcher` etc.): ficou fora dos commits da fase.
- (007) Na implementação, uma sessão rodou `pkill -x cat` para destravar um comando próprio; pode ter encerrado outro `cat` da máquina.
- (007) Leitura do catálogo no dev funcionou com dados reais (35, 74, 42, 39; 190 no total).
- (008) Limite de 5 horas interrompeu a implementação logo no início, sem commits; retomada na mesma sessão em 2026-11-05.
