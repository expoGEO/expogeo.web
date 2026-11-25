# ExpoGeo Web

Leia [README.md](README.md) e [docs/architecture.md](docs/architecture.md) antes de mexer no código; deploy e workflows estão em [docs/deployment.md](docs/deployment.md).

## Convenções

- **Idioma:** tudo em português do Brasil: documentação, comentários, mensagens de commit e de PR, e nos workflows do GitHub Actions os títulos dos passos (`name:`) e as mensagens de log/erro (`echo`, `::error::`). Termos técnicos (`build`, `deploy`, `Firestore`) ficam como estão.
- **Passos de workflow:** verbo no infinitivo ("Baixar o código", "Compilar o app Flutter Web").
- **Fluxo de branches:** PR para `develop`; depois PR de `develop` para `main`. Nunca faça push direto nelas.
