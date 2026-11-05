String convertToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp("(?<!^)([A-Z])"), (Match match) {
    return "_${match.group(0)!.toLowerCase()}";
  });
}

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ç': 'c', //
};

/// Para comparar buscas na tela ignorando maiúsculas e acentos.
String foldForSearch(String text) {
  final buffer = StringBuffer();
  for (final char in text.trim().toLowerCase().split('')) {
    buffer.write(_accents[char] ?? char);
  }
  return buffer.toString();
}
