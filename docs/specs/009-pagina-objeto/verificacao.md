# Verificação da 009. Página do objeto digital

- **Data:** 2026-11-05
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `git diff 400dc16..71bc32d` (commits 6d542e2, 83f0b0a e 71bc32d), não só as notas da implementação. Correção no commit `fix:` 2a57583.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois da correção |
| `fvm flutter test` (cópia em caminho ASCII) | 607 testes passaram antes da correção; 608 depois (1 novo) |
| `fvm dart format` nos `.dart` alterados na correção | formatados |
| `fvm flutter build web --release` (cópia ASCII, Firestore real do dev) | concluiu, antes e depois da correção |
| `fvm flutter run -d web-server` (debug, cópia ASCII, datasource e registro de foco alterados só nela) | nenhuma asserção, exceção nem `overflow` no console: ficha, seleção, cópia, lista do subtema, esqueleto, erro, 404 e casos de borda |
| Consulta somente leitura ao Firestore do dev (`runQuery` de `contents` em todas as coleções) | 190 objetos; nada gravado |
| `grep` nos `lib/` da entrega por `Color(0x`, `fontSize:` numérico, `EdgeInsets`/`SizedBox` com número, `.scale`, `Duration(`, `GestureDetector`, `num_extension` | nada |
| `git diff --stat` em `lib/features/admin`, `lib/core/models`, `lib/core/content`, `firestore.rules`, `pubspec.yaml` | sem alterações |

## Critérios de aceite
Na ordem da spec. Telas vistas no build release com Firestore real, salvo onde indicado.

| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Link direto e recarregar | passou | `…/biomas/nma-bio-01` carregado direto, sem passar pelo subtema, e de novo depois de recarregar; um objeto de cada um dos 4 temas e `nma-pag-01` |
| 2 | Grafias e endereço com hífen | passou | `nma-bio-03`, `NMA_BIO_03`, `nma_BIO-03`, `%20nma-bio-03` e barra final abrem "Contemplatio" em `…/nma-bio-03`; `?x=1` é mantido. De `/sobre`, abrir `NMA_BIO_03` e voltar cai em `/sobre`; avançar, em `…/nma-bio-03` |
| 3 | Topo | passou | Comparado com a aba "Objeto" em 1280 e 768, e em 390 pela spec. Voltar leva a `…/biomas`; migalhas, ao subtema e ao tema. `video/video`, `site/outro` sem formato no rótulo |
| 4 | "Acessar" e "Copiar link" | passou | `window.open` simulado recebeu o endereço do recurso. A escrita real foi negada no navegador embutido (`NotAllowedError`); com `writeText` simulado recebeu o endereço, mostrou "Link copiado" e voltou ao texto original em cerca de 2 s |
| 5 | Falha ao copiar | passou | Negação real do navegador: mensagem visível, endereço selecionado, anúncio em `flt-announcement-polite`. O Tab seguinte vai a "Ver todos" |
| 6 | Endereço inválido ou vazio | passou | Datasource alterado: `nma-bh-01` (texto sem esquema) e `nma-bh-02` (vazio) com os dois botões desativados e "Endereço indisponível" |
| 7 | Nota de conteúdo | passou | Comparada nos 190 objetos; sem nota no datasource alterado, o bloco some |
| 8 | Ficha completa | passou | **Os 190 objetos, nos 4 temas (35, 74, 42, 39), comparados campo a campo** com a leitura do Firestore: título, descrição, nota, endereço, pílula e os 14 pares, nos dois sentidos, sem campo faltando nem sobrando. Dois alarmes (`nma-des-02`, `re-cg-02`) eram da conferência: mesmo título do objeto anterior; repetidos, batem. "dez 2026" e ação de preservação com dado real. Figtree 600 tabular no estilo `code` |
| 9 | Campos vazios e padrão | passou | Datasource alterado: sem Autoria, Conteúdo e Direitos quando vazios ou só com espaços; preservação malformada some sem tirar o objeto; "Regras de registro" com o texto padrão; "Outro" na ficha e fora do rótulo |
| 10 | Outros objetos | passou | Até 3, na ordem do código, sem o atual; subtema de um objeto só (datasource alterado) sem a seção; "Ver todos" leva ao subtema; cartão aberto por Enter mostra o objeto do topo |
| 11 | Lista do subtema | passou | "Ver ficha" e título levam à página (Sustentabilidade, `nma-sus-02`). "Carregar mais" põe o foco no título do sétimo, com anel. `scrollWidth` igual à largura em 390, 768 e 1280 |
| 12 | Home | passou | Exemplo 3 leva a `…/biomas/nma-bio-01`; os 6 cartões de "Adicionados recentemente" levam às páginas dos objetos |
| 13 | Não encontrada | passou | Por rota real: `biomas/nao-existe`, `biomas/nma-bh-03`, `cultura-politica/biomas/nma-bio-01`, `movimentos-terra/re-cg-01`, `movimentos-terra`, `xpto/eur-ct-01`, `biomas/%20`, código inexistente nos 4 temas, e `XYZ_1`, que passa a `xyz-1`. Catálogo vazio também dá 404 |
| 14 | Esqueleto e erro | passou | Datasource com atraso e falha: voltar e migalhas à vista em 390 e 1280; "Tentar de novo" volta ao esqueleto e mostra o objeto |
| 15 | Responsivo e contraste | passou | Disposição conferida com a aba do protótipo; `scrollWidth` igual à largura nas 3 larguras, inclusive título longo e endereço longo. **Contraste medido nos pixels do canvas:** menor valor 4,87 (`#C94400` sobre branco, nos títulos dos grupos e no rótulo do tipo; branco sobre `#C94400` no botão); secundário 7,01 sobre branco e 6,45 sobre superfície; `#A33600` 6,26 sobre superfície; erro 6,54 |
| 16 | Teclado e leitura de tela | passou depois da correção | Havia uma parada invisível depois de "Copiar link" (abaixo). Depois: Copiar → "Ver todos" → cartões, com anel e a página acompanhando. Um `h1`, `h2` e `h3` na ordem, "Voltar para Biomas", "abre em nova aba", "Temas" ativo. Ressalva 1 |
| 17 | Regressões | passou | `/`, `/contato`, tema, subtema e `/sobre` abrem. `/sobre` em 390 inteira, botões do tamanho do texto, como antes: `fullWidth` desligado por padrão. `/admin` mostra o login. Nada no painel, nos modelos de conteúdo ou nas regras |

