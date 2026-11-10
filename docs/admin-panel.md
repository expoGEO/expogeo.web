# Painel administrativo

Gestão dos objetos digitais da expoGEO, em `lib/features/admin/`. Segue as camadas e o fluxo `Widget → Store → Repository → Datasource → Firebase` de [architecture.md](architecture.md). O painel não cria nem edita temas e subtemas, não tem situação de publicação (rascunho/publicado) e não altera coleções nem regras: salvar um objeto já o publica no site.

## 1. Estrutura

```
lib/features/admin/
├── admin_setup.dart                  # DI: login + painel
├── login/
│   ├── infra/                        # firebase_auth_datasource, auth_repository, auth_failure
│   └── presentation/                 # signin_page, components/ (marca, anéis), stores/ (auth_store, auth_state)
└── panel/
    ├── panel_setup.dart
    ├── infra/                        # content_datasource, content_repository, content_response_model,
    │                                 # reference_code (regra do código), content_failures
    └── presentation/
        ├── pages/                    # panel_shell, panel_objects_view, panel_themes_view, object_editor_page
        ├── components/               # barra, menu lateral, linhas, filtros, seção; editor/ (peças do editor)
        ├── editor/object_editor_form.dart   # estado do formulário (fora do widget)
        ├── stores/                   # content_store (gravação), panel_objects_store (lista)
        ├── panel_address.dart        # leitura e montagem dos endereços do painel
        └── panel_list_memory.dart    # filtros da lista, lembrados na sessão
```

A lista, as contagens e a busca vêm do catálogo único (`lib/features/catalog/`, ver [architecture.md](architecture.md)), o mesmo que alimenta o site; o painel só grava pelo `ContentRepository`.

## 2. Rotas e sessão

| Rota | Conteúdo |
|---|---|
| `/admin` | Login. Com sessão, vai direto para `/admin/painel/objetos` |
| `/admin/painel` | Redireciona para `/admin/painel/objetos` |
| `/admin/painel/objetos` | Lista de objetos, dentro da moldura |
| `/admin/painel/temas` | Temas e subtemas, só consulta, dentro da moldura |
| `/admin/painel/objetos/novo` | Editor de objeto novo, página inteira, fora da moldura |
| `/admin/painel/objetos/:codigo/editar` | Editor de objeto existente (`NMA_BH_03` redireciona para `nma-bh-03`) |

`AppRouter.adminRedirect(path, restoredUser)` decide pela sessão já recuperada e só consulta o Firebase nos caminhos de `/admin`, para não atrasar o site público: sem sessão, qualquer caminho abaixo de `/admin/painel` volta ao login; com sessão, `/admin` vai à lista. Endereço desconhecido abaixo de `/admin/painel/` cai no 404 do site. A recuperação da sessão tem limite de 3 s. A moldura e o editor reagem à perda de sessão voltando ao login.

## 3. Login

Duas colunas (marca sobre fundo escuro com anéis e formulário); abaixo de 1024 px a faixa da marca vem acima do formulário. Sem navbar nem rodapé do site. O erro é único para credenciais erradas (`invalid-credential`, `user-not-found`, `wrong-password`, `invalid-email`), com mensagem própria para falha de rede; o texto é mapeado na apresentação, não nas `AuthFailure`. Validação só depois da primeira tentativa; "Entrando…" no `AppButton` com o botão inativo (sem a opacidade de desativado, para manter o contraste); proteção contra envio repetido na página e na store; aviso anunciado por `announceToScreenReader`; botão de senha com `toggled`. O aviso só aparece se veio desta tela. "Voltar ao site" é um `AppButton.ghost` com seta.

## 4. Moldura

Barra superior (com "Ver site", que abre `/` em nova aba, e a pessoa conectada com iniciais) e menu lateral "Curadoria" com "Objetos digitais" (submenu por tema, com contagens) e "Temas e subtemas". Abaixo de 900 px (`panelCollapseWidth`) o menu vira gaveta (`Scaffold.drawer`, com retorno do foco ao botão). A moldura recarrega o catálogo ao abrir (para não mostrar números de antes do login) e depois de cada gravação feita pela lista. As vistas são trocadas sem animação. Parâmetros inválidos do endereço são ignorados na leitura.

## 5. Lista de objetos

Todos os objetos do catálogo, do mais recente, em linhas com medalhão do subtema, título, código, subtema, criador, data e tipo. Filtros em linha, guardados no endereço: busca `q` (código, título, autor ou assunto, sem acento), `tema`, `subtema` (valores do site) e `tipo` (pelo nome do enum, como `video`). O endereço é a fonte da verdade: selects usam `go` (uma entrada de histórico por escolha) e a busca usa `Router.neglect`; o campo de busca guarda o próprio texto e só é reescrito quando `q` muda por fora. Ações com dica: abrir o recurso, editar e excluir (pede confirmação, com foco inicial em "Cancelar"). A linha excluída some na hora e volta ao catálogo recarregado. "Novo objeto" sem subtema escolhido avisa e leva o foco ao seletor que falta. O resultado das gravações é um observável (`outcome`) mostrado pela vista com `Messenger`; as falhas técnicas não aparecem na tela.

