import 'package:expogeo/core/navigation/app_router.dart';

/// Último endereço da lista de objetos, com filtros e busca, para o editor voltar a ele.
class PanelListMemory {
  String _location = AppRouter.adminPanelObjects;

  String get location => _location;

  void remember(String location) => _location = location;
}
