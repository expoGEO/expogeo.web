# Histórico do redesign

Uma linha por fase executada. O detalhe de cada spec fica em `docs/specs/NNN-*/` (spec, plano, tarefas e verificação), e o andamento de cada fase, no git (arquivo `execucao-<fase>.md`, apagado no encerramento).

| Fase | Período | Specs | PR |
|---|---|---|---|
| Fase 0: ambiente, fundação e casco | 2026-10-27 a 2026-11-03 | 001-fundacao, 002-botoes-navbar-rodape, 003-index-ilustracoes (todas verificadas) | PR da branch `refactor/redesign-fase-0` para `develop` |

## Pendências em aberto
- **003:** conferir a prévia real em aplicativo de mensagem (WhatsApp etc.) depois do deploy em `dev.expogeo.com.br`.
- **Painel admin:** não foi conferido na tela na Fase 0, por falta de credenciais de teste. Nenhum arquivo dele mudou.
- **008:** `/representacoes-espaciais/movimentos-terra` mostra o conteúdo de História da Cartografia (defeito anterior ao redesign).
- **006:** os logos de apoio saíram do rodapé na 002 e voltam na página Sobre.
- **009 e 014:** falam em fonte monoespaçada para o código de referência; a 001 decidiu usar Figtree 600 com algarismos tabulares.
- **016:** PNGs das ilustrações e botões antigos (`PrimaryButton`/`SecondaryButton`, ainda no painel) saem na limpeza.

## Lições
- `fvm flutter analyze` e os testes só rodam numa cópia em caminho ASCII (o "ó" da pasta quebra a ferramenta).
- Um `pub get` em outra máquina ou SDK pode alterar transitivos no `pubspec.lock`; restaure se a entrega não prevê pacote novo.
- A máquina não tem `cwebp`, ImageMagick nem Pillow: WebP e ícones saem pelo Chrome sem janela (scripts em `tool/`).
- Limites de uso interromperam duas implementações; retomar a mesma sessão a partir do `tasks.md` funcionou sem perda.
