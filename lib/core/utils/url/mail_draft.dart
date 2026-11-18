class MailDraft {
  const MailDraft({required this.to, required this.subject, required this.body});

  final String to;
  final String subject;
  final String body;

  // Montado à mão: `Uri(queryParameters:)` troca espaço por `+`, que alguns programas mostram.
  // A RFC 6068 pede CRLF nas quebras de linha do corpo.
  String get mailtoUrl {
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body).replaceAll('%0A', '%0D%0A');
    return 'mailto:$to?subject=$encodedSubject&body=$encodedBody';
  }

  String get copyText => 'Assunto: $subject\n\n$body';
}
