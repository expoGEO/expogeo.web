import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_01.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/catalog/infra/errors/catalog_failure.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/infra/repositories/catalog_repository.dart';

/// Objetos por subtema contados no ambiente de testes.
const devCountsBySubtheme = <String, int>{
  'RE_CG': 5,
  'RE_CM': 4,
  'RE_FH': 4,
  'RE_GT': 5,
  'RE_HC': 5,
  'RE_LM': 7,
  'RE_PC': 5,
  'NMA_PA': 6,
  'NMA_PAR': 4,
  'NMA_DES': 6,
  'NMA_QUE': 7,
  'NMA_RM': 7,
  'NMA_SUS': 10,
  'NMA_TC': 5,
  'NMA_TPCL': 4,
  'NMA_BH': 5,
  'NMA_UA': 7,
  'NMA_BIO': 7,
  'NMA_EFR': 6,
  'EUR_EUB': 7,
  'EUR_GM': 8,
  'EUR_IT': 6,
  'EUR_ERB': 8,
  'EUR_CT': 7,
  'EUR_MA': 6,
  'CP_GP': 5,
  'CP_CD': 5,
  'CP_RA': 4,
  'CP_POP': 8,
  'CP_IC': 8,
  'CP_PO': 9,
};

Map<String, dynamic> validContentJson() =>
    ContentResponseModel.fromContentModel(content: RE_CG_01, docId: 'x').toJson();

CatalogRecord recordAt(String subthemeId, String docId, {Map<String, dynamic>? data}) {
  final themeId = subthemeId.split('_').first;
  return CatalogRecord(
    path: 'themes/$themeId/subthemes/$subthemeId/contents/$docId',
    id: docId,
    data: data ?? validContentJson(),
  );
}

/// Objeto com código, data de inserção e título próprios, para conferir ordem e escolha.
CatalogRecord objectAt(String subthemeId, String code, {required DateTime date, String? title}) {
  final data = validContentJson();
  data['id'] = code;
  (data['contentInfo'] as Map<String, dynamic>)['title'] = title ?? 'Objeto $code';
  (data['originInfo'] as Map<String, dynamic>)
    ..['insertionDate'] = date.toIso8601String()
    ..['type'] = 'site'
    ..['format'] = 'html';
  return recordAt(subthemeId, 'doc_$code', data: data);
}

/// Objeto com os campos que a lista do subtema mostra e procura.
CatalogRecord objectWith(
  String subthemeId,
  String code, {
  String title = 'Sem título',
  String description = 'Sem descrição',
  String creator = 'Sem criador',
  String? collaborator,
  String? note,
  List<String> subjects = const [],
  String type = 'site',
  String format = 'html',
  int? year,
  String location = 'https://www.exemplo.org/recurso',
}) {
  final data = validContentJson();
  data['id'] = code;
  data['intellectualIndicator'] = {
    'creator': creator,
    if (collaborator != null) 'collaborator': collaborator,
  };
  data['contentInfo'] = {
    'title': title,
    'description': description,
    'subjects': subjects,
    if (note != null) 'contentNote': note,
  };
  (data['originInfo'] as Map<String, dynamic>)
    ..['type'] = type
    ..['format'] = format;
  data['registrationInfo'] = {'location': location, if (year != null) 'issueYear': year};
  return recordAt(subthemeId, 'doc_$code', data: data);
}

/// Os 7 objetos de Biomas fora de ordem, para conferir a escolha pelo menor código.
List<CatalogRecord> biomasRecords() => [
  for (final n in [4, 2, 7, 1, 6, 3, 5])
    objectAt(
      'NMA_BIO',
      'NMA_BIO_0$n',
      date: DateTime(2024, 12, n),
      title: n == 1 ? 'aVoar Cerrado' : null,
    ),
];

List<CatalogRecord> devRecords() => [
  for (final entry in devCountsBySubtheme.entries)
    for (var i = 0; i < entry.value; i++) recordAt(entry.key, '${entry.key}_$i'),
];

/// Repositório que conta as consultas e só responde quando o teste mandar.
class FakeCatalogRepository implements CatalogRepository {
  int calls = 0;
  final List<Completer<Either<CatalogFailure, CatalogModel>>> pending = [];

  @override
  Future<Either<CatalogFailure, CatalogModel>> load() {
    calls++;
    final completer = Completer<Either<CatalogFailure, CatalogModel>>();
    pending.add(completer);
    return completer.future;
  }

  void succeed([List<CatalogRecord>? records]) =>
      pending.removeLast().complete(Right(CatalogModel.fromRecords(records ?? devRecords())));

  void fail() => pending.removeLast().complete(const Left(CatalogFetchFailure('negado')));
}
