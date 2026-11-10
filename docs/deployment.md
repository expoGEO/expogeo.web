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
| `deploy-dev.yml` | push na `develop` ou manual | Regras e índices do Firestore, build com `APP_ENV=dev`, remoção do Analytics, `robots.txt` bloqueando indexação e FTP para o dev |
| `deploy-prod.yml` | push na `main` ou manual | Regras e índices do Firestore, build com `APP_ENV=prod` e FTP para produção |

O filtro de "só docs" fica em lugares diferentes para os dois casos:

- **Deploys:** `paths-ignore` (`docs/**`, `**.md`, `.claude/**`, `.vscode/**`, `bin/**`, `ci.yml`, `analysis_options.yaml`). O deploy manual (`workflow_dispatch`) ignora o filtro.
- **CI:** o job `mudancas` compara com a base do PR e só deixa `validar` rodar se algo fora de `docs/`, `.claude/`, `.vscode/`, `bin/`, `deploy-*.yml` e `*.md` mudou. Job pulado por `if` conta como aprovado, então o check obrigatório não trava; `paths-ignore` no gatilho faria o check nunca reportar.

Comum aos três:

- Versão do Flutter lida do `.fvmrc` com `jq`; `actions/checkout@v4`, `subosito/flutter-action@v2` com cache; sem `flutter clean`.
- Só `build/web/` é enviado, num passo de FTP (`SamKirkland/FTP-Deploy-Action@4.3.0`, FTPS na porta 21).
- `concurrency` por ambiente: dois deploys do mesmo ambiente não rodam juntos.
- Nos deploys, regras e índices do Firestore são publicados **antes** do site, porque o código depende deles. As regras do repositório substituem as do projeto; os índices só são criados e atualizados (sem `--force`).

## Secrets e Environments

Cada deploy usa um *Environment* do GitHub (`DEV` e `PROD`) com:

- `FTP_HOST`, `FTP_USER` e `FTP_PASSWORD`. Cada usuário FTP é restrito à pasta do próprio ambiente, então o dev não alcança a produção.
- `FIREBASE_SERVICE_ACCOUNT`: JSON de conta de serviço do projeto correspondente, com os papéis *Cloud Datastore Index Admin*, *Firebase Rules Admin* e *Service Usage Consumer*, para publicar índices e regras.

Chaves de serviço nunca entram no repositório (`*-credentials.json` e `bin/venv/` estão no `.gitignore`). Uma chave de administrador da produção já esteve no repositório: foi revogada, mas continua no histórico do Git, então nenhuma chave antiga vale como credencial.

## Diferenças entre dev e produção

- **`APP_ENV`:** o build recebe `--dart-define=APP_ENV=dev|prod`, lido por `AppEnvironment` (`lib/core/utils/environment/`), que escolhe `firebase_options_dev.dart` ou `firebase_options_prod.dart`. **Sem o define (rodando local), o padrão é dev**, para ninguém gravar em produção por engano. Para olhar a produção, use `--dart-define=APP_ENV=prod` de propósito.
- **Faixa "Ambiente de testes":** aparece no topo do site e do painel quando o ambiente não é produção.
- **Analytics:** a tag fica no `web/index.html` entre os marcadores `<!-- analytics:inicio -->` e `<!-- analytics:fim -->`; o `deploy-dev.yml` remove o trecho depois do build e falha se sobrar `googletagmanager`.
- **Indexação:** o deploy de dev gera `robots.txt` com `Disallow: /`.
- **Dados e login:** projetos Firebase separados. As contas do painel são criadas em cada projeto, fora do repositório.

## Firebase

`firebase.json` lista os dois projetos (`lib/firebase_options_*.dart`) e aponta para `firestore.indexes.json` e `firestore.rules`; `.firebaserc` usa `expogeo-dev` como padrão. O repositório é a fonte: **mudança feita direto no console é desfeita no próximo deploy**.

- **Índice:** grupo de coleções `contents`, campo `originInfo.insertionDate` decrescente (seção "Adicionados recentemente" da Home), como override de campo.
- **Regras:** leitura aberta em `themes`, `subthemes` e `contents`, inclusive por grupo de coleções (`match /{path=**}/contents/{contentId}`), que o catálogo precisa; gravação só com sessão (`request.auth != null`).

## Seed

`./run_seed.sh <dev|prod>` grava os objetos de `bin/content_seed_data.json` (4 temas, 31 subtemas, 190 objetos) no Firestore do ambiente, usando um venv em `bin/venv` com `firebase-admin` e a credencial do projeto (fora do repositório). Para `prod`, o script pede que se digite o id do projeto e sobrescreve objetos com o mesmo id. O JSON sai dos arquivos Dart de `lib/core/content/` por `bin/extract_content_to_json_v2.py`.

## Servidor (HostGator)

- Subdomínio `dev.expogeo.com.br` com pasta própria e usuário FTP restrito a ela; a produção tem o dela.
- O `.htaccess` de cada ambiente vive **só no servidor** (o deploy apaga apenas o que ele mesmo enviou): reescrita de rotas desconhecidas para `index.html` (o app usa `usePathUrlStrategy`, e endereços de até 3 segmentos precisam funcionar em link direto), `Cache-Control: no-cache` para o navegador não misturar arquivos de builds diferentes e, no dev, a senha (`.htpasswd`, pelo cPanel).

## Operação e riscos

- Um merge que troca os workflows já dispara o deploy novo: confira se os segredos do environment existem antes.
- O primeiro deploy por FTPS pode reenviar tudo (o arquivo de estado da action não bate com o servidor). É esperado e não derruba o site.
- Rodar local sem define mostra os dados do `expogeo-dev`.
- Depois de publicar, confira faixa (só no dev), Firebase do ambiente, `robots.txt` e Analytics.

## Pendências manuais

- **Redesign na produção:** a `main` ainda não recebeu as mudanças da `develop`. No merge `develop` → `main`, conferir que as regras publicadas incluem a leitura por grupo de coleções (leitura do catálogo, Home com recentes) e que os objetos de produção têm o mesmo formato dos do dev (`preservationAction`, tipo e formato).
- **Servidor do dev:** em 2026-11-06, qualquer endereço além de `/` em `dev.expogeo.com.br` dava o 404 da HostGator e a raiz abria sem senha: faltava a reescrita e a senha no `.htaccess`. Não reconferido; depois de corrigir, testar também endereços de 3 segmentos (`/natureza-meio-ambiente/biomas/nma-bio-01`).
- **Proteção das branches** `main` e `develop` e o teste ponta a ponta de um PR por `develop` e `main`: ações no GitHub, não conferidas aqui.
- **Prévia de compartilhamento** (WhatsApp e similares) com a imagem de `web/og-image.png`: conferir depois do deploy no dev.
