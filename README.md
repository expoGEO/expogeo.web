# expoGEO

Curadoria digital do saber geográfico: site de objetos digitais organizados em 4 temas e seus subtemas, feito em Flutter Web com Firebase (Firestore e Auth), com painel administrativo para gerenciar os objetos. É uma sub-marca do Observatório do Ensino de História e Geografia (UFU) e compartilha a base visual do repositório `observatorio_geo_hist`.

## Requisitos

- [FVM](https://fvm.app/) com o Flutter da versão definida em [.fvmrc](.fvmrc)
- Acesso aos projetos Firebase `expogeo-dev` (padrão local) e `expogeo-fad33` (produção)

## Como rodar

```sh
fvm install
fvm flutter pub get
fvm flutter run -d chrome
```

Sem `--dart-define`, o app usa o ambiente de dev. Para apontar para a produção: `--dart-define=APP_ENV=prod`.

Os stores MobX e os modelos Freezed usam código gerado. Após alterá-los, rode:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

## Build, testes e formatação

```sh
fvm flutter build web --release
fvm flutter analyze
fvm flutter test
fvm dart format lib test
```

Numa pasta com acento no caminho, `analyze`, `test` e `format` falham ou ignoram a configuração; rode numa cópia com caminho ASCII.

## Seed do Firestore

```sh
./run_seed.sh dev    # ou prod, que pede confirmação
```

Grava os objetos de `bin/content_seed_data.json` e exige o venv e a credencial descritos pelo próprio script.

## Deploy

Push na `develop` publica o ambiente de testes e push na `main` publica a produção, pelo GitHub Actions (FTPS para a HostGator). Detalhes em [docs/deployment.md](docs/deployment.md).

## Documentação

- [Arquitetura](docs/architecture.md): estrutura, camadas, design system, rotas, catálogo e convenções
- [Painel administrativo](docs/admin-panel.md): login, lista, editor e formato dos dados
- [Deploy](docs/deployment.md): ambientes, workflows, Firebase e servidor
- [Histórico do redesign](docs/redesign-history.md): decisões, ressalvas em aberto e ideias futuras
- [Especificações (SDD)](docs/specs/README.md): fluxo de spec, plano, implementação e verificação
