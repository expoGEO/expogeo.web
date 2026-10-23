# CI/CD e ambientes: planejamento

Plano para separar dev e produção e validar cada PR, no mesmo modelo do Observatório (`../observatorio_geo_hist/docs/deploy-ambientes.md`). Ao concluir, este documento vira `docs/deploy-ambientes.md`, que descreve o estado final, e o item 0.0 do [planejamento do redesign](../redesign/planejamento.md) é marcado como concluído.

- **Situação:** decisões fechadas em 2026-10-23. Nenhuma etapa iniciada.

---

## 1. Situação atual

| Ponto | Hoje |
|---|---|
| Branches | Só `main`. Todo push nela publica o site |
| Workflow | Um só, [deploy.yml](../../.github/workflows/deploy.yml): `flutter clean`, build e FTP para a HostGator. Flutter fixo em `3.35.5` (não lê o `.fvmrc`), `actions/checkout@v2`, FTP sem TLS |
| Validação de PR | Nenhuma: sem `analyze`, sem conferência de formato, sem build antes do merge |
| Firebase | Um projeto (`expogeo-fad33`) fixo em `lib/firebase_options.dart`. Sem `firebase.json`, sem índices nem regras do Firestore no repositório |
| Analytics | Tag do Google Analytics (`G-VGGG37TXF8`) direto no `web/index.html`: contaria acessos de qualquer ambiente |
| Seed | `run_seed_production.sh` com o projeto de produção fixo no script |
| Segredos no git | `firebase-credentials.json` (**chave privada de conta de serviço**) e `.env.firestore` versionados desde o commit `5de1ce5` |
| Lixo no git | `bin/venv/` versionado (2.096 arquivos) |

---

## 2. Decisões

| Tema | Decisão |
|---|---|
| Ambientes | **Dev** e **produção**, com dados, login e endereços separados |
| Firebase | Projeto novo para o dev (ex.: `expogeo-dev`), com Firestore e Auth próprios. Produção continua no `expogeo-fad33`. O app não usa Storage |
| Endereço do dev | `dev.expogeo.com.br`, na mesma HostGator, com senha (`.htpasswd`) e `robots.txt` bloqueando indexação |
| Dados do dev | Seed com os objetos do repositório (`bin/content_seed_data.json`), pelo script de seed apontado para o projeto de dev |
| Aprovação de produção | Sem aprovação manual no GitHub: o merge do PR `develop` → `main` é a aprovação |
| Analytics | Só em produção |

---

## 3. Estado final

### Ambientes
| Ambiente | Branch | Workflow | Endereço | Firebase |
|---|---|---|---|---|
| Dev | `develop` | `deploy-dev.yml` | `dev.expogeo.com.br` | `expogeo-dev` |
| Produção | `main` | `deploy-prod.yml` | `expogeo.com.br` | `expogeo-fad33` |

### Fluxo de branches
```
feature/*  ──PR──▶  develop  ──PR──▶  main
                  (deploy dev)      (deploy prod)
```
1. Trabalho em `feature/*`, `fix/*`, `refactor/*` ou `docs/*`, saindo da `develop`.
2. PR para `develop`: o CI valida. O merge publica o dev.
3. Depois de testar no dev, PR `develop` → `main`. O merge publica a produção.
4. Hotfix: `hotfix/*` saindo da `main`, PR para `main` e depois para a `develop`.

`main` e `develop` protegidas: só entram por PR, com o check **validar** do CI obrigatório.

### Workflows
| Arquivo | Gatilho | O que faz |
|---|---|---|
| `ci.yml` | PR para `develop` ou `main` | `pub get`, conferência de formato, `analyze` e `build web`. Não publica. PR só com `docs/`, `*.md`, `.claude/`, `.vscode/`, `bin/` ou `deploy-*.yml` pula a validação (job pulado por `if` conta como aprovado, então o check obrigatório não trava) |
| `deploy-dev.yml` | push na `develop` ou manual | Índices do Firestore, build com `APP_ENV=dev`, sem a tag do Analytics, `robots.txt` bloqueando tudo e FTP para o dev |
| `deploy-prod.yml` | push na `main` ou manual | Índices do Firestore, build com `APP_ENV=prod` e FTP para produção |

Comum aos três, como no Observatório:
- Versão do Flutter lida do `.fvmrc` com `jq`; `actions/checkout@v4`; cache do Flutter ligado; sem `flutter clean`.
- Deploys com `paths-ignore` para o que não entra no build (`docs/**`, `**.md`, `.claude/**`, `.vscode/**`, `bin/**`, `ci.yml`, `analysis_options.yaml`). O deploy manual (`workflow_dispatch`) ignora o filtro.
- Só `build/web/` vai para o servidor, por FTPS, num passo só (`SamKirkland/FTP-Deploy-Action`).
- `concurrency` por ambiente: dois deploys do mesmo ambiente não rodam juntos.

### Diferenças entre dev e produção no app
- **`APP_ENV`:** o build recebe `--dart-define=APP_ENV=dev|prod`, lido por um `AppEnvironment` em `lib/core/utils/`. Ele escolhe o `FirebaseOptions` (`firebase_options_dev.dart` ou `firebase_options_prod.dart`). Sem o define (rodando local), o padrão é **dev**, para ninguém gravar em produção por engano.
- **Faixa "Ambiente de testes"** no topo do site e do painel quando `APP_ENV=dev`, como no Observatório.
- **Analytics:** a tag fica no `web/index.html` entre marcadores (`<!-- analytics:inicio -->` … `<!-- analytics:fim -->`). O `deploy-dev.yml` remove esse trecho depois do build.

