# Plano da 012. Login do painel

- **Spec:** spec.md
- **Criado em:** 2026-11-08

## Abordagem
A `SignInPage` é reescrita no desenho do login do Observatório (`lib/app/features/admin/login/presentation/`), adaptado à marca da expoGEO e aos componentes que as Fases 0–3 já criaram: `AppBrand(onDark: true)` do rodapé, `FormTextField` e `FormValidators` do Contato, `AppButton.primary`/`.ghost` e `AppFocusRing`. A página continua na feature `admin/login`, com a mesma store MobX, o mesmo repositório e o mesmo datasource do Firebase Auth; muda a apresentação e duas pontas da infraestrutura (a sessão recuperada e a proteção contra tentativa dupla).

Duas colunas no desktop (flex 5:6) e, abaixo de 1024 px, faixa da marca no topo com o cartão embaixo, numa página rolável. As mensagens de erro saem de um mapeamento na apresentação, de `AuthFailure` para os textos da spec, sem mexer nas classes de falha (o "Sair" do painel ainda usa as mensagens delas).

O que 013 e 015 também vão usar nasce em `core/`: o `FormTextField` ganha senha, sufixo e dica; o `FormErrorAlert` (aviso único em fundo de erro) serve ao resumo de pendências do editor; o `AppButton` ganha o estado "carregando", que os botões de salvar do painel também terão. O que é só do login (coluna da marca, círculos, botão de mostrar senha) fica em `features/admin/login/presentation/components/`.

A sessão recuperada depois do primeiro quadro é resolvida no roteador: para caminhos de `/admin`, o `redirect` (que já é assíncrono) espera o primeiro valor de `authStateChanges` antes de decidir. `/admin` com sessão redireciona para `/admin/painel`, o mesmo destino que a página de login já usa depois de entrar; `/admin/painel` sem sessão continua voltando para `/admin`. Os caminhos não mudam.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | `ShadowStyle.card` (0 12 32, ink a 6%); em `ComponentSizes`, os tokens do login com os valores do Observatório e do protótipo: `loginBrandFlex` 5, `loginFormFlex` 6, `loginBrandPaddingH/V` e `loginBrandGap` por faixa (20/40, 24/40, 18/40), `loginEyebrowGap` 12, `loginBrandLeadGap` 14, `loginBrandTitleMaxWidthEm`, `loginBrandLeadMaxWidth` 340, `loginRingsStep` 31, `loginRingsStroke` 1, `loginRingsOpacity` 0,15, `loginMainPaddingH/Top` por faixa (16/32, 28/48), `loginMainPaddingBottom` 48, `loginCardMaxWidth` 400, `loginCardPaddingH/V` por faixa (20/32, 24/32), `loginCardSubtitleGap` 6, `loginCardFieldsTop` 24, `loginBackLinkTop` 20; alerta (`formAlertPaddingH` 14, `formAlertPaddingV` 12, `formAlertIcon` 20, `formAlertGap` 10); `buttonSpinner` 16 e `buttonSpinnerStroke` 2 |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | `loginBrandTitle` (Bricolage 800, 25,6 no celular/tablet e 44,8 no desktop, -0,03 em), `loginCardTitle` (Bricolage 700, 28), `loginLead` (Figtree 400, 15) |
| Alterar | `lib/core/components/form/form_text_field.dart` | `obscureText`, `suffix` (dentro da caixa, à direita) e `hintText` (só visual). Com `obscureText`, sem sugestões nem autocorreção |
| Criar | `lib/core/components/form/form_error_alert.dart` | Aviso em `errorSurface`, ícone e texto em `error`, `formError`; anunciado por `SemanticsService.announce` quando aparece ou muda |
| Alterar | `lib/core/components/button/app_button.dart` | `isLoading`: indicador branco antes do texto, botão inativo e lido como desativado; o tamanho não pula |
| Criar | `lib/features/admin/login/presentation/components/login_rings_painter.dart` | Círculos concêntricos a partir do canto de baixo à direita |
| Criar | `lib/features/admin/login/presentation/components/login_brand_panel.dart` | Coluna/faixa escura: `AppBrand(onDark: true, tagline:, onTap: Home)`, rótulo, título (`header`), texto e "Sem acesso?" (escondidos em `compact`) |
| Criar | `lib/features/admin/login/presentation/components/password_visibility_button.dart` | Ícone de olho com `Tooltip`, `Semantics(button, toggled, label)`, `AppFocusRing`, alvo de 44 px |
| Criar | `lib/features/admin/login/presentation/login_error_message.dart` | `loginErrorMessage(AuthFailure)`: credenciais (`WrongPassword`, `UserNotFound`, `InvalidCredentials`, `InvalidEmailAddress`), muitas tentativas, desativado e o resto (conexão/servidor) |
| Alterar | `lib/features/admin/login/presentation/pages/signin_page.dart` | Reescrita: layout por faixa, formulário, validação, foco, aviso, "Entrando…", "Voltar ao site" (`AppButton.ghost` pequeno com seta) |
| Alterar | `lib/features/admin/login/presentation/stores/auth_store.dart` | `login` ignora chamada enquanto a anterior está em andamento; e-mail aparado |
| Alterar | `lib/features/admin/login/infra/datasources/firebase_auth_datasource.dart` e `.../repositories/auth_repository.dart` | `restoredUser()`: primeiro valor de `authStateChanges` (a sessão salva já recuperada) |
| Alterar | `lib/core/navigation/app_router.dart` | `redirect` de `/admin` e `/admin/painel` por `adminRedirect`, testável, que espera `restoredUser()`; builder de `/admin` passa a ser só a `SignInPage` |
| Alterar | `README.md` | Linha "Componentes" do Design System: `FormErrorAlert` e o `isLoading` do `AppButton`; senha no `FormTextField` |
| Criar | `test/core/components/form_error_alert_test.dart`, `test/core/components/button/app_button_loading_test.dart` | Componentes |
| Alterar | `test/core/components/form_text_field_test.dart` | Senha, sufixo e dica |
| Criar | `test/features/admin/login/login_error_message_test.dart`, `password_visibility_button_test.dart`, `login_brand_panel_test.dart`, `signin_page_test.dart`, `auth_store_test.dart` | Comportamento da tela com repositório falso |
| Criar | `test/core/navigation/admin_redirect_test.dart` | Decisão de `/admin` e `/admin/painel` com sessão recuperada tarde |

