# 014. Painel: lista de objetos, filtros e exclusão

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.3 (tela T-09, lista "Objetos digitais")
- **Protótipo:** aba "Painel", vista "Objetos digitais" (link em docs/specs/README.md); referência no Observatório: a lista do painel em `lib/app/features/admin/panel/presentation/components/list/` (`panel_filter_bar.dart`, `panel_list_row.dart`, `panel_list_footer.dart`, `panel_list_skeleton.dart`, `panel_list_states.dart`). O Observatório não guarda specs no repositório.
- **Criada em:** 2026-10-27

> A tela T-09 foi dividida em duas specs: **013** moldura do painel e "Temas e subtemas" (verificada) e **014** lista de objetos (esta). O editor em página própria é a **015**.

## Objetivo
A curadoria encontra qualquer objeto em poucos segundos (por código, título, autor ou assunto, por tema, subtema e tipo), vê de relance onde ele está e age sobre ele (abrir, editar, excluir) com segurança.

## Situação atual
- A moldura da 013 já existe: barra, menu lateral com contagens, gaveta abaixo de 900 px e as vistas `/admin/painel/objetos` (aceita `?tema=…&subtema=…`) e `/admin/painel/temas`. O menu e "Ver objetos" já mudam o endereço; a casca recarrega o catálogo ao abrir o painel e depois de cada gravação.
- A vista "Objetos digitais" (`lib/features/admin/panel/presentation/pages/panel_objects_view.dart`) mostra o cabeçalho e a área de objetos antiga (`legacy_objects_area.dart`): seletor de tema e subtema (`theme_subtheme_selector.dart`), "Novo Conteúdo" (`PrimaryButton`, só com subtema escolhido), tabela `content_list.dart` (`DataTable` com ID, Título, Tipo, Criador, Data de Inserção e os ícones Editar/Excluir com dica, rolagem horizontal em 390 e texto cinza claro), carregando com `CircularLoading` e vazio/erro com `ContentEmpty`/`ContentError`.
- A lista vem do Firestore subtema por subtema (`ContentStore`), não do catálogo único; sem tema escolhido, não mostra nada.
- Criar e editar abrem o diálogo `content_form_dialog.dart` com o tema e o subtema do seletor. Excluir usa o diálogo de confirmação compartilhado com os textos antigos ("Confirmar Exclusão", "Deletar"); falhas aparecem como aviso curto com a mensagem técnica do erro.
- **Leitura dos dados gravados:** `ContentResponseModel.fromJson` procura a preservação na chave `preservationOperation`, que nenhum dos 190 objetos do dev tem (a chave gravada é `preservationAction`); por isso o formulário abre com "Operação de Preservação" em branco. O catálogo contorna isso lendo `preservationAction` à parte. Os 190 objetos do dev guardam tipo e formato pelo nome (`site`, `html`), mas o formulário grava pelo rótulo (`Site`, `HTML`), e a leitura só reconhece o nome: um objeto criado pelo formulário volta como "Outro" em todo o site.

## Comportamento

### Cabeçalho
- Rótulo "Curadoria", título "Objetos digitais" (ou o nome do tema escolhido) e o resumo "190 objetos" ("1 objeto" no singular), com " com os filtros atuais" quando houver busca, subtema ou tipo (o tema já aparece no título).
- Botão primário **"Novo objeto"** com ícone de mais, sempre visível (em largura total no celular). Comportamento até a 015 em "Criar e editar até a 015".

### Filtros em linha
- Faixa de filtros com: busca "Buscar por código, título, autor ou assunto"; **Tema** ("Todos os temas" + os 4); **Subtema** ("Todos os subtemas" + os do tema); **Tipo** ("Todos os tipos" + Site, Vídeo, Documento, Aplicativo, Imagem, Outro).
- Busca ignora acentos e maiúsculas; com várias palavras, todas precisam aparecer. Procura no código (aceita `_` ou `-`: `nma_bh` e `nma-bh-03` acham os objetos de Bacias Hidrográficas), no título, no criador e nos assuntos. O campo tem botão de limpar.
- Subtema desativado até escolher um tema; trocar o tema limpa o subtema.
- O tema do filtro e o do menu lateral são o mesmo: escolher no filtro destaca o tema no menu e muda o título; escolher no menu muda o filtro. Escolher pelo menu (ou por "Ver objetos" em "Temas e subtemas") abre o tema, ou o subtema, com os outros filtros limpos, como na 013.
- Os filtros entram no endereço: `/admin/painel/objetos?tema=…&subtema=…&tipo=…&q=…` (tema e subtema com os valores dos endereços do site; tipo pelo nome: `site`, `video`, `documento`, `aplicativo`, `imagem`, `outro`). Recarregar mantém tudo. Digitar na busca não cria uma entrada no histórico por letra. Valores desconhecidos são ignorados, como na 013.
- Mudar qualquer filtro volta a mostrar os 12 primeiros.

