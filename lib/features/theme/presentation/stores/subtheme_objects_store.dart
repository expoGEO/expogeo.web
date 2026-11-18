import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/content_type_display.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/string/string_utils.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:mobx/mobx.dart';

part 'subtheme_objects_store.g.dart';

class SubthemeObjectsStore = SubthemeObjectsStoreBase with _$SubthemeObjectsStore;

/// Busca, tipo e quantidade mostrada de um subtema; vale só enquanto a página está aberta.
abstract class SubthemeObjectsStoreBase with Store {
  SubthemeObjectsStoreBase(this.subtheme, this._catalog);

  static const int pageSize = 6;
  static const int maxSubjects = 8;

  final SubthemeEnum subtheme;
  final CatalogStore _catalog;

  @observable
  String query = '';

  @observable
  ContentType? type;

  @observable
  int shown = pageSize;

  CatalogState get catalogState => _catalog.state;

  Future<void> retry() => _catalog.ensureLoaded();

  /// Na ordem da curadoria, que é a do código de referência.
  @computed
  List<CatalogItem> get items {
    final catalog = _catalog.catalog;
    if (catalog == null) return const [];
    return catalog.items.where((item) => item.subtheme == subtheme).toList()
      ..sort((a, b) => a.content.id.compareTo(b.content.id));
  }

  @computed
  Map<CatalogItem, String> get _searchIndex => {
    for (final item in items) item: foldForSearch(_searchText(item)),
  };

  /// Resultados da busca, em qualquer tipo.
  @computed
  List<CatalogItem> get matches {
    final words = foldForSearch(
      query,
    ).split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return items;

    final index = _searchIndex;
    return items.where((item) => words.every(index[item]!.contains)).toList();
  }

  @computed
  Map<ContentType, int> get typeCounts {
    final counts = <ContentType, int>{};
    for (final item in matches) {
      counts.update(item.content.originInfo.type, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  @computed
  List<ContentType> get chipTypes => contentTypeOrder.where(typeCounts.containsKey).toList();

  @computed
  List<CatalogItem> get results {
    final selected = type;
    if (selected == null) return matches;
    return matches.where((item) => item.content.originInfo.type == selected).toList();
  }

  int get total => results.length;

  @computed
  List<CatalogItem> get visible => results.take(shown).toList();

  bool get hasMore => total > shown;

  /// Texto da linha de contagem; vazio quando nada foi encontrado.
  @computed
  String get summary {
    if (total == 0) return '';
    final search = query.trim();
    final count = 'Mostrando ${visible.length} de $total ${total == 1 ? 'objeto' : 'objetos'}';
    return search.isEmpty ? count : '$count para “$search”';
  }

  /// Sempre do subtema inteiro: não muda com a busca nem com o tipo.
  @computed
  List<String> get frequentSubjects {
    final ownName = foldForSearch(subtheme.name);
    final counts = <String, int>{};
    for (final item in items) {
      for (final subject in item.content.contentInfo.subjects) {
        final text = subject.trim();
        if (text.isEmpty || foldForSearch(text) == ownName) continue;
        counts.update(text, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final subjects = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : foldForSearch(a).compareTo(foldForSearch(b));
      });
    return subjects.take(maxSubjects).toList();
  }

  // Aqui, e não num computado: o tipo não pode voltar sozinho se a busca voltar.
  @action
  void setQuery(String text) {
    query = text;
    shown = pageSize;
    if (!typeCounts.containsKey(type)) type = null;
  }

  @action
  void selectType(ContentType? value) {
    type = value;
    shown = pageSize;
  }

  @action
  void applySubject(String subject) {
    query = subject;
    type = null;
    shown = pageSize;
  }

  @action
  void clearSearch() {
    query = '';
    shown = pageSize;
  }

  @action
  void reset() {
    query = '';
    type = null;
    shown = pageSize;
  }

  @action
  void loadMore() => shown += pageSize;

  static String _searchText(CatalogItem item) {
    final content = item.content;
    return [
      content.contentInfo.title,
      content.contentInfo.description,
      content.intellectualIndicator.creator,
      content.intellectualIndicator.collaborator ?? '',
      content.contentInfo.contentNote ?? '',
      ...content.contentInfo.subjects,
    ].join(' ');
  }
}
