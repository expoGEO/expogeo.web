# 014. Painel: lista de objetos, filtros e exclusão

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.3 (tela T-09, lista "Objetos digitais")
- **Protótipo:** aba "Painel", vista "Objetos digitais" (link em docs/specs/README.md); referência no Observatório: `docs/specs/031-painel-listas/`
- **Criada em:** 2026-10-27

## Objetivo
A curadoria encontra qualquer objeto em poucos segundos (por código, título, autor ou assunto, por tema, subtema e tipo), vê de relance onde ele está e age sobre ele (abrir, editar, excluir) com segurança.

## Situação atual
- `panel_page.dart` + `content_list.dart`: tabela (`DataTable`) com ID, Título, Tipo, Criador, Data de Inserção e Ações (editar, excluir), só depois de escolher um tema ou subtema no seletor.
- "Novo Conteúdo" só aparece com um subtema escolhido e abre o diálogo `content_form_dialog.dart`.
- Exclusão com o diálogo "Confirmar Exclusão" / "Tem certeza que deseja deletar o conteúdo "…"?".

## Comportamento

### Cabeçalho
- Rótulo "Curadoria", título "Objetos digitais" (ou o nome do tema escolhido no menu) e o resumo "190 objetos" (com " com os filtros atuais" quando houver filtro além do tema).
- Botão primário **"+ Novo objeto"** sempre visível; abre o editor (spec 015) já com o tema e o subtema dos filtros, quando houver.

### Filtros em linha
- Busca "Buscar por código, título, autor ou assunto" (ignora acentos e maiúsculas; várias palavras precisam aparecer todas).
- **Tema** ("Todos os temas" + os 4), sincronizado com o submenu do menu lateral.
- **Subtema** ("Todos os subtemas" + os do tema), desativado até escolher um tema; trocar o tema limpa o subtema.
- **Tipo** ("Todos os tipos" + os 6 tipos).
- Filtros entram no endereço (`?tema=…&subtema=…&tipo=…&q=…`), para recarregar sem perder.

### Lista
- Lista em linhas (sai a tabela). Cada linha:
  - medalhão do subtema;
  - título (link para editar);
  - linha de detalhes: **código** (monoespaçado) · subtema · criador · "inserido em 12 mar 2025";
  - selo com ícone e nome do tipo;
  - ações só de ícone, com dica: **Abrir o recurso** ("Abrir o recurso numa aba nova"), **Editar** ("Editar a ficha deste objeto") e **Excluir** ("Excluir: pede confirmação antes de apagar").
- Ordem: data de inserção mais recente primeiro.
- Rodapé da lista "Mostrando 12 de 190" e "Mostrar mais" (+12) quando houver mais.

### Excluir
- Diálogo "Excluir "{título}"?" — "O objeto sai do site e do painel. Não dá para desfazer." — botões "Cancelar" (foco inicial) e "Excluir" (vermelho).
- Ao confirmar: a linha some, as contagens do menu se atualizam e aparece o aviso "Objeto excluído".
- Falha: aviso "Não deu para excluir. Tente de novo." e a linha continua.

### Depois do editor
- Voltando do editor após salvar, a lista mostra o aviso "Objeto cadastrado" ou "Alterações salvas" e mantém os filtros.

## Estados
- **Carregando:** 4 linhas-esqueleto (círculo + duas linhas).
- **Vazio com filtros:** "Nenhum objeto com esses filtros" — "Mude a busca ou os filtros, ou cadastre um objeto novo."
- **Sem nenhum objeto:** "Nenhum objeto cadastrado ainda" com "+ Novo objeto".
- **Erro:** caixa de erro "Não conseguimos carregar os objetos" com "Tentar de novo".
- **Sem imagem:** placeholder do medalhão.
- **Casos de borda:** título longo quebra em até 2 linhas; endereço do recurso vazio ou inválido desativa "Abrir o recurso" com dica "Este objeto não tem endereço válido"; excluir o último objeto de um filtro mostra o estado vazio.

## Responsivo
- **390:** filtros empilhados (busca em largura total, selects em 2 colunas); cada linha vira cartão (medalhão e título em cima, detalhes, selo e ações embaixo).
- **768:** filtros em duas linhas; linhas como no desktop, com detalhes quebrando.
- **1280:** filtros numa faixa só; linhas completas.

## Acessibilidade
- Campos de filtro com rótulo ("Buscar objetos", "Tema", "Subtema", "Tipo").
- Resumo de quantidade anunciado quando muda.
- Botões de ação com nome ("Excluir {título}") e dica no hover e no foco.
- Diálogo de exclusão como alerta modal; Esc cancela e devolve o foco ao botão.
- "Mostrar mais" leva o foco ao primeiro item novo.

## Dados e regras de negócio
- Lista de todos os objetos de uma vez (190 hoje), do catálogo único da spec 004 (Q-04), filtrada no navegador.
- Excluir apaga o documento em `themes/{tema}/subthemes/{subtema}/contents/{docId}`, como hoje.
- Sem rascunho/publicado: todo objeto salvo está no site.
- Nenhuma mudança em campos, coleções ou regras.

## Critérios de aceite
- [ ] "Objetos digitais" lista todos os objetos sem precisar escolher tema, em linhas com medalhão, título, código, subtema, criador, data e tipo.
- [ ] Busca por código (`nma_bh`), por título, por autor e por assunto encontra os objetos certos, com e sem acento.
- [ ] Filtros de tema, subtema e tipo combinam com a busca; o subtema fica desativado sem tema.
- [ ] O tema do menu lateral e o do filtro ficam sincronizados.
- [ ] Recarregar a página mantém os filtros.
- [ ] "Abrir o recurso" abre o endereço em aba nova; "Editar" e o título abrem o editor do objeto.
- [ ] Excluir pede confirmação, remove o objeto do Firestore do dev, atualiza a lista e as contagens e mostra "Objeto excluído".
- [ ] "Mostrar mais" acrescenta 12 por vez.
- [ ] Esqueleto, vazio com filtros e erro com "Tentar de novo" aparecem nos casos certos.
- [ ] Todo botão só de ícone tem nome e dica.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; tudo alcançável por teclado.

## Fora do escopo
- Editor (spec 015).
- Exclusão em lote, exportar lista.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
