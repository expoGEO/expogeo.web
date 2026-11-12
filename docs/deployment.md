# Deploy (dev e produção)

O site roda em dois ambientes na HostGator, publicados por GitHub Actions via FTPS, cada um com o próprio projeto Firebase.

| Ambiente | Branch | Workflow | Endereço | Firebase |
|---|---|---|---|---|
| Dev | `develop` | [deploy-dev.yml](../.github/workflows/deploy-dev.yml) | `dev.expogeo.com.br` | `expogeo-dev` |
| Produção | `main` | [deploy-prod.yml](../.github/workflows/deploy-prod.yml) | `expogeo.com.br` | `expogeo-fad33` |

## Fluxo de branches

```
feature/*  ──PR──▶  develop  ──PR──▶  main
                  (deploy dev)      (deploy prod)
```

1. Trabalhe em `feature/*`, `fix/*`, `refactor/*` ou `docs/*`, saindo da `develop`.
2. PR para `develop`: o CI valida. Ao mergear, o dev é publicado.
3. Depois de testar no dev, PR `develop` → `main`. Ao mergear, a produção é publicada. O merge é a aprovação; não há aprovação manual no GitHub.
4. Hotfix: `hotfix/*` saindo da `main`, PR para `main` e depois para a `develop`.

**Push na `main` publica o site.** Nunca faça push direto nela, nem na `develop`. As duas devem ser protegidas (só entram por PR, com o check `validar` do CI obrigatório); o estado dessa proteção no GitHub não está no repositório (ver [Pendências](#pendências-manuais)).

## Workflows

| Arquivo | Gatilho | O que faz |
|---|---|---|
| [ci.yml](../.github/workflows/ci.yml) | PR para `develop` ou `main` | `pub get`, conferência de formatação (`dart format`, largura 100, sem os gerados), `analyze` e `build web`. Não publica e não roda os testes |
| `deploy-dev.yml` | push na `develop` ou manual | Regras e índices do Firestore, build com `APP_ENV=dev`, remoção do Analytics, páginas para o Google (com `noindex`, sem sitemap), `robots.txt` bloqueando indexação, senha no `.htaccess` e FTP para o dev |
| `deploy-prod.yml` | push na `main` ou manual (e agendado, hoje desativado) | Regras e índices do Firestore, build com `APP_ENV=prod`, páginas para o Google com `sitemap.xml` e FTP para produção |

O filtro de "só docs" fica em lugares diferentes para os dois casos:

- **Deploys:** `paths-ignore` (`docs/**`, `**.md`, `.claude/**`, `.vscode/**`, `bin/**`, `ci.yml`, `analysis_options.yaml`). O deploy manual (`workflow_dispatch`) ignora o filtro.
- **CI:** o job `mudancas` compara com a base do PR e só deixa `validar` rodar se algo fora de `docs/`, `.claude/`, `.vscode/`, `bin/`, `deploy-*.yml` e `*.md` mudou. Job pulado por `if` conta como aprovado, então o check obrigatório não trava; `paths-ignore` no gatilho faria o check nunca reportar.

Comum aos três:

- Versão do Flutter lida do `.fvmrc` com `jq`; `actions/checkout@v4`, `subosito/flutter-action@v2` com cache; sem `flutter clean`.
- Só `build/web/` é enviado, num passo de FTP (`SamKirkland/FTP-Deploy-Action@4.3.0`, FTPS na porta 21).
- `concurrency` por ambiente: dois deploys do mesmo ambiente não rodam juntos.
- Nos deploys, regras e índices do Firestore são publicados **antes** do site, porque o código depende deles. As regras do repositório substituem as do projeto; os índices só são criados e atualizados (sem `--force`).

## Deploy agendado de produção (desativado)

O `deploy-prod.yml` traz comentados o gatilho `schedule` e o bloco `permissions` do job. Ativo, ele roda o mesmo deploy todo dia às 03:00 de Brasília (06:00 UTC), sempre sobre a `main`, para o sitemap e as páginas para o Google acompanharem objetos cadastrados ou editados no painel sem ninguém disparar o deploy.

- **Ativar:** só depois do primeiro deploy de produção com o pré-render. A `main` precisa ter `tool/seo`; sem ele o passo do gerador falharia todo dia. Descomente `schedule:` e o `cron` no topo do arquivo e o bloco `permissions` do job, por PR para a `develop` e depois para a `main`. Para desativar, comente de volta.
- **Custo:** nenhum. O repositório é público (minutos do GitHub Actions sem cobrança), cada execução lê cerca de 230 documentos (a cota gratuita do Firestore é de 50 mil leituras por dia) e o FTP só envia o que mudou.
- **Manter vivo:** o GitHub desativa workflows agendados depois de 60 dias sem atividade no repositório. O passo "Manter o agendamento ativo" reativa o próprio workflow pela API a cada execução agendada, sem commit; por isso precisa de `actions: write`. Não foi possível confirmar que isso reinicia o prazo (levaria 60 dias para ver). Se o agendamento parar de rodar, reative em Actions, *Deploy Flutter Web (produção)*, *Enable workflow*.
- **Detalhes:** o horário é UTC e o GitHub pode atrasar a execução; se o Firestore não responder, o deploy falha antes do FTP, nada é publicado e o GitHub avisa por e-mail.

## Secrets e Environments

Cada deploy usa um *Environment* do GitHub (`DEV` e `PROD`) com:

- `FTP_HOST`, `FTP_USER` e `FTP_PASSWORD`. Cada usuário FTP é restrito à pasta do próprio ambiente, então o dev não alcança a produção.
- `FIREBASE_SERVICE_ACCOUNT`: JSON de conta de serviço do projeto correspondente, com os papéis *Cloud Datastore Index Admin*, *Firebase Rules Admin* e *Service Usage Consumer*, para publicar índices e regras.

O environment `DEV` tem ainda a **variável** (não secret) `HTPASSWD_PATH`: o caminho do arquivo de senhas do dev no servidor (o `AuthUserFile` que o cPanel mostra em Privacidade de Diretório). O `.htpasswd` fica fora da pasta pública e fora do repositório; sem a variável o deploy de dev falha em vez de publicar o ambiente aberto.

Chaves de serviço nunca entram no repositório (`*-credentials.json` e `bin/venv/` estão no `.gitignore`). Uma chave de administrador da produção já esteve no repositório: foi revogada, mas continua no histórico do Git, então nenhuma chave antiga vale como credencial.

## Diferenças entre dev e produção

- **`APP_ENV`:** o build recebe `--dart-define=APP_ENV=dev|prod`, lido por `AppEnvironment` (`lib/core/utils/environment/`), que escolhe `firebase_options_dev.dart` ou `firebase_options_prod.dart`. **Sem o define (rodando local), o padrão é dev**, para ninguém gravar em produção por engano. Para olhar a produção, use `--dart-define=APP_ENV=prod` de propósito.
- **Faixa "Ambiente de testes":** aparece no topo do site e do painel quando o ambiente não é produção.
- **Analytics:** a tag fica no `web/index.html` entre os marcadores `<!-- analytics:inicio -->` e `<!-- analytics:fim -->`; o `deploy-dev.yml` remove o trecho depois do build e falha se sobrar `googletagmanager`.
- **Indexação:** o deploy de dev gera `robots.txt` com `Disallow: /`, as páginas levam `noindex` e não há `sitemap.xml`. Detalhes em [Indexação no Google](#indexação-no-google).
- **Senha:** só o dev tem; o workflow a acrescenta ao `.htaccess` na hora do deploy.
- **Dados e login:** projetos Firebase separados. As contas do painel são criadas em cada projeto, fora do repositório.

## Indexação no Google

O Flutter desenha tudo num canvas, então o Google só enxerga texto se ele estiver no HTML. Três camadas cuidam disso:

1. **Metas por rota no app** (`PageMetaScope`, `lib/core/utils/browser/page_meta_*.dart`): título, descrição, canonical e Open Graph mudam a cada rota, por JavaScript. O 404 e todo o dev recebem `noindex`.
2. **Páginas pré-renderizadas** (`tool/seo/`, rodado pelos workflows de deploy depois do build): uma cópia do `index.html` por rota pública (home, sobre, contato, 4 temas, 31 subtemas e cada objeto), com título, descrição, canonical, Open Graph, JSON-LD (`WebSite`, `Organization`, `BreadcrumbList`, `LearningResource`) e um bloco de texto da página. `/sobre` vira `sobre.html`; `/tema/subtema/codigo` vira `tema/subtema/codigo.html`; a home reescreve o `index.html`. O bloco de texto fica fora da vista e sai quando o app desenha o primeiro quadro; sem JavaScript ele aparece.
3. **`sitemap.xml` e `robots.txt`:** o sitemap é gerado só em produção, com `lastmod` (data de inserção) nos objetos; o `robots.txt` de produção (`web/robots.txt`) bloqueia `/admin` e aponta para ele.

Os objetos vêm do Firestore pela API REST pública (tema, subtema e conteúdos, cerca de 36 requisições), sem credencial. O gerador usa os mesmos modelos do app (`ThemeDataModel`, `ContentResponseModel`, `RouteMeta`, `SiteCopy`), então rotas, nomes e textos não são copiados para outro lugar. Um objeto que não converte, um Firestore sem resposta ou um endereço fora do padrão interrompem o deploy.

**O que isso não cobre**
- Objetos e edições feitos no painel só entram nas páginas e no sitemap no **próximo deploy de produção**. Depois de cadastrar conteúdo, dispare o `deploy-prod.yml` à mão (aba Actions, *Run workflow*) ou ative o [deploy agendado](#deploy-agendado-de-produção-desativado). Até lá, o link direto do objeto abre normalmente (cai no `index.html` e o app o mostra), só sem a página pré-renderizada.
- Um endereço inexistente responde 200 e o app mostra o 404 com `noindex` (um "soft 404"). Devolver 404 de verdade exigiria rodar o pré-render a cada mudança no painel.
- Nomes e descrições de temas e subtemas vivem no código, não no Firestore.

**Rodar local** (o gerador roda como teste porque os modelos importam o Flutter):

```bash
fvm flutter build web --release --dart-define=APP_ENV=dev
fvm flutter test tool/seo/gerar_seo.dart --dart-define=APP_ENV=dev
```

Rodar de novo sobre o mesmo build falha de propósito (não sobrescreve arquivos do build): refaça o `build web`. Os testes do gerador estão em `test/tool/seo/` e rodam na suíte normal.

**Depois de publicar em produção**

```bash
curl -si https://expogeo.com.br/robots.txt | head -12        # text/plain, com a linha Sitemap
curl -s https://expogeo.com.br/sobre | grep -E "<title>|canonical"
curl -sI https://expogeo.com.br/sobre | head -3              # 200, sem redirecionamento
curl -sI https://expogeo.com.br/sobre/ | head -3             # 301 para /sobre
curl -s https://expogeo.com.br/sitemap.xml | head -8
```

Depois, a Inspeção de URL do Google Search Console numa página de objeto (*Testar URL ativa*, *Ver página testada*) mostra o HTML que o Googlebot recebe.

## Firebase

`firebase.json` lista os dois projetos (`lib/firebase_options_*.dart`) e aponta para `firestore.indexes.json` e `firestore.rules`; `.firebaserc` usa `expogeo-dev` como padrão. O repositório é a fonte: **mudança feita direto no console é desfeita no próximo deploy**.

- **Índice:** grupo de coleções `contents`, campo `originInfo.insertionDate` decrescente (seção "Adicionados recentemente" da Home), como override de campo.
- **Regras:** leitura aberta em `themes`, `subthemes` e `contents`, inclusive por grupo de coleções (`match /{path=**}/contents/{contentId}`), que o catálogo precisa; gravação só com sessão (`request.auth != null`).

## Seed

`./run_seed.sh <dev|prod>` grava os objetos de `bin/content_seed_data.json` (4 temas, 31 subtemas, 190 objetos) no Firestore do ambiente, usando um venv em `bin/venv` com `firebase-admin` e a credencial do projeto (fora do repositório). Para `prod`, o script pede que se digite o id do projeto e sobrescreve objetos com o mesmo id. O JSON sai dos arquivos Dart de `lib/core/content/` por `bin/extract_content_to_json_v2.py`.

## Servidor (HostGator)

- Subdomínio `dev.expogeo.com.br` com pasta própria e usuário FTP restrito a ela; a produção tem o dela.
- O `.htaccess` é **versionado em `web/.htaccess`** e enviado a cada deploy, nos dois ambientes: o que está no servidor é substituído. Não ponha nele blocos gerados pelo cPanel (PHP, Privacidade de Diretório), porque o próximo deploy os apaga; o bloco do PHP 8.2 que a produção tinha foi tirado de propósito (o site é Flutter, sem PHP). No dev, o workflow acrescenta a senha e remove o `FilesMatch` com `Require all granted`, que liberaria JS, imagens e fontes sem senha.
- Regras do arquivo, nesta ordem: `DirectorySlash Off` (sem ele `/tema` redireciona para `/tema/`, onde não há página); `/rota/` vai para `/rota` (301); `/rota` é servido por `rota.html` quando o arquivo existe; o que não é arquivo nem pasta cai no `index.html` (o app usa `usePathUrlStrategy`, e endereços de até 3 segmentos precisam funcionar em link direto); compressão; `Cache-Control: no-cache` em HTML, JS, JSON e WASM, para o navegador não misturar arquivos de builds diferentes, e 7 dias para imagens e fontes.

## Operação e riscos

- Um merge que troca os workflows já dispara o deploy novo: confira se os segredos do environment existem antes.
- O primeiro deploy por FTPS pode reenviar tudo (o arquivo de estado da action não bate com o servidor). É esperado e não derruba o site.
- Rodar local sem define mostra os dados do `expogeo-dev`.
- Depois de publicar, confira faixa (só no dev), Firebase do ambiente, `robots.txt` e Analytics.
- O pré-render lê o Firestore durante o deploy: se ele não responder, o deploy falha antes do FTP e nada é publicado. Basta rodar o deploy de novo.

## Pendências manuais

- **Redesign na produção:** a `main` ainda não recebeu as mudanças da `develop`. No merge `develop` → `main`, conferir que as regras publicadas incluem a leitura por grupo de coleções (leitura do catálogo, Home com recentes) e que os objetos de produção têm o mesmo formato dos do dev (`preservationAction`, tipo e formato).
- **Cadastro no Firebase Auth:** as regras só pedem sessão para gravar, sem papéis. Confirmar, nos dois projetos, que a criação de conta por conta própria está desligada (Authentication, Configurações, Ações do usuário); as contas do painel são criadas à mão. O teste de cadastro sem criar conta não é possível daqui.
- **Indexação em produção:** o pré-render foi verificado só no dev (rotas de 1 a 3 segmentos, redirecionamento de barra final, `main.dart.js` com senha, `/assets` sem listagem e segunda visita de `/sobre`, em 2026-11-11). Em produção falta rodar, depois do primeiro deploy, o roteiro de `curl` de "Indexação no Google" (robots, `/sobre`, `/sobre/`, sitemap e uma página de objeto) e o Teste de Resultados Avançados do Google numa página de objeto.
- **Search Console:** cadastrar `expogeo.com.br`, enviar o `sitemap.xml` e pedir a indexação das URLs principais depois do primeiro deploy de produção com o pré-render.
- **Proteção das branches** `main` e `develop` e o teste ponta a ponta de um PR por `develop` e `main`: ações no GitHub, não conferidas aqui.
- **Prévia de compartilhamento** (WhatsApp e similares) com a imagem de `web/og-image.png`: conferir depois do deploy no dev.
- **Deploy agendado:** ativar depois do primeiro deploy de produção com o pré-render ([Deploy agendado de produção](#deploy-agendado-de-produção-desativado)). Se ele deixar de rodar, reativar em Actions.