### GitHub
Environments `DEV` e `PROD`, cada um com `FTP_HOST`, `FTP_USER`, `FTP_PASSWORD` e `FIREBASE_SERVICE_ACCOUNT` (JSON de conta de serviço do projeto correspondente, com os papéis *Cloud Datastore Index Admin* e *Service Usage Consumer*, só para publicar índices). Os segredos `FTP_*` de nível de repositório, usados pelo `deploy.yml` atual, saem no fim.

### HostGator
- Subdomínio `dev.expogeo.com.br` com pasta própria e **usuário FTP restrito a ela**: o dev não alcança a produção, e vice-versa.
- `.htaccess` de cada ambiente, mantido só no servidor (o deploy não apaga o que não enviou):
  - reescrita de rotas desconhecidas para `index.html` (o app usa `usePathUrlStrategy`);
  - `Cache-Control: no-cache`, para o navegador não misturar arquivos de builds diferentes;
  - no dev, a senha (`.htpasswd`, pelo cPanel).

### Firebase
- `firebase.json` com os dois projetos e `firestore.indexes.json` versionados. Os deploys publicam os índices antes do site.
- Índice já previsto pelo redesign: grupo de coleções `contents`, `originInfo.insertionDate` ↓ (seção "Adicionados recentemente" da Home).
- Regras do Firestore exportadas do console para `firestore.rules` e aplicadas aos dois projetos, para o dev ter as mesmas permissões da produção. A publicação automática das regras fica fora deste plano: elas seguem mudando pelo console até haver motivo para automatizar.

---

## 4. Etapas

A ordem importa: a segurança vem primeiro, a infraestrutura manual antes dos workflows, e a `develop` só passa a valer quando o dev estiver publicando.

| # | Etapa | Quem faz | Pronto quando |
|---|---|---|---|
| E0 | **Segurança.** Revogar a chave de `firebase-credentials.json` no console do Google Cloud e gerar outra, guardada fora do repositório. Remover do git `firebase-credentials.json`, `.env.firestore` e `bin/venv/`, e incluí-los no `.gitignore`. Não reescrever o histórico: com a chave revogada, a cópia antiga deixa de valer | Pessoa (console) + repositório | Chave antiga revogada; `git ls-files` sem os três |
| E1 | **Projeto Firebase de dev.** Criar `expogeo-dev`, ligar Auth por e-mail e senha, criar as contas de teste do painel, criar o Firestore e copiar as regras de produção | Pessoa (console) | Login no painel funciona com o dev |
| E2 | **Hospedagem do dev.** Subdomínio, usuário FTP restrito, `.htaccess` com reescrita, cache e senha | Pessoa (cPanel) | `dev.expogeo.com.br` pede senha e serve uma página de teste |
| E3 | **GitHub.** Environments `DEV` e `PROD` com os segredos; contas de serviço de índices nos dois projetos | Pessoa (GitHub e console) | Segredos cadastrados nos dois environments |
| E4 | **App por ambiente.** `AppEnvironment`, `firebase_options_dev.dart` e `_prod.dart` (via `flutterfire configure`), faixa de ambiente, marcadores do Analytics, `firebase.json` e `firestore.indexes.json`. Vira uma spec no fluxo SDD | Repositório | `fvm flutter run` sem define abre no dev com a faixa; build com `APP_ENV=prod` abre sem faixa |
| E5 | **Seed parametrizado.** `run_seed_production.sh` vira `run_seed.sh <dev\|prod>`, que pede confirmação explícita para `prod`. Popular o `expogeo-dev` | Repositório + pessoa (roda o script) | Dev com os mesmos 190 objetos do repositório |
| E6 | **Workflows.** `ci.yml`, `deploy-dev.yml` e `deploy-prod.yml` no lugar do `deploy.yml` | Repositório | CI roda no PR desta etapa |
| E7 | **Branches.** Criar a `develop` a partir da `main`; proteger as duas com PR obrigatório e o check **validar** | Pessoa (GitHub) | Push direto na `main` é recusado |
| E8 | **Ponta a ponta.** Um PR pequeno passa por `develop` (deploy dev) e depois `main` (deploy prod). Conferir faixa, Firebase, `robots.txt` e Analytics nos dois | Repositório + pessoa | Os dois ambientes publicados pelos workflows novos |
| E9 | **Documentação.** Este plano vira `docs/deploy-ambientes.md`; `README.md` e `docs/specs/README.md` passam a apontar o fluxo `develop` → `main` | Repositório | Docs sem menção ao fluxo antigo |

---

## 5. Riscos e cuidados
- **Chave exposta:** a chave de `firebase-credentials.json` dá acesso de administrador ao Firebase de produção e está no histórico do GitHub. Revogar é urgente e independe do resto deste plano.
- **Merge que troca os workflows:** o PR da E6 para a `main` já dispara o `deploy-prod.yml` novo. Os segredos do environment `PROD` (E3) precisam existir antes do merge; se faltarem, o deploy falha e o site continua no ar como estava.
- **Primeiro deploy com FTPS:** o arquivo de estado da action (`.ftp-deploy-sync-state.json`) pode não bater com o servidor, e o primeiro envio pode reenviar tudo. É esperado e não derruba o site.
- **Rodar local sem define:** com o padrão dev, quem roda o app local passa a ver os dados do `expogeo-dev`. Para olhar produção, é preciso `--dart-define=APP_ENV=prod` de propósito.
- **Painel no dev:** as contas do Auth de produção não existem no dev. As contas de teste ficam fora do repositório.

## 6. Fora do escopo
- Testes automatizados (ainda não há pasta `test/`).
- Publicação automática das regras do Firestore.
- Previews por PR (um endereço por branch).
- Trocar a HostGator por outra hospedagem.
