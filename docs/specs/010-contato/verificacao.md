# Verificação da 010. Contato

- **Data:** 2026-11-06
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `ecc024c` e `3aa7ee3`, não só as notas da implementação. Três commits `fix:` depois deles.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois das correções |
| `fvm flutter test` (cópia em caminho ASCII) | 659 testes passaram antes das correções; 663 depois (4 novos) |
| `fvm dart format` nos `.dart` da entrega e das correções | formatados |
| `fvm flutter build web --release` (cópia ASCII) | concluiu, antes e depois |
| `fvm flutter run -d web-server` (debug, cópia ASCII) | sem asserção, exceção nem `overflow` em 390, 768 e 1280, com erros, textos longos e confirmação |
| `grep` em `lib/` da entrega por `Color(0x`, `fontSize:`, `EdgeInsets`/`SizedBox` com número, `.scale`, `Duration(`, `GestureDetector`, `num_extension`, rota solta | nada |
| `git diff --stat b5ed322..3aa7ee3` em `lib/features/admin`, `lib/core/models`, `app_text_field.dart`, `validators.dart`, `app_button.dart`, `firestore.rules`, `pubspec.yaml`, `pubspec.lock` | sem alterações |

## Critérios de aceite
Interação no Chrome sem janela (CDP), com semântica ligada quando indicado; aparência também no navegador embutido em 375, 768 e 1280. Protótipo lido da aba "Contato".

| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Página e rota | passou | `/contato` direto e depois de recarregar; navbar, rodapé e menu do celular levam a ela; "Contato" ativo na navbar e no menu; `h1`, migalhas ("Início" é o único link) e texto de apoio |
| 2 | Formulário | passou | Quatro rótulos, envelope à esquerda, **Enviar** em negrito. Enter passa de Nome a E-mail, a Assunto e a Mensagem; lá quebra linha (valor com `\n`). `autocomplete` `name` e `email`, `type=email` |
| 3 | Envio vazio | passou | Com a página rolada e Nome sob a navbar: quatro mensagens, foco no Nome em y=100, logo abaixo da navbar, nenhum `window.open`. Nenhum erro antes da tentativa |
| 4 | Regras de validação | passou | `a b@c.de` e `errado` dão a mensagem de e-mail; `   ` em Nome conta como vazio; `  ana@exemplo.com  ` vale e sai aparado; o `aria-invalid` e a mensagem somem ao corrigir, enquanto se digita |
| 5 | Abertura do e-mail | passou | `window.open` capturado, alvo `_self`: `mailto:expogeoufu@gmail.com?subject=…&body=…` com `%20`, `%26`, `%3F`, `%23`, `%25`, `%C3%A7`, `%F0%9F%98%80` e `%0D%0A`. Sem aba em branco: `/json` do CDP lista uma aba só depois do `mailto:` real. 77 mil caracteres passam sem erro |
| 6 | Confirmação | passou | Substitui o formulário; `h2` com foco; anúncio em `flt-announcement-polite`; caixa inteira abaixo da navbar em 390, 768 e 1280, a partir de página rolada |
| 7 | Copiar mensagem | passou | `writeText` simulado recebeu "Assunto: …", linha em branco e o corpo. "Mensagem copiada" e, com recusa, "Erro ao copiar", ambos anunciados, voltando ao rótulo em cerca de 2 s |
| 8 | Voltar ao formulário | passou | Campos mantidos, sem erros, foco em Nome; novo envio só por teclado abre o `mailto:` de novo |
| 9 | "Outros meios" | passou depois da correção | E-mail abre `mailto:`, endereço igual ao do rodapé (`AppLinks.address`). Link do Observatório: com a semântica ligada navegava a própria aba (abaixo); depois, só a aba nova. Anel de foco visto nos dois links; nome com ", abre em nova aba". Ressalva 2 |
| 10 | Teclado, leitura e contraste | passou, com ressalvas 1 e 2 | Ordem de Tab da spec, no formulário e na confirmação. `aria-label` "Nome. Escreva seu nome." e `aria-invalid`. Níveis `h1` e `h2`. Contraste calculado pelos tokens: menor 4,87 (branco sobre `#C94400`); secundário 7,01 e 6,45; `#A33600` 6,26 na superfície; erro 6,54; verde do ícone 5,71; borda do campo 3,82 |
| 11 | Responsivo | passou | Em 390, 768 e 1280, vazio, com erros, textos longos e confirmação: `scrollWidth` igual à janela, em release e em debug. Mudar a largura mantém o digitado, na confirmação inclusive. Botão na largura toda só em 390; botões da confirmação empilhados e centralizados em 390 |
| 12 | Código e não regressão | passou | `grep` e `git diff` acima. Home, `/sobre`, `/cultura-politica` e 404 abrem em 390, 768 e 1280 depois da troca no `SiteScaffold`, sem rolagem horizontal, com o rodapé inteiro |

