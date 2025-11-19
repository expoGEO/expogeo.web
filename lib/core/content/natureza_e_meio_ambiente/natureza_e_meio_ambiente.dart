import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

ThemeModel naturezaMeioAmbiente = ThemeModel(
  type: ThemeEnum.naturezaMeioAmbiente,
  title: 'Meio Ambiente e Natureza',
  description:
      'Conheça os elementos naturais e desafios ambientais do mundo: clima, água, relevo, biomas e sustentabilidade.',
  imagePath: 'assets/images/meio-ambiente.jpg',
  color: AppTheme.colors.primaryGreen,
  icon: Icons.eco_outlined,
  subthemes: [
    SubthemeModel(
      type: SubthemeEnum.poluicaoAgua,
      title: 'POLUIÇÃO DA ÁGUA',
      description: 'Poluição da água',
      image: AppImages.poluicaoAgua,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.poluicaoAr,
      title: 'POLUIÇÃO DO AR',
      description: 'Poluição do ar',
      image: AppImages.poluicaoAr,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.desmatamento,
      title: 'DESMATAMENTO',
      description: 'Desmatamento',
      image: AppImages.desmatamento,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.queimadas,
      title: 'QUEIMADAS',
      description: 'Queimadas',
      image: AppImages.queimadas,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.sustentabilidade,
      title: 'SUSTENTABILIDADE',
      description: 'Sustentabilidade',
      image: AppImages.sustentabilidade,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.biomas,
      title: 'BIOMAS',
      description: 'Biomas',
      image: AppImages.biomas,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.recursosMinerais,
      title: 'RECURSOS MINERAIS',
      description: 'Recursos minerais',
      image: AppImages.recursosMinerais,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.estruturasFormasRelevo,
      title: 'ESTRUTURAS E FORMAS DE RELEVO',
      description: 'Estruturas e formas de relevo',
      image: AppImages.estruturasFormasRelevo,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.tiposClimaticos,
      title: 'TIPOS CLIMÁTICOS',
      description: 'Tipos climáticos',
      image: AppImages.tiposClimaticos,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.tempoClima,
      title: 'TEMPO E CLIMA',
      description: 'Tempo e Clima',
      image: AppImages.tempoClima,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.baciasHidrograficas,
      title: 'BACIAS HIDROGRÁFICAS',
      description: 'Bacias hidrográficas',
      image: AppImages.baciasHidrograficas,
      color: AppTheme.colors.primaryGreen,
    ),
    SubthemeModel(
      type: SubthemeEnum.usoAgua,
      title: 'USO DA ÁGUA',
      description: 'Uso da água',
      image: AppImages.usoAgua,
      color: AppTheme.colors.primaryGreen,
    ),
  ],
);
