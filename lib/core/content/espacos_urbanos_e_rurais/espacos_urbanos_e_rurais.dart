import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

ThemeModel espacosUrbanosRurais = ThemeModel(
  type: ThemeEnum.espacosUrbanosRurais,
  title: 'Espaços Urbanos e Rurais',
  description:
      'Entenda a dinâmica das cidades, campo, indústria, mobilidade, e a vida em diferentes territórios.',
  imagePath: 'assets/images/espacos-urbanos.jpg',
  color: AppTheme.colors.primaryBlue,
  icon: Icons.location_city_outlined,
  subthemes: [
    SubthemeModel(
      type: SubthemeEnum.espacoUrbanoBrasileiro,
      title: 'ESPAÇO URBANO BRASILEIRO',
      description: 'Espaço urbano brasileiro',
      image: AppImages.espacoUrbanoBrasileiro,
      color: AppTheme.colors.primaryBlue,
    ),
    SubthemeModel(
      type: SubthemeEnum.globalizacaoMobilidade,
      title: 'GLOBALIZAÇÃO E MOBILIDADE',
      description: 'Globalização e Mobilidade',
      image: AppImages.globalizacaoMobilidade,
      color: AppTheme.colors.primaryBlue,
    ),
    SubthemeModel(
      type: SubthemeEnum.industriaTransformacao,
      title: 'INDÚSTRIA E TRANSFORMAÇÃO',
      description: 'Indústria e transformação',
      image: AppImages.industriasTransformacoes,
      color: AppTheme.colors.primaryBlue,
    ),
    SubthemeModel(
      type: SubthemeEnum.espacoRuralBrasileiro,
      title: 'ESPAÇO RURAL BRASILEIRO',
      description: 'Espaço rural brasileiro',
      image: AppImages.espacoRuralBrasleiro,
      color: AppTheme.colors.primaryBlue,
    ),
    SubthemeModel(
      type: SubthemeEnum.conflitosTerra,
      title: 'CONFLITOS DE TERRA',
      description: 'Conflitos de terra',
      image: AppImages.conflitosTerra,
      color: AppTheme.colors.primaryBlue,
    ),
    SubthemeModel(
      type: SubthemeEnum.mercadoAgropecuario,
      title: 'MERCADO AGROPECUÁRIO',
      description: 'Mercado Agropecuário',
      image: AppImages.mercadoAgropecuario,
      color: AppTheme.colors.primaryBlue,
    ),
  ],
);