## Problemas encontrados
- **Link de texto navegava a própria aba com a semântica ligada** (bloqueia, resolvido). Com `linkUrl`, o motor cria um `<a href>` sem `target`, e o clique segue o endereço além do `onTap`: com leitor de tela, a pessoa ia ao Observatório na aba atual, perdia o formulário e ganhava uma segunda aba; no `mailto:`, o mesmo caminho acionaria o programa de e-mail duas vezes (deduzido do motor). Visto por CDP, depois de abrir a árvore semântica: duas abas no Observatório. Corrigido tirando o `linkUrl` do `InlineLink`: uma aba nova só, `/contato` fica aberto; um `window.open` só no `mailto:`.
- **Estouro do rodapé** (ajuste, resolvido). O aviso do teste com Ahem não era só da fonte de teste. O `SliverFillRemaining(hasScrollBody: false)` mede pela altura intrínseca, e o `ConstrainedBox` do `PageContent` repassa a largura da janela, não a máxima de conteúdo; em janelas acima de cerca de 1100 px a medida sai menor que a real. Reproduzido com as fontes reais a 125% em teste e, em debug, com `font-size: 20px` no `<html>`, em `/contato` e `/sobre`, a 1280 e 1440. Corrigido no `SiteScaffold` com `SliverLayoutBuilder`, sem medida intrínseca; o rodapé continua preenchendo até a base em páginas curtas. Mesma conferência sem erro. Os três testes novos de `overflow` falham sem a correção.
- **Espaço entre os textos da confirmação** (detalhe, resolvido): 10 px, e o protótipo dá 18 (`gap` mais a margem do parágrafo). Token renomeado para `mailConfirmationTextBottom`.
- **Comentários de três linhas** em `contact_form.dart` e `contact_confirmation.dart` (detalhe, resolvido).
- **README de specs** dizia que não existe `test/` (detalhe, resolvido).
- **O endereço de e-mail não pode ser selecionado** (detalhe, mantido). O `AppFocusRing` desliga a seleção nos clicáveis, e nem a cópia leva "Para:". Quem não tem programa de e-mail precisa digitar o endereço que lê na confirmação. A spec não pede outra coisa; vale decidir se "Copiar mensagem" deve incluir o destinatário.
- **Dicas e "Não abriu?" em 14 px** (detalhe, mantido): o protótipo dá 14,5. Usa o token `small`, como o resto do site.

## Ressalvas
1. **Primeiro Tab de qualquer página** cai em paradas sem foco visível, antes de "Visitar". Anterior a esta entrega, comum a todas as telas e já registrado na 009. Não foi tentada correção.
2. **Links de texto sem papel de link no leitor de tela.** Sem `href`, o `<a>` do motor não é lido como link; o nome, o foco e a ativação funcionam. É o mesmo caso dos demais links externos do site, que usam `AppButton`. O motor 3.35.5 não permite `target` no `href`, e abrir a aba certa pesa mais.

## Fora desta entrega
- **`partner_logo.dart` tem o mesmo `linkUrl` externo** e deve ter o mesmo defeito do primeiro problema. Não foi alterado nem conferido aqui.

## Não conferido
- **Programa de e-mail real e leitor de tela real:** o endereço foi capturado na chamada de `window.open`, e a leitura, na árvore semântica. O duplo acionamento do `mailto:` foi deduzido do código do motor.
- **Sugestão real do navegador:** só o atributo `autocomplete`.
- **Área de transferência de verdade:** `writeText` simulado, em sucesso e recusa.
- **Link direto no servidor:** o critério 1 foi conferido com fallback local; `dev.expogeo.com.br` depende da reescrita no `.htaccess`, fora do repositório.
- **Painel admin:** sem credenciais de teste; nada nele mudou.