### Lista
- Lista em linhas, num bloco com borda (sai a tabela). Cada linha:
  - medalhão do subtema (ilustração inteira, círculo de 48 px);
  - título, até 2 linhas, que é link para editar;
  - linha de detalhes: **código** em destaque (Figtree 600 com algarismos tabulares, em pílula com borda, como na página do objeto) · subtema · criador · "inserido em 12 mar 2025";
  - selo com ícone e nome do tipo (os ícones do site);
  - ações só de ícone, com dica: **Abrir o recurso** ("Abrir o recurso numa aba nova"), **Editar** ("Editar a ficha deste objeto") e **Excluir** ("Excluir: pede confirmação antes de apagar").
- Ordem: data de inserção mais recente primeiro; na mesma data, o menor código antes.
- Rodapé da lista: "Mostrando 12 de 190" e, quando houver mais, "Mostrar mais" (+12).

### Criar e editar até a 015
Enquanto o editor em página própria não existe, a lista nova usa o formulário de hoje (diálogo `content_form_dialog.dart`, sem mudar seus campos nem seu visual):
- **"Novo objeto"** com um subtema escolhido nos filtros abre o diálogo de cadastro nesse tema e subtema. Sem subtema escolhido, o botão continua ativo e mostra o aviso curto "Escolha o tema e o subtema nos filtros para cadastrar um objeto.", com o foco indo para o filtro que falta (Tema, ou Subtema se o tema já estiver escolhido).
- **"Editar"** e o título abrem o diálogo de edição com o tema e o subtema do próprio objeto, com os campos preenchidos como gravados, inclusive a operação de preservação.
- Ao salvar: o diálogo fecha, a lista e as contagens do menu se atualizam, os filtros continuam, e aparece o aviso "Objeto cadastrado" ou "Alterações salvas". Falha: aviso "Não deu para salvar. Confira a conexão e tente de novo." (no lugar da mensagem técnica).
- A 015 troca o diálogo pelo editor nos endereços `/admin/painel/objetos/novo` e `/:codigo/editar`; os avisos de sucesso passam a aparecer na volta do editor, com os filtros mantidos.

### Excluir
- Diálogo "Excluir “{título}”?" — "O objeto sai do site e do painel. Não dá para desfazer." — botões "Cancelar" (foco inicial) e "Excluir" (vermelho). Esc ou "Cancelar" fecham e devolvem o foco ao botão.
- Ao confirmar: o objeto é apagado do subtema dele, a linha some na hora, as contagens do menu se atualizam, aparece o aviso "Objeto excluído" e o foco vai para o campo de busca.
- Falha: aviso "Não deu para excluir. Tente de novo." e a linha continua.

## Estados
- **Carregando:** cabeçalho sem o resumo e 4 linhas-esqueleto (círculo + duas linhas) no lugar da lista; os filtros já aparecem.
- **Vazio com filtros:** "Nenhum objeto com esses filtros" — "Mude a busca ou os filtros, ou cadastre um objeto novo."
- **Sem nenhum objeto:** "Nenhum objeto cadastrado ainda" com "Novo objeto".
- **Erro:** caixa de erro "Não conseguimos carregar os objetos" com "Tentar de novo", que carrega de novo (e as contagens do menu junto).
- **Sem imagem / imagem com falha:** placeholder do medalhão.
- **Casos de borda:** 1 resultado ("1 objeto", "Mostrando 1 de 1"); exatamente 12 (sem "Mostrar mais"); título longo quebra em até 2 linhas com reticências; criador ou subtema longos quebram a linha de detalhes sem empurrar as ações; endereço do recurso vazio ou que não comece com `http://` ou `https://` deixa "Abrir o recurso" desativado (ainda focável) com a dica "Este objeto não tem endereço válido"; excluir o último objeto de um filtro mostra o vazio com filtros; recarga do catálogo em andamento não pisca o esqueleto (a lista atual fica até chegar a nova).

