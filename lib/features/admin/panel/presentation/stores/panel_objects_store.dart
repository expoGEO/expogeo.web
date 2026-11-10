import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/string/string_utils.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:mobx/mobx.dart';

part 'panel_objects_store.g.dart';

enum PanelObjectsStatus { loading, error, empty, emptyFiltered, ready }

class PanelObjectsStore = PanelObjectsStoreBase with _$PanelObjectsStore;

/// Filtros, busca e quantidade mostrada da lista de objetos do painel; vale enquanto a vista está
/// aberta. Os filtros vêm do endereço por [applySelection].
abstract class PanelObjectsStoreBase with Store {
  PanelObjectsStoreBase(this._catalog);

  static const int pageSize = 12;

  final CatalogStore _catalog;

  @observable
  PanelSelection selection = const PanelSelection();

  @observable
  int shown = pageSize;

  /// Excluídos que o catálogo à vista ainda traz. Valem só para esse catálogo: o recarregado já
  /// vem sem eles.
  @observable
  ObservableSet<String> _hidden = ObservableSet<String>();

  @observable
  CatalogModel? _hiddenIn;

  @computed
  List<CatalogItem> get items {
    final catalog = _catalog.catalog;
    if (catalog == null) return const [];
    final hidden = identical(catalog, _hiddenIn) ? _hidden : const <String>{};
    return catalog.items.where((item) => !hidden.contains(item.content.docId)).toList()
      ..sort(_byNewest);
  }

  @computed
  Map<CatalogItem, String> get _searchIndex => {
    for (final item in items) item: foldForSearch(_searchText(item)),
  };

  @computed
  List<CatalogItem> get results {
    final theme = selection.theme;
    final subtheme = selection.subtheme;
    final type = selection.type;
    final words = foldForSearch(
      selection.query ?? '',
    ).split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    final index = _searchIndex;

    return items.where((item) {
      if (theme != null && item.theme != theme) return false;
      if (subtheme != null && item.subtheme != subtheme) return false;
      if (type != null && item.content.originInfo.type != type) return false;
      return words.isEmpty || words.every(index[item]!.contains);
    }).toList();
  }

  int get total => results.length;

  @computed
  List<CatalogItem> get visible => results.take(shown).toList();

  bool get hasMore => total > shown;

  /// "190 objetos"; o tema não conta como filtro porque já está no título.
  @computed
  String get summary {
    final count = '$total ${total == 1 ? 'objeto' : 'objetos'}';
    return selection.hasNarrowingFilter ? '$count com os filtros atuais' : count;
  }

  @computed
  String get footer => 'Mostrando ${visible.length} de $total';

  @computed
  PanelObjectsStatus get status {
    if (_catalog.catalog == null) {
      return _catalog.state.isError ? PanelObjectsStatus.error : PanelObjectsStatus.loading;
    }
    if (items.isEmpty) return PanelObjectsStatus.empty;
    if (results.isEmpty) return PanelObjectsStatus.emptyFiltered;
    return PanelObjectsStatus.ready;
  }

  List<SubthemeEnum> subthemesOf(ThemeEnum theme) => [
    for (final model in ThemeDataModel.themes)
      if (model.type == theme)
        for (final subtheme in model.subthemes) subtheme.type,
  ];

  /// Mudar qualquer filtro volta a mostrar a primeira página.
  @action
  void applySelection(PanelSelection next) {
    if (next == selection) return;
    selection = next;
    shown = pageSize;
  }

  @action
  void showMore() => shown += pageSize;

  @action
  void hide(String docId) {
    final catalog = _catalog.catalog;
    if (!identical(catalog, _hiddenIn)) {
      _hidden = ObservableSet<String>();
      _hiddenIn = catalog;
    }
    _hidden.add(docId);
  }

  static int _byNewest(CatalogItem a, CatalogItem b) {
    final byDate = b.content.originInfo.insertionDate.compareTo(a.content.originInfo.insertionDate);
    return byDate != 0 ? byDate : a.content.id.compareTo(b.content.id);
  }

  // O código entra como gravado e como no endereço, para achar com `_` ou com `-`.
  static String _searchText(CatalogItem item) {
    final content = item.content;
    return [
      content.id,
      item.slug,
      content.contentInfo.title,
      content.intellectualIndicator.creator,
      ...content.contentInfo.subjects,
    ].join(' ');
  }
}
