import 'package:expogeo/core/models/theme_data_model.dart';

/// Código de referência separado em prefixo e número (`NMA_PAG_06` → `NMA_PAG` e 6).
typedef ReferenceCodeParts = ({String prefix, int number});

final RegExp _codePattern = RegExp(r'^(.+)_(\d+)$');

ReferenceCodeParts? parseCode(String code) {
  final match = _codePattern.firstMatch(code.trim());
  if (match == null) return null;
  return (prefix: match.group(1)!, number: int.parse(match.group(2)!));
}

String formatCode(String prefix, int number) => '${prefix}_${number.toString().padLeft(2, '0')}';

/// Próximo código do subtema a partir dos já usados nele: o prefixo que eles usam (alguns
/// subtemas não seguem a sigla da lista, como `NMA_PAG`) e o maior número + 1, sem reaproveitar
/// números de objetos excluídos. Sem códigos, começa em `{sigla}_01`.
String nextCode(Iterable<String> codes, SubthemeEnum subtheme) {
  final uses = <String, int>{};
  final highest = <String, int>{};
  var max = 0;
  for (final code in codes) {
    final parts = parseCode(code);
    if (parts == null) continue;
    uses.update(parts.prefix, (count) => count + 1, ifAbsent: () => 1);
    highest.update(
      parts.prefix,
      (number) => number > parts.number ? number : parts.number,
      ifAbsent: () => parts.number,
    );
    if (parts.number > max) max = parts.number;
  }
  if (uses.isEmpty) return formatCode(subtheme.id, 1);

  String? prefix;
  for (final candidate in uses.keys) {
    if (prefix == null ||
        uses[candidate]! > uses[prefix]! ||
        (uses[candidate] == uses[prefix] && highest[candidate]! > highest[prefix]!)) {
      prefix = candidate;
    }
  }
  return formatCode(prefix!, max + 1);
}

/// O número seguinte com o mesmo prefixo, para quando o código calculado já está ocupado.
String following(String code) {
  final parts = parseCode(code);
  if (parts == null) return formatCode(code, 1);
  return formatCode(parts.prefix, parts.number + 1);
}
