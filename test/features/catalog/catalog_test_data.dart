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
