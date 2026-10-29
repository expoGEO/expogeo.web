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
