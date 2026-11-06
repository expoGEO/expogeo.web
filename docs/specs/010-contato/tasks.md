# Tarefas da 010. Contato

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios de aceite (spec, na ordem): CA1 página e rota; CA2 formulário; CA3 envio vazio; CA4 regras de validação; CA5 abertura do e-mail; CA6 confirmação; CA7 copiar mensagem; CA8 voltar ao formulário; CA9 "Outros meios"; CA10 teclado, leitura e contraste; CA11 responsivo; CA12 código e não regressão.

Comandos `analyze` e `test` rodam na cópia em caminho ASCII do scratchpad (ver "Como conferir" do plano). Nunca incluir `pubspec.lock` em commit.

## Grupo A: base
- [x] **A1.** Tokens: cor `fieldBorder`; dimensões do campo, apoio, confirmação, página e "Outros meios" listadas no plano; estilos `formLabel`, `formError` e `confirmationTitle`. Arquivos: `app_colors.dart`, `app_dimensions.dart`, `app_text_styles.dart`. Atende: CA10, CA12. Conferir: `analyze` limpo; nenhuma tela muda. Nota: acrescentado `formFieldPaddingVSingleLine` (11,5), porque 12 deixava o campo de uma linha com 49 px.
- [x] **A2.** `FormValidators.required` e `.email`. Testes: vazio, nulo, só espaços; `nome@exemplo.com`, com espaços nas pontas; sem "@", sem ponto, com espaço no meio, com dois "@". Arquivos: `form_validators.dart`, `test/core/utils/form_validators_test.dart`. Atende: CA3, CA4.
- [x] **A3.** `MailDraft`: `mailtoUrl` e `copyText`. Testes: acentos, emoji, `&`, `?`, `#`, `%`, espaço como `%20` e nunca `+`, quebra como `%0D%0A`; decodificar devolve o texto original; `copyText` é "Assunto: …", linha em branco e corpo. Arquivos: `mail_draft.dart`, `test/core/utils/mail_draft_test.dart`. Atende: CA5, CA7.

## Grupo B: componentes de `core/`
- [x] **B1.** `InlineLink(text, url, semanticLabel?, style?)`. Testes: `mailto:` abre pelo `fakeUrlLauncher`; nome acessível próprio; um só nó focável, marcado como link. Arquivos: `inline_link.dart`, `test/core/components/inline_link_test.dart`. Atende: CA6, CA9, CA10. Nota: com `container: true`; sem ele, dentro de `WidgetSpan` o link se fundia ao parágrafo e perdia o `href`.
- [x] **B2.** `MarkedText`. Testes: `**Enviar**` em peso 700 e o resto normal; texto sem marca intacto. Arquivos: `marked_text.dart`, teste junto em `test/core/components/form_text_field_test.dart`. Atende: CA2, CA6.
- [x] **B3.** `FormTextField(label, controller, focusNode, validator?, multiline, keyboardType?, autofillHints?, textInputAction?, onSubmitted?)`. Testes: rótulo visível e nome acessível iguais; erro abaixo, na cor de erro, com `validationResult` inválido e no nome acessível; borda `fieldBorder`, acento no foco, erro com erro; mensagem de 6 a 12 linhas; sem `overflow` em 320. Arquivos: `form_text_field.dart`, `test/core/components/form_text_field_test.dart`. Atende: CA2, CA3, CA10. Nota: o erro vai no `label`, porque o motor web ignora `hint` em campo de texto.

