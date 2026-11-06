# Plano da 010. Contato

- **Spec:** spec.md
- **Criado em:** 2026-11-06

## Abordagem
A página é nova, na feature `contact`, no mesmo formato de `features/about/` (`pages/` e `components/`). Usa `SiteScaffold`, `PageHeader` e `PageContent` como estão: cabeçalho em `SliverToBoxAdapter`, corpo com formulário e "Outros meios" lado a lado no desktop (flex 3:2) e empilhados nas outras faixas. A navbar, o menu do celular e o rodapé já apontam para `AppRouter.contact`; falta só registrar a `GoRoute` e a página.

A base é o código da 018 do Observatório, adaptado. Saem de lá `FormTextField`, `FormValidators`, `MailDraft`, `InlineLink`, `MarkedText` e a lógica do `MailForm` e da `MailConfirmation`, inclusive a correção da verificação de lá (rolar até o campo e a confirmação que recebem o foco). Duas adaptações: a expoGEO só tem um formulário, então `ContactForm` e `ContactConfirmation` têm campos e textos fixos, sem `MailFormFieldSpec`; e o Flutter daqui é o 3.35.5, sem `SemanticsService.sendAnnouncement` (usar `announce`, como a `ObjectActions`).

Peças que 012 e 015 podem reaproveitar ficam em `core/` (`FormTextField`, `FormValidators`, `InlineLink`, `MarkedText`). O que é só do contato fica na feature. Estado local em `State`: nada de store, datasource ou Firebase. `AppButton` já tem `leadingIcon`, `fullWidth` e `focusNode`, e não muda.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | `fieldBorder` (#8A8178, 3,8:1 no branco). `error`, `errorSurface`, `success` e `successSurface` já existem |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens em `ComponentSizes`, com os valores da 018 e da aba "Contato": campo (altura 48, borda 1,5, anel 4, padding 14/12, vão 18, rótulo 6, mensagem 6 a 12 linhas), apoio (topo 12, largura 480), confirmação (padding 48/24, vão 10, ícone 56, glifo 26, texto 440, topo dos botões 8, vão 10), página (40/72, vão entre colunas 28/48/72, flex 3 e 2), "Outros meios" (padding 20/24/28, lista 18, rótulo 2, itens 14). Reusa `copyFeedbackDuration`, `menuAnimation` e `radii` |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | `formLabel` (Figtree 600, 15), `formError` (Figtree 500, 14), `confirmationTitle` (Bricolage 700, 22,4/25,6/25,6). Título de "Outros meios" usa `h3`; rótulos usam `label` |
| Criar | `lib/core/utils/validators/form_validators.dart` | `required(msg)` e `email(msg)`, com espaços aparados; regex do protótipo |
| Criar | `lib/core/utils/url/mail_draft.dart` | `MailDraft(to, subject, body)` com `mailtoUrl` e `copyText` |
| Criar | `lib/core/components/button/inline_link.dart` | Link de texto sublinhado em `accentStrong`, com `AppFocusRing`, `SelectionContainer.disabled` e `semanticLabel` |
| Criar | `lib/core/components/form/marked_text.dart` | Texto com `**negrito**`, usado nos dois textos com **Enviar** |
| Criar | `lib/core/components/form/form_text_field.dart` | Rótulo acima, borda, anel de foco, erro abaixo, uma ou várias linhas. Une o `FormTextField` e o `FormFieldFrame` de lá, sem `opcional`, ajuda, senha nem sufixo, que 012 e 015 acrescentam se precisarem |
| Criar | `lib/features/contact/components/contact_confirmation.dart` | Caixa de confirmação, cópia e retorno |
| Criar | `lib/features/contact/components/contact_form.dart` | Campos, validação, foco, abertura do e-mail e troca com a confirmação |
| Criar | `lib/features/contact/components/contact_info_card.dart` | "Outros meios", com `AppLinks` |
| Criar | `lib/features/contact/pages/contact_page.dart` | Página e colunas |
| Alterar | `lib/core/navigation/app_router.dart` | `GoRoute` de `AppRouter.contact` |
| Alterar | `README.md` | Linha "Componentes" da seção Design System: `FormTextField` e `InlineLink` |
| Criar | `test/core/utils/form_validators_test.dart`, `test/core/utils/mail_draft_test.dart`, `test/core/components/inline_link_test.dart`, `test/core/components/form_text_field_test.dart` | Unidades e componentes |
| Criar | `test/features/contact/contact_confirmation_test.dart`, `contact_form_test.dart`, `contact_info_card_test.dart`, `contact_page_test.dart`, `test/core/navigation/contact_route_test.dart` | Comportamento da tela, com `fakeUrlLauncher` e a rota real, como `about_route_test.dart` |

Não mudam: `AppButton`, navbar, menu, rodapé, `PageHeader`, `SiteScaffold`, `AppTextField`, `Validators`, `UrlUtils`, `AppLinks`, painel, modelos e regras do Firebase.

## Decisões técnicas
- **`ContactForm` fixo em vez de portar o `MailForm` genérico.** O `MailFormFieldSpec` existe lá por causa do Colabore, que aqui não há. Portar a abstração deixaria configuração com um consumidor só.
- **`FormTextField` novo, sem mexer no `AppTextField`.** O antigo está no painel, usa tokens antigos e só muda nas Fases 4 e 5.
- **`FormField<String>` em volta de `TextField`, como lá.** O anel de foco cerca só a caixa e o erro fica abaixo. O texto visível sai da semântica; `label`, `hint` (erro) e `validationResult` vão no nó do campo. O motor 3.35.5 emite `aria-invalid` e `aria-description`; conferido no SDK.
- **`FormValidators` novo, sem mexer no `Validators`.** O `isValidEmail` é do login e do painel, tem outra regra e outra mensagem.
- **Validação depois da primeira tentativa com `AutovalidateMode.always`.** `onUserInteraction` deixaria de fora campos ainda não tocados.
- **Foco com rolagem:** `requestFocus` mais `Scrollable.ensureVisible` com `keepVisibleAtStart`, no campo e na caixa da confirmação. Sem isso, o campo fica sob a navbar fixa (achado da 018).
- **Formulário sem remontar ao mudar de faixa:** `GlobalKey` no `ContactForm`, guardada no `State` da `ContactPage`, porque a troca entre `Row` e `Column` apagaria os campos. Os controladores ficam no `State` do formulário, que sobrevive à ida e volta da confirmação.
- **`mailto:` montado à mão com `Uri.encodeComponent`.** `Uri(queryParameters:)` troca espaço por `+`. Diferença da 018: o corpo troca `%0A` por `%0D%0A`, a quebra de linha que a RFC 6068 pede. Abre com `UrlUtils.openUrl(url, sameTab: true)`, o caminho já usado pelo rodapé.
- **Confirmação sem animação:** troca por `if`, o que já atende movimento reduzido.
- **Retorno da cópia repetido, sem extrair da `ObjectActions`.** Lá a falha tem outro comportamento (seleciona o endereço). A lógica é curta, e extrair mexeria numa tela já verificada. Usa `copyFeedbackDuration` e volta ao rótulo inicial também depois de falhar.
- **Largura do botão de copiar pode variar com o rótulo.** A spec daqui não pede largura fixa, e o `AppButton` não tem `reserveTexts`; acrescentar mudaria um componente compartilhado sem necessidade.
- **`accentStrong` nos links:** `accent` dá 4,48:1 na superfície (achado da 018).
- **`InlineLink` abre `mailto:` na mesma aba e `http(s)` em aba nova**, deduzido do esquema. O nome acessível do Observatório acrescenta ", abre em nova aba", como no `AppButton`.
- **Domínio do Observatório por `UrlUtils.displayDomain(AppLinks.observatory)`**, para não repetir o endereço.

## Dependências e geração de código
- Sem pacote novo nem asset novo (`url_launcher` já está).
- Sem `build_runner`: não há store nem modelo Freezed.
- Rota nova só em `app_router.dart`, a partir da constante existente. Sem `*_setup.dart`.

## Riscos e cuidados
- **Código vindo do Flutter 3.44.** O Observatório usa um Flutter mais novo; APIs podem não existir no 3.35.5. `sendAnnouncement` já se sabe que não existe. O `analyze` acusa o resto.
- **Enter na linha simples:** conferir no navegador, em vez de assumir o comportamento do 3.44.
- **`SelectionArea` do `SiteScaffold`:** campos e links ficam dentro dela. O `AppSearchField` mostra que campos funcionam; `InlineLink` em `WidgetSpan` precisa de `SelectionContainer.disabled`. A parada invisível no primeiro Tab da página é pendência anterior: não reprovar por ela, mas registrar.
- **Semântica:** `InkWell` dentro de nó com filhos pode criar um segundo nó focável. Conferir a árvore do `InlineLink` e dos campos.
- **Rolagem sob a navbar:** conferir em debug e release com a página rolada, a 390 e 1280.
- **`mailto:` no navegador embutido:** não há programa de e-mail. Capturar o endereço interceptando `window.open`. O painel oculto atrasa quadros e pode não repassar digitação: se acontecer, usar Chrome sem janela, como na 018.
- **Área de transferência:** negada no navegador embutido; simular `navigator.clipboard.writeText` para o sucesso e a recusa.
- **Não conferível aqui:** sugestão real do navegador (só o atributo `autocomplete`), leitor de tela de verdade e programas de e-mail reais. Registrar em `verificacao.md`.
- **Link direto no servidor de dev:** `dev.expogeo.com.br` ainda dá 404 fora da raiz (pendência da reescrita no `.htaccess`). O critério 1 é conferido localmente, com fallback de SPA.
- **Tokens de tema:** só acréscimos, sem efeito em outras telas. A rota nova não colide: as de tema são caminhos explícitos, sem curinga.

## Como conferir
- Rodar `analyze`, `test` e `dart format` numa cópia em caminho ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, com `pubspec.lock` de `git show HEAD:pubspec.lock`, depois `fvm flutter pub get`). `dart format` na pasta com "ó" não leria o `page_width` de 100: formatar na cópia e trazer os arquivos de volta.
- Build e debug também na cópia. Nunca incluir `pubspec.lock` em commit.
- `fvm flutter build web --release`, servidor Python próprio com fallback de SPA, `/contato` no navegador embutido em 390, 768 e 1280, comparando com a aba "Contato"; depois `fvm flutter run -d web-server --web-port <porta>` em debug. Voltar ao preset desktop e parar os servidores por PID.
