import 'package:expogeo/core/navigation/app_router.dart';

/// Último endereço da lista de objetos, com filtros e busca, para o editor voltar a ele, e se o
/// catálogo já foi recarregado nesta sessão do painel.
class PanelListMemory {
  String _location = AppRouter.adminPanelObjects;
  bool _catalogRefreshed = false;

  String get location => _location;

  void remember(String location) => _location = location;

  /// Diz se é a primeira vez que o painel abre desde o login; só aí vale recarregar.
  bool takeCatalogRefresh() {
    if (_catalogRefreshed) return false;
    _catalogRefreshed = true;
    return true;
  }

  /// Ao sair, a próxima entrada recarrega de novo.
  void reset() => _catalogRefreshed = false;
}