## Grupo C: feature de contato
- [x] **C1.** `ContactInfoCard`: `h2` "Outros meios" e os pares E-mail, Endereço (`AppLinks.address`, três linhas) e Observatório (`displayDomain`, ", abre em nova aba"). Testes: textos, `mailto:`, endereço igual ao do rodapé, nível do título. Arquivos: `contact_info_card.dart`, `test/features/contact/contact_info_card_test.dart`. Atende: CA9, CA10.
- [x] **C2.** `ContactConfirmation(draft, onBack)`: caixa, ícone, título `h2` com `Focus`, textos, link, "Copiar mensagem" e "Voltar ao formulário"; foco e `ensureVisible` depois do primeiro quadro; `Timer` cancelado no `dispose`; `SemanticsService.announce` do título e da cópia. Testes: textos; foco no título e anúncio; texto copiado no `SystemChannels.platform`; rótulo volta depois de `copyFeedbackDuration`; falha mostra "Erro ao copiar" e volta; `onBack` chamado; nada pendente ao desmontar. Arquivos: `contact_confirmation.dart`, `test/features/contact/contact_confirmation_test.dart`. Atende: CA6, CA7, CA10. Nota: anúncio do título por `announce`, porque o motor web não aplica `liveRegion` a título.
- [x] **C3.** `ContactForm`: quatro campos, `AutofillGroup`, Enter passa de campo, botão com `leadingIcon` e `fullWidth` no celular, apoio, validação com `AutovalidateMode`, foco e `ensureVisible` no primeiro inválido, `openUrl(sameTab: true)`, troca com a confirmação e volta. Testes: sem erros antes da tentativa; envio vazio com quatro mensagens, foco no Nome e nada aberto; erro some ao digitar; só espaços; e-mail com espaço nas pontas; `mailto:` com valores aparados e corpo no formato da spec; volta com campos, sem erros, foco no Nome; novo envio. Arquivos: `contact_form.dart`, `test/features/contact/contact_form_test.dart`. Atende: CA2, CA3, CA4, CA5, CA6, CA8. Nota: rolagem e foco em quadros separados; juntos, com a página rolada, o campo não recebia texto com a semântica ligada.
- [x] **C4.** `ContactPage` (`StatefulWidget`): `SiteScaffold`, `PageHeader` com "Início › Contato", `h1` e texto de apoio; colunas 3:2 no desktop, empilhadas nas outras faixas; `GlobalKey` no formulário. Testes: 390, 768 e 1280 sem exceção de layout; texto digitado mantido ao passar de 768 para 1280; migalhas e título. Arquivos: `contact_page.dart`, `test/features/contact/contact_page_test.dart`. Atende: CA1, CA11. Nota: `FocusTraversalGroup` em cada coluna, porque a ordem geométrica de Tab alternava entre elas no desktop.
- [x] **C5.** Rota: `GoRoute` de `AppRouter.contact` antes das rotas de tema. Teste com a rota real, como `about_route_test.dart`: abre a `ContactPage` com o item "Contato" marcado. Arquivos: `app_router.dart`, `test/core/navigation/contact_route_test.dart`. Atende: CA1.

## Grupo D: fechamento do código
- [x] **D1.** README: `FormTextField` (`components/form/`) e `InlineLink` (`components/button/`) na linha "Componentes" do Design System. Arquivo: `README.md`. Atende: CA12.
- [x] **D2.** `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` lá, trazendo os arquivos de volta; `grep` nos arquivos novos por `Color(`, `fontSize:` e espaçamento soltos, `num_extension`, `GestureDetector`, rota solta e menção a spec ou protótipo em comentário; `git diff --stat` sem `app_text_field.dart`, `validators.dart`, `app_button.dart`, `lib/features/admin/`, `pubspec.yaml`, `pubspec.lock`, modelos ou `firestore.rules`. Atende: CA12.

## Grupo E: conferência
- [x] **E1.** **Conferência final rodando o app.** Na cópia ASCII: `fvm flutter build web --release`, servidor Python próprio em background com fallback de SPA, navegador embutido em 390, 768 e 1280 px, comparando com a aba "Contato" do protótipo. Abrir `/contato` direto e recarregar; chegar também pela navbar, pelo menu do celular e pelo rodapé. Conferir: item ativo; formulário vazio; envio vazio com a página rolada (erros, foco, campo visível fora da navbar); correção de cada campo; e-mail inválido e com espaços; Enter nas linhas simples e na mensagem; textos muito longos; `mailto:` capturado por interceptação de `window.open`, com acentos, emoji, `&`, `?`, `#`, `%` e quebras; confirmação inteira na tela e foco no título; "Copiar mensagem" com `writeText` simulado, em sucesso e recusa; "Voltar ao formulário" e novo envio; links de "Outros meios"; ordem de Tab e foco visível; árvore semântica (`aria-label` com o erro, `aria-invalid`, `autocomplete`); largura da janela alterada com texto digitado; `scrollWidth` igual à janela; rodapé na base. Depois, `fvm flutter run -d web-server --web-port <porta>` (**modo debug**) em 390 e 1280, com erros, textos longos e confirmação, sem `overflow` nem asserção no console. Abrir Home, `/sobre`, um tema e o 404: sem mudança. Painel: sem credenciais de teste, "não conferido no app". Voltar o navegador ao preset desktop e parar os servidores por PID. Atende: CA1 a CA11. Nota: digitação conferida no Chrome sem janela (CDP), porque o painel oculto não repassa texto; aberturas de `/contato` no painel embutido só nos primeiros passos.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| CA1. Página e rota | C4, C5, E1 |
| CA2. Formulário | B2, B3, C3, E1 |
| CA3. Envio vazio | A2, B3, C3, E1 |
| CA4. Regras de validação | A2, C3, E1 |
| CA5. Abertura do e-mail | A3, C3, E1 |
| CA6. Confirmação | B1, B2, C2, C3, E1 |
| CA7. Copiar mensagem | A3, C2, E1 |
| CA8. Voltar ao formulário | C3, E1 |
| CA9. "Outros meios" | B1, C1, E1 |
| CA10. Teclado, leitura e contraste | A1, B1, B3, C1, C2, E1 |
| CA11. Responsivo | C4, E1 |
| CA12. Código e não regressão | A1, D1, D2 |
