import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';

extension ThemeIllustration on ThemeEnum {
  AppImages get illustration => switch (this) {
    ThemeEnum.representacoesEspaciais => AppImages.representacoesEspaciais,
    ThemeEnum.naturezaMeioAmbiente => AppImages.meioAmbienteNatureza,
    ThemeEnum.espacosUrbanosRurais => AppImages.espacosUrbanoRural,
    ThemeEnum.culturaPolitica => AppImages.culturaPolitica,
  };
}

extension SubthemeIllustration on SubthemeEnum {
  /// Sem subtema listado no tema, fica sem imagem e o medalhão mostra o placeholder.
  AppImages? get illustration {
    for (final theme in ThemeDataModel.themes) {
      for (final subtheme in theme.subthemes) {
        if (subtheme.type == this) return subtheme.image;
      }
    }
    return null;
  }
}
