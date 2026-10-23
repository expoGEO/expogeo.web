# Especificações (SDD)

Cada feature maior tem uma pasta `docs/specs/NNN-nome-curto/` com três arquivos, criados em sequência pelas skills do projeto.

| Arquivo | Criado por | Conteúdo |
|---|---|---|
| `spec.md` | `/sdd-spec` | **O quê e por quê**: comportamento, estados, critérios de aceite, fora do escopo |
| `plan.md` | `/sdd-plan` | **Como**: abordagem técnica, arquivos afetados, decisões e riscos |
| `tasks.md` | `/sdd-plan` (atualizado por `/sdd-implement`) | Lista de tarefas ordenadas, com o progresso |
| `verificacao.md` | `/sdd-verify` | Resultado da conferência contra os critérios de aceite |

## Fluxo

```
planejamento.md ──► /sdd-spec ──► (aprovação) ──► /sdd-plan ──► /sdd-implement ──► /sdd-verify
     (item)          spec.md                      plan.md         código +           verificacao.md
                                                  tasks.md        tasks.md marcadas
```

Em cada etapa a skill **para** e espera a sua aprovação antes de seguir.

**Modo autônomo:** `/sdd-fase <fase ou itens>` (ex.: `/sdd-fase Fase 1`) roda o fluxo inteiro sem paradas. Divide a fase em specs, faz cada etapa numa sessão separada, corrige o que a verificação achar (até 2 tentativas por problema), faz commits por entrega numa branch própria da fase (`refactor/redesign-<fase>`, criada a partir da branch de integração) e termina com um resumo. O andamento fica em `docs/specs/execucao-<fase>.md`, que também serve para retomar se a execução for interrompida. No encerramento, o resumo vai para `historico-redesign.md` e o arquivo de execução é apagado.

## Regras
- Numeração sequencial de três dígitos (`001`, `002`...). O nome é curto, em `kebab-case`, sem acentos.
- A spec tem um **status** no topo: `rascunho`, `aprovada`, `implementada` ou `verificada`.
- Uma spec só vai para o plano com **zero perguntas em aberto** e status `aprovada`.
- Se, durante a implementação, algo precisar divergir da spec, **atualize a spec primeiro** (e registre em "Histórico de mudanças"), depois o código.
- Cada critério de aceite deve poder ser conferido como "passou" ou "não passou".
- Ao final, o item correspondente no [planejamento](../redesign/planejamento.md) é marcado como concluído.

## Modelo de status no planejamento
Ao concluir uma spec, acrescente ao item do planejamento a referência: `→ specs/001-nome`.

## Quando usar
Use para features de mais ou menos meio dia para cima ou que mudem várias telas. Correções pequenas e ajustes pontuais dispensam spec.

---

## Referências do projeto
- **Planejamento (fonte de verdade):** [docs/redesign/planejamento.md](../redesign/planejamento.md).
- **Protótipo:** https://claude.ai/artifact/6tQuscgpFQk87MU2JZPNNs. Confira a aba da tela antes de especificar ou implementar. Leia com a ferramenta Artifact (`action: read`), não com WebFetch.
- **Base visual e de código:** o redesign do Observatório, no repositório vizinho `../observatorio_geo_hist` (tokens em `lib/app/theme/`, componentes em `lib/app/core/`). Reaproveite antes de criar.
- **Arquitetura:** seção "Arquitetura de Código" do [README.md](../../README.md). Resumo: `lib/core/` (componentes, modelos, navegação, tema, utilidades) e `lib/features/{feature}/` com `infra/` (datasources, repositories, models, errors) e `presentation/` (pages, components, stores). Fluxo Widget → Store (MobX) → Repository → Datasource → Firebase, com `Either` (dartz) na volta. Dependências registradas no `*_setup.dart` da feature.

## Comandos
Sempre com FVM (versão em `.fvmrc`):

```sh
fvm flutter pub get
fvm flutter run -d chrome
fvm flutter analyze
fvm dart run build_runner build --delete-conflicting-outputs   # após mudar stores MobX ou modelos com Freezed
fvm dart format <arquivos .dart alterados>                     # antes de cada commit
fvm flutter build web --release
```

Os arquivos gerados (`*.g.dart`, `*.freezed.dart`) ficam no repositório e não passam pelo `dart format`. Ainda não existe pasta `test/`.

## Git
- **Push na `main` publica o site em produção** (GitHub Actions, por FTP). Nunca faça push sem pedido explícito, e nunca direto na `main`.
- A branch de integração é a `develop` quando ela existir (item 0.0 do planejamento). Até lá, branches de trabalho saem da `main` e o merge fica com a pessoa.
- Commit só quando for pedido. Mensagens `tipo: descrição` (`feat`, `fix`, `refactor`, `docs`, `chore`), em português.

## Regras de design ao implementar
- Use os tokens de `lib/core/theme/` (`AppTheme.colors`, `.dimensions`, `.typography`). **Não escreva cores, tamanhos de fonte ou espaçamentos soltos no código.** Se faltar um token, crie-o no tema.
- Componentes novos usam tamanhos fixos por faixa de largura (celular < 600, tablet 600–1023, desktop ≥ 1024) e largura máxima de conteúdo. Nada escala pelo tamanho da tela (não use `num_extension` em código novo).
- `#C94400` é a cor de tudo que é clicável. O degradê laranja-amarelo é só decorativo: nunca sob texto pequeno nem em botões.
- Texto secundário nunca em cinza claro: contraste mínimo de 4,5:1 (vale para texto e ícones informativos).
- Toda área clicável tem foco visível por teclado e nome acessível (`Semantics`/tooltip). Preferir `InkWell`/botões do Material a `GestureDetector` solto.
- Ilustrações de temas e subtemas ficam inteiras em medalhão (1:1, `contain`), com placeholder quando faltar e tratamento de falha de carregamento.
- Telas devem funcionar em 390, 768 e 1280 px, sem rolagem horizontal e sem `overflow`.
- Estados obrigatórios em toda tela com dados: carregando (esqueleto), vazio e erro.
- Rotas em português, minúsculas, sem acento e com hífen, saindo das constantes do `AppRouter`. Ao renomear uma rota pública, mantenha a antiga redirecionando para a nova.

## Comentários e texto
- Interface, documentação, comentários e commits em **português do Brasil**. Nomes de código em inglês.
- Comentários são exceção: só o **porquê** que o código não mostra (regra de negócio escondida, contorno de limitação do Flutter ou do navegador, número que parece arbitrário). Uma ou duas linhas.
- Nunca cite spec, fase, protótipo ou seletor CSS em comentário. O histórico fica nos docs e no git.