## Responsivo
- **390:** cabeçalho com "Novo objeto" em largura total; busca em largura total e os três filtros abaixo, em 2 colunas (Tema e Subtema; Tipo); cada linha vira cartão: medalhão e textos em cima, selo abaixo dos textos, ações à direita numa faixa embaixo, separada por linha tracejada.
- **768:** busca numa linha e os três filtros na de baixo; linhas como no desktop, com a linha de detalhes quebrando.
- **1280:** filtros numa faixa só (busca ocupa o que sobra); linhas completas com selo e ações à direita.

## Acessibilidade
- Campos de filtro com nome ("Buscar objetos", "Tema", "Subtema", "Tipo"); o subtema desativado é lido como indisponível.
- Resumo de quantidade anunciado quando muda por causa de busca ou filtro.
- Cada linha é um grupo com o título do objeto; o título é lido como link. Botões de ação com nome que diz de qual objeto se trata ("Abrir o recurso de “{título}”", "Editar “{título}”", "Excluir “{título}”") e dica no hover e no foco.
- Diálogo de exclusão como alerta modal; Esc cancela e devolve o foco ao botão.
- "Mostrar mais" leva o foco ao título do primeiro item novo.
- Foco visível em tudo; contraste ≥ 4,5:1 em detalhes, selo, código, resumo e rodapé (nada de cinza claro).

## Dados e regras de negócio
- Lista de todos os objetos de uma vez (190 hoje), do catálogo único da spec 004 (Q-04), o mesmo das contagens do menu, filtrada no navegador. Como no site, só entram os subtemas listados (Movimentos da Terra fica de fora).
- Excluir apaga o documento em `themes/{tema}/subthemes/{subtema}/contents/{docId}` do próprio objeto, como hoje. Criar e editar gravam como hoje (diálogo), até a 015.
- Sem rascunho/publicado: todo objeto salvo está no site.
- **Ler corretamente o que já está gravado** (não muda campos, coleções, regras nem o que é gravado):
  - a preservação passa a ser lida da chave `preservationAction`, a que os objetos têm; um valor malformado ali deixa só a preservação vazia, sem tirar o objeto do site;
  - tipo e formato são reconhecidos tanto pelo nome (`site`, `html`, como estão os 190 objetos do dev) quanto pelo rótulo (`Site`, `HTML`, como o formulário grava). Objetos criados pelo formulário deixam de aparecer como "Outro" na lista, nos filtros por tipo e nas páginas do site.
- Gravar tipo e formato pelo nome, como os demais objetos, fica para o editor (015).
- Nenhuma rota nova nem renomeada: só parâmetros novos (`tipo`, `q`) em `/admin/painel/objetos`.

