import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

ThemeModel culturaPolitica = ThemeModel(
  type: ThemeEnum.culturaPolitica,
  title: 'Cultura e Política',
  description:
      'Mergulhe na diversidade, cultura e política global: povos originários, demografia e geopolítica!',
  imagePath: 'assets/images/cultura-politica.jpg',
  color: AppTheme.colors.secondaryRed,
  icon: Icons.people_outlined,
  subthemes: [
    SubthemeModel(
      type: SubthemeEnum.geopolitica,
      title: 'GEOPOLÍTICA',
      description: 'Geopolítica',
      image: AppImages.geopolitica,
      color: AppTheme.colors.secondaryRed,
    ),
    SubthemeModel(
      type: SubthemeEnum.censoDemografico,
      title: 'CENSO DEMOGRÁFICO',
      description: 'Censo Demográfico',
      image: AppImages.censoDemografico,
      color: AppTheme.colors.secondaryRed,
    ),
    SubthemeModel(
      type: SubthemeEnum.regioesAdministrativas,
      title: 'REGIÕES ADMINISTRATIVAS',
      description: 'Regiões administrativas',
      image: AppImages.regioesBrasileiras,
      color: AppTheme.colors.secondaryRed,
    ),
    SubthemeModel(
      type: SubthemeEnum.demografia,
      title: 'DEMOGRAFIA',
      description: 'Demografia',
      image: AppImages.demografia,
      color: AppTheme.colors.secondaryRed,
    ),
    SubthemeModel(
      type: SubthemeEnum.identidadesCulturais,
      title: 'IDENTIDADES CULTURAIS',
      description: 'Identidades culturais',
      image: AppImages.identidadesCulturais,
      color: AppTheme.colors.secondaryRed,
    ),
    SubthemeModel(
      type: SubthemeEnum.povosOriginarios,
      title: 'POVOS ORIGINÁRIOS',
      description: 'Povos originários',
      image: AppImages.povosOriginarios,
      color: AppTheme.colors.secondaryRed,
    ),
  ],
);
