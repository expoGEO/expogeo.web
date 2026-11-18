import 'package:expogeo/core/utils/url/mail_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const subject = 'Sugestão & dúvida: 100% #1?';
  const body = 'Olá, tudo bem? 🌎\n\nLink: a=1&b=2#fim\n\nAna\nana@exemplo.com';
  const draft = MailDraft(to: 'expogeoufu@gmail.com', subject: subject, body: body);

  String query(String url, String key) {
    final start = url.indexOf('$key=') + key.length + 1;
    final end = url.indexOf('&', start);
    return url.substring(start, end == -1 ? url.length : end);
  }

  test('destinatário fica antes da consulta, sem codificar', () {
    expect(draft.mailtoUrl, startsWith('mailto:expogeoufu@gmail.com?subject='));
  });

  test('caracteres reservados não quebram os parâmetros', () {
    final url = draft.mailtoUrl;
    expect('&'.allMatches(url), hasLength(1));
    expect('?'.allMatches(url), hasLength(1));
    expect(url, isNot(contains('#')));
    expect(url, isNot(contains(' ')));
  });

  test('espaço vira %20, nunca +', () {
    expect(draft.mailtoUrl, contains('%20'));
    expect(draft.mailtoUrl, isNot(contains('+')));
  });

  test('quebra de linha vira %0D%0A', () {
    expect(draft.mailtoUrl, contains('%0D%0A%0D%0A'));
    expect(draft.mailtoUrl.replaceAll('%0D%0A', ''), isNot(contains('%0A')));
  });

  test('decodificar devolve o texto original', () {
    final url = draft.mailtoUrl;
    expect(Uri.decodeComponent(query(url, 'subject')), subject);
    expect(Uri.decodeComponent(query(url, 'body')).replaceAll('\r\n', '\n'), body);
  });

  test('o endereço passa pelo Uri sem perder nada', () {
    expect(Uri.parse(draft.mailtoUrl).toString(), draft.mailtoUrl);
  });

  test('texto copiado traz o assunto, uma linha em branco e o corpo', () {
    expect(draft.copyText, 'Assunto: $subject\n\n$body');
  });
}
