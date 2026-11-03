# 016. Limpeza: código, tokens, fontes, pacotes e assets sem uso

- **Status:** aprovada
- **Item do planejamento:** Fase 5 (limpeza)
- **Protótipo:** não se aplica
- **Criada em:** 2026-10-27

> Referência no Observatório: `docs/specs/027-remocao-codigo-legado/` e `028-assets-sem-uso/`. Aqui as duas vão juntas porque o volume é menor.

## Objetivo
Tirar do projeto tudo o que o redesign deixou sem uso, para o código ficar menor, o build mais leve e ninguém usar por engano um token ou componente antigo. Quem usa o site **não vê mudança**.

## Situação atual (prevista ao fim da Fase 4)
- Tokens antigos de cor, tipografia e gradiente em `lib/core/theme/` (laranja `#F97316` em botões, cores por tipo em `ContentType.color`) ainda declarados.
- Fonte Aleo em `assets/fonts/` e no `pubspec.yaml`; `google_fonts` como dependência.
- `num_extension` (`core/utils/extensions/num_extension.dart`), hoje em 31 arquivos.
- Pacotes possivelmente sem uso: `carousel_slider`, `flutter_staggered_grid_view`, `youtube_player_iframe`, `syncfusion_flutter_pdfviewer`, `font_awesome_flutter`, `flutter_animate`, `cached_network_image`, `flutter_svg`, `http`.
- Componentes antigos: `themes_row`, `theme_card`, `home_banner`, `logo`, `subtheme_card`, `subtheme_banner`, `subtheme_content`, `content_card`, `content_grid`, `content_form_dialog`, `content_list`, `theme_subtheme_selector`, botões e campos antigos, `ContentPaginationStore` e a paginação por cursor do `content_theme_datasource`.
- PNGs das ilustrações substituídos pelos WebP (spec 003); `REFACTORING_SUMMARY.md` em `features/theme/`.
- `README.md` com descrição desatualizada (carrossel, paginação, "criar, editar e deletar temas").

## Comportamento

### Código
- Remover componentes, stores, datasources e métodos que nenhuma tela usa, conferindo por busca no código, não por suposição.
- Remover os tokens antigos e a fonte Aleo depois de confirmar que nada os referencia; renomear os tokens novos para o nome "oficial" se tiverem ficado com prefixo provisório.
- Remover `num_extension` e trocar o que restar pelos tamanhos por faixa.
- Regerar os arquivos do MobX/Freezed que mudarem.

### Pacotes
- Tirar do `pubspec.yaml` os pacotes sem uso. Cada remoção é conferida com `analyze` e build.

### Assets
- Remover os PNGs substituídos e qualquer arquivo de `assets/` sem referência no código.
- `pubspec.yaml` declara só o que fica.

### Documentação
- Atualizar o README (funcionalidades, arquitetura e comandos) para o estado depois do redesign.
- Apagar `REFACTORING_SUMMARY.md` se não tiver mais valor.

## Estados
Não se aplica.
- **Casos de borda:** builds locais antigos podem precisar de `fvm flutter clean` depois de tirar plugins (lição do Observatório); asset usado só por nome montado em texto (ex.: `'$nome.webp'`) precisa ser conferido à mão.

## Responsivo
Não se aplica; as telas ficam iguais.

## Acessibilidade
Não se aplica; nada visível muda.

## Dados e regras de negócio
- Nenhum dado, rota ou regra muda.
- Conteúdo de seed em `lib/core/content/` e `bin/` **fica** (usado pelos scripts de seed).

## Critérios de aceite
- [ ] `fvm flutter analyze` sem avisos; `fvm flutter build web --release` passa.
- [ ] Nenhuma referência a Aleo, `google_fonts`, `num_extension` ou aos tokens antigos no código.
- [ ] Os pacotes removidos não aparecem no `pubspec.yaml` nem em `import`.
- [ ] Nenhum arquivo de `assets/` sem referência; os PNGs substituídos saíram.
- [ ] O tamanho de `build/web` diminui em relação ao build anterior à limpeza (anotar os dois números no `verificacao.md`).
- [ ] Home, temas, subtemas, objeto, Sobre, Contato, 404, login, painel e editor abrem e funcionam como antes em 390, 768 e 1280 px.
- [ ] O README descreve o site redesenhado.

## Fora do escopo
- Testes automatizados (não há pasta `test/`; pode virar trabalho próprio).
- Mudanças de dados ou dos scripts de seed.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
