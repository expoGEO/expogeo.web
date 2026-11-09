import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expogeo/features/catalog/infra/datasources/catalog_datasource.dart';
import 'package:expogeo/features/catalog/infra/errors/catalog_failure.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

class CatalogRepository {
  CatalogRepository(this._datasource);

  final CatalogDatasource _datasource;

  Future<Either<CatalogFailure, CatalogModel>> load() async {
    try {
      final records = await _datasource.fetchAll();
      return Right(CatalogModel.fromRecords(records));
    } on CatalogOfflineException {
      return const Left(CatalogFetchFailure('Sem conexão para consultar o acervo.'));
    } on TimeoutException {
      return const Left(CatalogTimeoutFailure('A consulta ao acervo demorou demais.'));
    } on FirebaseException catch (e) {
      return Left(CatalogFetchFailure('Erro ao consultar o acervo: ${e.code}'));
    } catch (e) {
      return Left(CatalogGenericFailure('Erro inesperado ao carregar o acervo: $e'));
    }
  }
}
