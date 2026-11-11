# Plano da 019. Pré-render por rota para indexação

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-11-10

## Abordagem
Depois do `flutter build web`, uma etapa do deploy roda um gerador em Dart que lê o `build/web/index.html` já pronto e produz, ao lado dele, uma cópia por rota pública (`sobre.html`, `representacoes-espaciais.html`, `representacoes-espaciais/historia-cartografia/re-hc-01.html` etc.) mais o `sitemap.xml`. Cada cópia troca `<title>`, `description`, `canonical`, `og:*` e `twitter:*`, injeta o JSON-LD e um bloco de texto da página. O app Flutter não muda: ele carrega e assume a rota como hoje.

O gerador é Dart, e não Python ou Node, por três motivos: reaproveita o que o app já tem (`ThemeDataModel`, `ThemeEnum`, `SubthemeEnum`, `ContentResponseModel.fromJson`, `referenceCodeSlug`, `PageMeta`, `summarize`), então slugs, nomes e descrições não são copiados para outro lugar; lê os objetos do Firestore com o mesmo parser do app; e fica testável com `flutter test`. Como os modelos importam `package:flutter/material.dart`, o gerador não roda com `dart run`: ele roda com `flutter test tool/seo/gerar_seo.dart`, que o runner do CI já tem. Os testes do gerador ficam em `test/tool/seo/`, e o arquivo do gerador fica fora de `test/`, então a suíte normal não o executa.

Os objetos vêm da API REST pública do Firestore (`themes/{tema}/subthemes/{subtema}/contents`, cerca de 36 requisições, sem credencial), com os valores tipados convertidos para o mesmo mapa simples que o app recebe. Hoje todos os campos usados são texto, então `ContentResponseModel.fromJson` serve sem adaptação. Qualquer falha (rede, resposta inválida, zero objetos, objeto que não converte) interrompe o deploy antes do envio por FTP.

No servidor, uma regra nova no `.htaccess` serve `/sobre` a partir de `sobre.html` quando o arquivo existe. O resto continua como está: o que não tem arquivo cai no `index.html` com 200, e o app mostra a página do objeto ou o 404 com `noindex`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `lib/core/utils/constants/site_copy.dart` | Textos de home, sobre e contato usados pela página e pelo gerador, sem duplicar |
| Alterar | `lib/features/home/pages/home_page.dart`, `lib/features/about/pages/about_page.dart`, `lib/features/contact/pages/contact_page.dart` | Passam a ler os textos de `site_copy.dart` |
| Criar | `tool/seo/firestore_reader.dart` | Lê os objetos pela API REST e converte para o mapa que o app usa |
| Criar | `tool/seo/site_pages.dart` | Monta a lista de páginas (rota, `PageMeta`, texto, migalhas, tipo) a partir do código e dos objetos |
| Criar | `tool/seo/html_page.dart` | Gera o HTML de uma página a partir do `index.html` do build (metas, bloco de texto, JSON-LD, escape) |
| Criar | `tool/seo/json_ld.dart` | Monta o JSON-LD (`WebSite`, `Organization`, `BreadcrumbList`, `LearningResource`) |
| Criar | `tool/seo/sitemap.dart` | Monta o `sitemap.xml` |
| Criar | `tool/seo/gerar_seo.dart` | Ponto de entrada: lê, gera, grava e falha com mensagem clara |
| Criar | `test/tool/seo/*_test.dart` | Testes de cada peça, com respostas falsas do Firestore |
| Alterar | `web/index.html` | Estilo e script do bloco de texto: oculto na tela, legível sem JavaScript, removido quando o app desenha |
| Alterar | `web/.htaccess` | Regra que serve `rota.html` em `/rota` antes do fallback |
| Alterar | `web/robots.txt` | Linha `Sitemap:` de produção (o dev já sobrescreve o arquivo) |
| Alterar | `.github/workflows/deploy-prod.yml`, `deploy-dev.yml` | Passo que roda o gerador depois do build e antes do envio |
| Alterar | `docs/deployment.md`, `docs/architecture.md` | `.htaccess` versionado, pré-render e sitemap |