Não mudam: `AppTextField`, `Validators` (ainda do formulário do painel), `auth_failure.dart`, `auth_state.dart` (sem `build_runner`), `panel/`, `EnvironmentBanner`, modelos, `firestore.rules`, caminhos de rota.

## Decisões técnicas
- **Mensagens mapeadas na apresentação, não nas falhas.** Trocar os textos de `AuthFailure` mudaria o erro do "Sair" no painel atual (013 cuida dele). O Firebase manda `invalid-credential` nas versões novas e `user-not-found`/`wrong-password` nas antigas; todos viram o aviso único. `invalid-email` também, porque a validação local já barrou o formato e o Firebase só o acusa em casos de borda. `network-request-failed` cai em `ServerError` e na mensagem de conexão.
- **`FormTextField` estendido, não um campo novo do painel.** O campo do Contato já é o desenho do protótipo para o painel (`.field` é o mesmo CSS). Um campo separado duplicaria borda, anel e semântica. A 013 e a 015 usam o mesmo.
- **`FormValidators` reusados com as mensagens da spec.** `email` já apara espaços e usa a regex do protótipo; `required` apara também, o que recusa senha só de espaços. Senha só de espaços é inválida no Firebase de qualquer jeito, e a spec pede "senha vazia"; aceitar a recusa evita uma tentativa inútil.
- **Validação depois da primeira tentativa (`AutovalidateMode.always`), como no Contato.**
- **Aviso visível só quando veio desta tela.** A store é singleton e guarda o último erro; um `bool` no `State` da página evita mostrar um aviso antigo ao voltar ao login (achado do Observatório).
- **Proteção dupla contra tentativa repetida:** a página ignora envio com `LoginStateLoading`, e a store também, para Enter e clique no mesmo quadro.
- **"Entrando…" no `AppButton`, sem botão próprio do login.** O texto troca e o indicador entra antes dele; o botão fica inativo sem a opacidade de desativado, para o texto continuar com contraste (no protótipo, o `[disabled]` deixa 0,45, o que dá branco sobre laranja abaixo de 4,5:1).
- **Anúncio do aviso por `SemanticsService.announce`.** O motor 3.35.5 não aceita `liveRegion` num nó com papel (lição da 010/011).
- **Botão de senha com `toggled`.** O motor publica `aria-checked`, não `aria-pressed` (lição da 009); a spec já registra isso. O `Tooltip` abre também pelo foco do teclado, como no Observatório.
- **"Voltar ao site" como `AppButton.ghost` pequeno com seta.** O protótipo usa cinza que vira laranja no hover; a regra do projeto é laranja para tudo que é clicável, e o ghost já tem foco, nome e tamanho. O `BackToButton` antigo usa tokens velhos e `num_extension`.
- **Marca pelo `AppBrand(onDark: true)` do rodapé**, com `onTap` para a Home; o nome acessível dele é "expoGEO, página inicial".
- **Faixa da marca abaixo de 1024 px.** A spec manda 768 como o celular. No Observatório a faixa é só abaixo de 600; aqui o corte segue `Breakpoint.desktop`.
- **Ordem de foco por `FocusTraversalGroup` com `WidgetOrderTraversalPolicy`**, para ir da marca ao formulário mesmo com as colunas lado a lado.
- **Página sem `SiteScaffold`.** O login não tem navbar nem rodapé no protótipo; sem `SelectionArea`, também não herda a parada invisível de Tab da 009.
- **Sessão no roteador, não na página.** Esperar `authStateChanges().first` só nos caminhos de `/admin` não atrasa o site público. A decisão fica numa função estática (`adminRedirect(path, restoredUser)`) para ser testada sem Firebase, como as outras rotas são testadas sem o redirecionamento do app. Alternativa descartada: esperar a sessão no `main.dart`, que atrasaria todas as páginas.
- **`/admin` com sessão redireciona para `/admin/painel`** em vez de montar o painel em `/admin`. É o destino que a página de login já usa depois de entrar, e deixa um só endereço para o painel; o caminho `/admin` continua existindo.
- **Componentes que nascem para 013/015:** `FormErrorAlert` (resumo de pendências do editor e falhas de gravação), `isLoading` do `AppButton` (salvar) e senha/sufixo no `FormTextField` (sufixo também serve à busca do painel, se a 014 quiser). O resto fica na feature.