## Aceite da Fase 2
Tema, subtema e objeto seguem o protótipo em 390, 768 e 1280 px, com carregando, vazio, erro e 404 (007 e 008 nas verificações próprias; nesta, o objeto e a lista do subtema, além do vazio do subtema com catálogo vazio). Aba "Objeto" renderizada localmente a partir do `read_artifact`. Diferenças decididas na spec: código em Figtree 600, botões em largura total em 390, faixas do projeto em vez do limite de 640 px.

## Problemas encontrados
- **Parada invisível do Tab depois de "Copiar link"** (ajuste, resolvido em 2a57583). No web, `SelectionArea` traz uma visão de plataforma com foco próprio, e o `skipTraversal` no nó do endereço não a alcança. Registro do foco mostrou `PlatformView` entre "Copiar link" e "Ver todos". `ExcludeFocusTraversal` em volta do endereço tira a parada e mantém o foco por código da falha ao copiar. Conferido de novo em debug e em release: 13 Tabs chegam a "Ver todos"; antes eram 14. Teste novo em `object_actions_test.dart`.
- **Duas seleções ao mesmo tempo** (detalhe, ressalva 2). O endereço tem área de seleção própria, e selecionar nele não limpa o que estava selecionado no resto da página, nem o contrário. `SelectionArea` aninhado sem exceção em debug; arrastar e clique duplo funcionam nas duas áreas.
- **"Ver todos" recuado 12 px** da margem (detalhe). É o preenchimento do botão discreto; o protótipo usa link sem preenchimento. Mantido: a área de toque vem daí. Vale também para "Ver ficha" na linha, em celular e tablet.

## Ressalvas
1. **Primeiro Tab de qualquer página** cai numa parada invisível, a mesma visão de plataforma, no `SelectionArea` do `SiteScaffold`. Anterior a esta entrega e comum a todas as telas. Não foi tentada correção: tirar a área do Tab tiraria tudo que está dentro dela, e o `HtmlElementView` interno não expõe o nó de foco. Fica nas pendências do histórico.
2. **Seleções simultâneas** (acima). Só aparência: não há perda de dado nem erro. Decisão: manter, porque é o preço de "selecionar tudo pega só o endereço".
3. **Ano de emissão** segue sem dado real: nenhum dos 190 objetos tem. Visto só com datasource alterado.

## Não conferido
- **Reescrita de endereços de 3 segmentos no servidor:** o `.htaccess` não está no repositório; o servidor local usa fallback próprio. Conferir em `dev.expogeo.com.br` depois do deploy.
- **Painel admin:** sem credenciais de teste; `/admin` só mostra o login.
- **Produção:** não consultada; a leitura de `preservationAction` foi vista só no dev.
- **Área de transferência de verdade:** o sucesso foi visto com `writeText` simulado e em teste, porque o navegador embutido nega a escrita.
- **Texto a 200%:** só por teste, como nas specs anteriores.
