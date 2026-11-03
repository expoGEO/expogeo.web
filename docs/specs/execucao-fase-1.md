# Execução da Fase 1

- **Início:** 2026-11-03
- **Branch:** refactor/redesign-fase-1 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 004-hero-temas | 1.1-1.2 | feito (13 critérios, 21 tarefas) | feito (3 commits) | feito (3 ajustes pequenos, 1 commit `fix:`) | verificada com ressalvas |
| 005-como-explorar-recentes | 1.3-1.4 | feito (7 critérios, 17 tarefas) | pendente | pendente | |
| 006-sobre-apoio | 1.5-1.7 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (geral) As três specs já estavam aprovadas desde 2026-10-27; a etapa "spec+plano" só revisa a spec diante do que a Fase 0 entregou e cria o plano.
- (004) A regra de leitura por grupo de coleções no `firestore.rules` foi aprovada em Q-04 e entra no código; a publicação à mão no dev e na produção fica com a pessoa.
- (004) Catálogo como feature própria `lib/features/catalog/`, uma consulta `collectionGroup`; tema e subtema saem do caminho do documento.
- (004) Grade dos cartões em 2 colunas só no desktop (a spec se contradizia; segue o protótipo).
- (004) Rótulo e destaque do título do hero em `accentStrong` (o laranja normal dá 4,45:1 sobre o fundo).
- (004) Botão "Como fazemos a curadoria" abre "não encontrada" até a 006 criar `/sobre`.

- (004) Na verificação, "Como fazemos a curadoria" passou mesmo com a barra de endereço em `/`: o GoRouter não troca a URL ao cair na página não encontrada (o link "Sobre" da navbar faz o mesmo); some com a 006.
- (004) Chips com nome do subtema em caixa normal; nome do tema igual ao da navbar ("Meio Ambiente e Natureza").
- (005) Spec revisada diante da 004: nome do tema no exemplo 1 igual ao do site ("Meio Ambiente e Natureza"); "primeiro objeto de Biomas" = menor código de referência; exemplo 3 e cartão levam ao subtema até a 009; estados de erro e vazio de "Como explorar" detalhados.
- (005) Sem consulta nova: `latest(6)` e `firstOf(biomas)` no `CatalogModel`; destino do objeto num só getter (`CatalogItem.route`).
- (005) Cartão de objeto em `lib/core/components/card/` com dados simples (serve à 009 e à 015); erro compacto portado do Observatório até a 011.
- (005) Número do passo em círculo (spec), não só o algarismo do protótipo; rótulo "Como explorar" em `accentStrong` por contraste.

## Ressalvas
- (004) Regra de leitura por grupo de coleções não publicada no dev (`PERMISSION_DENIED` em 2026-11-03): a Home mostra o erro das contagens até a pessoa publicar; publicar também na produção antes do merge na `main`.
- (004) Critério 4 (190 objetos; 35, 74, 42, 39 por tema) conferido só com dados simulados e no teste do modelo: **conferir na Home do dev após publicar a regra**.
- (005) Estado de sucesso dos recentes conferido só com datasource falso (dados do dev lidos por subtema) até a regra ser publicada.

## Ocorrências
- Fase 0 já foi integrada à `develop` (PR #8); a branch da fase saiu de `origin/develop`.
