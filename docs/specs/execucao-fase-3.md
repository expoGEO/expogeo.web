# Execução da Fase 3

- **Início:** 2026-11-06
- **Branch:** refactor/redesign-fase-3 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 010-contato | 3.1 | concluído (12 critérios, 14 tarefas) | pendente | pendente | |
| 011-estados-especiais | 3.2 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (geral) As specs 010 e 011 já existiam, aprovadas em 2026-10-27: a etapa de spec vira revisão contra o código atual, em vez de criar outra.
- (010) Seguem o protótipo, não a 018 do Observatório: migalha "Contato", textos e mensagem sem mínimo. Endereço do rodapé; borda `fieldBorder` nova (3,8:1); texto copiado com "Assunto: …" + corpo; `ContactForm` fixo na feature, sem `MailForm` genérico; quebra de linha do `mailto:` como `%0D%0A` (RFC 6068).

## Ressalvas
- Nenhuma até aqui.

## Ocorrências
- `pubspec.lock` estava alterado sem commit ao iniciar (transitivos subidos, `dart >=3.10`, fora da versão do FVM): ficou de fora dos commits, intacto na pasta original. As sessões usam a versão do git na cópia ASCII.