## 6. Editor de objeto

Página própria, com os campos agrupados em Conteúdo, Autoria, Origem e registro, Direitos e preservação. À direita: tema, subtema, **código gerado** e prévia do cartão (o `ObjectCard` do site, sem foco nem interação). O estado do formulário fica em `ObjectEditorForm`, não numa store.

- **Código de referência** (`reference_code.dart`): prefixo que os objetos do subtema já usam (o mais frequente; no empate, o do maior número), mais o maior número + 1 com 2 dígitos (`NMA_PAG_06`); em subtema vazio, a sigla do `SubthemeEnum` + `_01`. Ao editar sem trocar de subtema, o código não muda; ao trocar, o editor confirma o novo código e, se ele estiver ocupado na gravação, avisa qual foi dado. "Regras de registro" é campo opcional.
- **Pendências:** `ObjectEditorForm.missing()` devolve os campos que faltam, na ordem da tela; o resumo (`FormErrorAlert`, anunciado e com o foco) liga a cada campo, que mostra "Preencha …". Ano de emissão aceita só 4 algarismos. Próxima revisão é mês + ano (ano atual − 1 até + 5).
- **Saída:** `onExit` da rota e o aviso nativo do navegador (`beforeunload`, via `dart:js_interop`, com importação condicional para a VM) só perguntam quando há alterações em relação ao retrato inicial; voltar ao valor original não conta.
- **Volta à lista** com os filtros anteriores (`PanelListMemory`), e `CatalogStore.refresh()` depois de gravar. Tema e subtema rolam até a vista ao ganhar foco. O aviso de sucesso aparece na tela seguinte.

## 7. Formato gravado

O documento fica em `themes/{sigla do tema}/subthemes/{sigla do subtema}/contents/{código}`, com os mesmos campos dos objetos já cadastrados:

- `id` = código = id do documento; `themeId` e `subthemeId` com as siglas (`NMA`, `NMA_BH`); `themeTitle` e `subthemeTitle` com os nomes como aparecem no site (alguns diferem da grafia do seed, e nenhuma tela lê esses campos);
- `intellectualIndicator`, `contentInfo`, `originInfo`, `registrationInfo`, `rightsInfo` e `preservationAction`;
- tipo e formato pelo **nome** do enum (`site`, `video`, `html`, `outro`); `insertionDate` e `updateDate` só com o dia (`2026-11-09`), e a próxima revisão grava o dia 1 do mês.

Criar e mover de subtema usam **transação** com o código como id (`createWithCode`, `moveContent`): não sobrescreve nem duplica um código, e mover não deixa duas cópias. Editar atualiza o mesmo documento sem tocar em chaves que o editor não conhece; objetos antigos com id automático continuam editáveis. Excluir apaga o documento do próprio objeto.

**Leitura tolerante** (vale também para o site): tipo e formato são aceitos pelo nome (`site`, `html`) ou pelo rótulo (`Site`, `HTML`, como o formulário antigo gravava); a preservação é lida de `preservationAction`, e um valor malformado deixa só a preservação vazia, sem tirar o objeto do site.

## 8. Regras do Firestore

`firestore.rules` (ver [deployment.md](deployment.md)): leitura aberta em `themes`, `subthemes` e `contents` (inclusive por grupo de coleções); gravação só com sessão (`request.auth != null`). Não há papéis: qualquer conta do Auth do ambiente grava. As contas do painel são criadas no console do Firebase de cada ambiente e ficam fora do repositório; as do dev não existem na produção.

## 9. Pontos de atenção

- Tipo e formato têm de ser gravados pelo nome; o rótulo só é aceito na leitura.
- A lista e as contagens dependem do catálogo recarregado; qualquer gravação nova fora do painel só aparece depois de `CatalogStore.refresh()`.
- `AppFilterSelect`: o menu abre com a largura do conteúdo, mais estreito que o campo (Tipo, Formato, Mês, Ano, Tema, Subtema); duas tentativas com `minimumSize` do `MenuStyle` não resolveram e a causa está no dimensionamento do `MenuAnchor`.
- "Ver site" é botão (não `InlineLink`) por causa do `linkUrl` externo com a semântica ligada.

## 10. Não conferido com Firestore real

Login, gravação, exclusão e a transação de criar e mover só foram vistos com autenticação e repositório simulados, por falta de credenciais de teste. Também não foram vistos: leitor de tela real, texto a 200% e o aviso nativo ao fechar a aba (o evento é disparado, mas o navegador embutido não mostra o diálogo). Conferir com uma conta de teste no dev: entrar, listar, filtrar, criar, editar, mover de subtema e excluir, comparando o documento gravado com um dos existentes.