## Critérios de aceite
- [ ] "Objetos digitais" lista todos os objetos do catálogo (190 no dev) sem precisar escolher tema, em linhas com medalhão, título, código (Figtree 600 em pílula), subtema, criador, "inserido em …" e selo do tipo, do mais recente para o mais antigo; resumo "N objetos" no cabeçalho.
- [ ] A busca por código (`nma_bh` e `nma-bh-03`), por título, por criador e por assunto encontra os objetos certos, com e sem acento e com várias palavras.
- [ ] Filtros de tema, subtema e tipo combinam com a busca; o subtema fica desativado sem tema e é limpo ao trocar o tema; o resumo ganha " com os filtros atuais" com busca, subtema ou tipo.
- [ ] O tema do filtro e o do menu lateral ficam sincronizados (destaque do menu e título), e "Ver objetos" em "Temas e subtemas" abre a lista com tema e subtema escolhidos.
- [ ] Os filtros entram no endereço (`tema`, `subtema`, `tipo`, `q`); recarregar mantém todos; valores desconhecidos são ignorados; sem sessão, volta ao login.
- [ ] "Mostrar mais" acrescenta 12 por vez e leva o foco ao primeiro item novo; o rodapé mostra "Mostrando X de Y"; mudar um filtro volta aos 12 primeiros.
- [ ] "Abrir o recurso" abre o endereço do objeto em aba nova e fica desativado, com a dica "Este objeto não tem endereço válido", quando o endereço não serve.
- [ ] Até a 015: "Novo objeto" com subtema escolhido abre o formulário nesse subtema e, sem subtema, mostra o aviso e leva o foco ao filtro que falta; "Editar" e o título abrem o formulário do objeto com os campos como gravados, inclusive a operação de preservação.
- [ ] Salvar pelo formulário atualiza a lista e as contagens sem recarregar a página, mantém os filtros e mostra "Objeto cadastrado" ou "Alterações salvas"; um objeto criado pelo formulário aparece com o tipo certo (não "Outro") na lista e no site.
- [ ] Excluir pede confirmação com os textos novos, remove o objeto do Firestore do dev, tira a linha, atualiza as contagens e mostra "Objeto excluído"; falha mostra "Não deu para excluir. Tente de novo." e mantém a linha.
- [ ] Esqueleto (4 linhas), vazio com filtros, sem nenhum objeto e erro com "Tentar de novo" aparecem nos casos certos.
- [ ] Todo botão só de ícone tem nome com o título do objeto e dica no hover e no foco; os filtros têm nome; o resumo é anunciado quando muda.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow` (também com título e criador longos); contraste ≥ 4,5:1; lista, filtros, ações e diálogo alcançáveis por teclado com foco visível.
- [ ] O código novo e o alterado usam os tokens do tema, sem `num_extension`, cor ou tamanho solto; a área de objetos antiga (seletor, tabela, "Novo Conteúdo", estados antigos) sai da vista; "Temas e subtemas", login e telas públicas continuam como estavam (exceto o tipo correto dos objetos criados pelo formulário).

## Fora do escopo
- Editor em página própria, endereços `/admin/painel/objetos/novo` e `/:codigo/editar`, redesenho dos campos e gravação de tipo e formato pelo nome (spec 015). Até lá, o diálogo atual fica como está, inclusive com `num_extension` e botões antigos.
- Remover `PrimaryButton`, `SecondaryButton` e `CircularLoading` do projeto (016); a 014 só tira o uso deles da lista.
- Exclusão em lote, exportar lista, ordenar por outra coluna.
- Mudanças em campos, coleções ou regras do Firestore.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
- 2026-11-09: revisada contra o código das Fases 0–3, da 012 e da 013 (verificada) e a aba "Painel" do protótipo, antes do plano (modo autônomo, sem mudar o status). Mudanças: situação atual reescrita a partir da moldura da 013 (vista, área antiga, `ContentStore` por subtema, diálogo, leitura de preservação e de tipo/formato); referência do Observatório trocada pelos arquivos da lista, já que lá não há `docs/specs/031`; código de referência em Figtree 600 com algarismos tabulares, em pílula, em vez de monoespaçado (decisão da 001, como na 009); botão "Novo objeto" com ícone (o "+" do texto era o ícone); resumo com singular e regra do " com os filtros atuais"; busca com `_` ou `-` no código e botão de limpar; parâmetro `tipo` pelo nome e busca sem uma entrada de histórico por letra; menu e "Ver objetos" limpam os outros filtros, como na 013; ordem com desempate pelo código; seção nova "Criar e editar até a 015"; foco depois de excluir e linha que some na hora; estados com casos de 1 e 12 itens e recarga sem piscar; responsivo detalhado pelo protótipo; nomes de ação com o título do objeto; seção de leitura dos dados gravados; critérios reescritos (14) e fora do escopo com o que fica para 015 e 016.
- 2026-11-09 (decisões sem a pessoa): (1) até a 015, "Novo objeto", "Editar" e o título abrem o diálogo atual, sem mudá-lo, para criar e editar continuarem funcionando entre as entregas; (2) "Novo objeto" sem subtema escolhido não abre nada e pede o subtema nos filtros (aviso e foco), porque o diálogo não deixa escolher tema e subtema; (3) os avisos de sucesso ("Objeto cadastrado", "Alterações salvas") e o de falha ao salvar com texto novo entram já na 014, depois do diálogo; (4) a leitura da preservação pela chave `preservationAction` e o reconhecimento de tipo e formato por nome ou rótulo entram na 014, porque a lista mostra o tipo, filtra por ele e abre a edição, e ler corretamente o que já está gravado não muda o modelo de dados; gravar pelo nome fica para a 015, junto do editor; (5) o menu e "Ver objetos" continuam abrindo o tema/subtema com os outros filtros limpos, como a 013 entregou (o protótipo manteria busca e tipo); (6) depois de excluir, o foco vai para a busca, porque o botão usado some com a linha; (7) "Abrir o recurso" sem endereço válido continua focável, para a dica ser lida pelo teclado (comportamento do `AppIconButton`); (8) os filtros em 390 ficam em 2 colunas e em 768 em duas linhas, uma leitura fixa por faixa do `flex-wrap` do protótipo.