## Decisões técnicas
- **Gerador em Dart via `flutter test`:** alternativa foi um script Python como o do seed. Descartei porque exigiria copiar slugs, nomes e descrições de temas e subtemas para fora do código, e eles já mudam em Dart. O custo é rodar sob `flutter test`, que é uma convenção comum e não depende de pacote novo.
- **Texto da home, sobre e contato em `site_copy.dart`:** hoje parte desses textos está dentro dos widgets. Extrair para constantes evita que o bloco para o Google e a tela divirjam. É uma refatoração pequena, sem mudança visual.
- **Arquivos `.html` ao lado, e não pastas com `index.html`:** com pasta, o Apache redireciona `/sobre` para `/sobre/` e o canonical sem barra deixaria de bater. Com `sobre.html` e a regra no `.htaccess`, o endereço fica sem barra.
- **A home é o próprio `index.html`:** o gerador a atualiza no lugar (bloco de texto e JSON-LD), em vez de criar outro arquivo.
- **Bloco de texto oculto, e não escondido por `display: none`:** fica fora da vista com o mesmo recurso do texto "Carregando" (`.oculto`), some quando o app desenha o primeiro quadro (o script de carregamento já ouve `flutter-first-frame`) e fica visível sem JavaScript (`<noscript>`). O conteúdo é o mesmo que a pessoa vê no app, para não configurar conteúdo exclusivo para o buscador.
- **Dev também gera as páginas:** com `noindex`, sem `sitemap.xml` e sob a senha, para testar a regra do `.htaccess` e o resultado antes de produção. O dev lê o Firestore do dev.
- **Leitura hierárquica, e não por grupo de coleções:** as regras antigas de produção negam a consulta de grupo; o percurso tema, subtema e conteúdos funciona com as regras de antes e de depois do deploy.
- **Tentativas:** até 3 por requisição, com pausa curta, para tolerar uma falha momentânea sem publicar nada incompleto.
- **Escape:** todo texto vindo do Firestore passa por escape de HTML e, no JSON-LD, também de `</script>`, `<` e `&`.

## Dependências e geração de código
Nenhum pacote novo. Sem `build_runner`. Sem mudança nas rotas do app. O gerador usa `dart:io` e `dart:convert`, além do que o projeto já tem. O ponto de entrada em `tool/seo/` entra na análise (`flutter analyze`) e na checagem de formatação do CI.

## Riscos e cuidados
- **Regra do `.htaccess` e redirecionamento:** onde existe a pasta `representacoes-espaciais/` e o arquivo `representacoes-espaciais.html`, o Apache pode redirecionar `/representacoes-espaciais` para `/representacoes-espaciais/`. A regra vai antes do fallback e usa o arquivo `.html`; se mesmo assim houver redirecionamento, o plano de reserva é `DirectorySlash Off`. Conferir com `curl -I` no dev antes de produção (critério 4). *Confirmado num Apache local: sem o plano de reserva, `/tema` e `/subtema` davam 301 para `/tema/` (e 404). Adotados `DirectorySlash Off` e a regra de barra final para sem barra.*
- **Service worker do Flutter:** pode guardar o app shell. Conferir no dev que uma segunda visita a `/sobre` continua abrindo certo.
- **Textos diferentes entre bloco e tela:** o bloco de cada objeto reproduz título, descrição, assuntos, autoria e subtema; se a ficha do app mudar, o bloco precisa acompanhar. Os testes comparam com os campos do modelo, não com a tela.
- **Dados em produção:** 3 objetos têm ID de documento aleatório; o gerador usa o campo `id`, como o app. Conferir esses três no resultado.
- **Deploy interrompido por dado ruim:** um objeto que não converte falha o deploy inteiro. É o comportamento pedido (não publicar incompleto), e a mensagem de erro deve apontar o objeto.
- **Mudança no CI:** o merge que altera os workflows já dispara o deploy; os segredos de FTP e Firebase do ambiente já existem.
- **Telas que compartilham os textos extraídos:** home, sobre e contato; conferir os testes e as três telas nas larguras 390, 768 e 1280.

## Como conferir
- `fvm flutter analyze` e `fvm dart format --set-exit-if-changed` nos arquivos novos.
- `fvm flutter test` (suíte inteira) e `fvm flutter test test/tool/seo`.
- Local: `fvm flutter build web --release --dart-define=APP_ENV=dev` e `fvm flutter test tool/seo/gerar_seo.dart --dart-define=APP_ENV=dev`; abrir os arquivos gerados e olhar o HTML.
- No dev (com senha): `curl -u usuário -si https://dev.expogeo.com.br/sobre | head`, `curl -I` para conferir a ausência de redirecionamento, abrir rotas de 1, 2 e 3 segmentos no navegador.
- Em produção: roteiro de `curl` da spec e Teste de Resultados Avançados do Google numa página de objeto.