## Dependências e geração de código
- Sem pacote novo nem asset novo. `pubspec.lock` não entra em commit; se o `pub get` o alterar, `git restore pubspec.lock`.
- Sem `build_runner`: a store só muda o corpo de uma `@action`; `auth_state.dart` não muda.
- Rotas: nenhuma nova, nenhum caminho alterado; muda só o `redirect` e o builder de `/admin`.
- `LoginSetup` não muda.

## Riscos e cuidados
- **Sem credenciais de teste.** Erro de credenciais, "Entrando…" e a ida ao painel só se veem com autenticação simulada: na cópia ASCII do scratchpad (nunca commitada), um `FirebaseAuthDatasource` falso registrado no `LoginSetup` responde com atraso de ~1,5 s, devolve `invalid-credential`, `too-many-requests`, `user-disabled` ou `network-request-failed` conforme a senha digitada, e um usuário falso (`implements User`) para uma senha combinada. Com `--dart-define` próprio, `restoredUser()` devolve o usuário falso depois de ~500 ms, para conferir o recarregar com sessão recuperada tarde. O painel, aberto com a sessão falsa, pode mostrar erro de leitura; só importa ter chegado a `/admin/painel`. Nada grava no Firestore.
- **`AppButton` é compartilhado** (Home, Sobre, Contato, estados, 404): `isLoading` é opcional e falso por padrão; conferir que essas telas não mudam.
- **`FormTextField` é do Contato:** os parâmetros novos são opcionais; rodar os testes do Contato e conferir `/contato` na tela.
- **Redirecionamento assíncrono:** `authStateChanges().first` no web deve responder logo; se não houver resposta (rede bloqueada), o `/admin` ficaria parado. Usar `timeout` curto (tratando como sem sessão) e conferir no navegador com o Firebase bloqueado.
- **Altura em telas baixas:** coluna da marca com `IntrinsicHeight` dentro de rolagem; conferir 1280×600 e texto a 200%.
- **`Tooltip` do botão de senha** pode sobrar sobre o campo depois do clique; conferir.
- **Autofill do navegador** pinta o fundo do campo; só observar.
- **Não conferível aqui:** login real com o Firebase, leitor de tela de verdade, gerenciador de senhas.

## Como conferir
- `analyze`, `test` e `dart format` numa cópia em caminho ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, `pubspec.lock` de `git show HEAD:pubspec.lock`, `fvm flutter pub get`); formatar lá e trazer os arquivos de volta.
- Sem sessão (build real): `fvm flutter build web --release`, servidor Python próprio com fallback de SPA, `/admin` no navegador embutido em 390, 768 e 1280: layout, textos, erros de validação, foco, mostrar senha, "Voltar ao site", marca, faixa de ambiente; build com `--dart-define=APP_ENV=prod` para ver a faixa sumir.
- Com sessão simulada (só na cópia): erro de credenciais e os outros avisos, "Entrando…" com clique duplo e Enter, ida a `/admin/painel`, recarregar `/admin` com sessão recuperada tarde.
- Uma vez em debug (`fvm flutter run -d web-server --web-port <porta>`), sem `overflow` nem asserção.
- Home, `/sobre`, `/contato`, um tema e o 404 sem mudança. Voltar o navegador ao preset desktop e parar os servidores por PID.
