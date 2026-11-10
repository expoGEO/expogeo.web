/// Endereço público do site em produção; base do `canonical` e do `og:url`.
const String siteOrigin = 'https://expogeo.com.br';

const String siteName = 'expoGEO';

/// Metadados de uma página para o Google e para quem compartilha o link.
class PageMeta {
  const PageMeta({
    required this.title,
    required this.description,
    required this.path,
    this.noIndex = false,
  });

  /// Título da aba e do resultado de busca, já com o nome do site quando couber.
  final String title;

  /// Resumo da página; o Google costuma cortar perto de 160 caracteres.
  final String description;

  /// Caminho da rota, como `/sobre` (a home é `/`).
  final String path;

  /// Página que não deve aparecer na busca (como a de endereço inexistente).
  final bool noIndex;

  /// Título no formato "Página · expoGEO".
  factory PageMeta.titled({
    required String title,
    required String description,
    required String path,
    bool noIndex = false,
  }) =>
      PageMeta(title: '$title · $siteName', description: description, path: path, noIndex: noIndex);

  /// Sem barra final, para a mesma página não ter dois endereços canônicos.
  String canonicalUrl(String origin) {
    final clean = path.length > 1 && path.endsWith('/') ? path.substring(0, path.length - 1) : path;
    return clean == '/' ? '$origin/' : '$origin$clean';
  }
}

/// Texto numa linha, cortado em palavra inteira com reticências quando passa de [max].
String summarize(String text, {int max = 155}) {
  final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (flat.length <= max) return flat;
  final cut = flat.substring(0, max - 1);
  final space = cut.lastIndexOf(' ');
  final base = space > max ~/ 2 ? cut.substring(0, space) : cut;
  return '${base.replaceAll(RegExp(r'[\s.,;:]+$'), '')}…';
}
