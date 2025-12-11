import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_06.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/conflitos_terra/EUR_CT_07.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_06.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_07.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_rural_brasileiro/EUR_ERB_08.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_06.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espaco_urbano_brasileiro/EUR_EUB_07.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_06.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_07.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/globalizacao_mobilidade/EUR_GM_08.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/industria_transformacao/EUR_IT_06.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_01.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_02.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_03.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_04.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_05.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/mercado_agropecuario/EUR_MA_06.dart';
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
      contents: [
        EUR_EUB_01,
        EUR_EUB_02,
        EUR_EUB_03,
        EUR_EUB_04,
        EUR_EUB_05,
        EUR_EUB_06,
        EUR_EUB_07,
      ],
    ),
    SubthemeModel(
      type: SubthemeEnum.globalizacaoMobilidade,
      title: 'GLOBALIZAÇÃO E MOBILIDADE',
      description: 'Globalização e Mobilidade',
      image: AppImages.globalizacaoMobilidade,
      color: AppTheme.colors.primaryBlue,
      contents: [
        EUR_GM_01,
        EUR_GM_02,
        EUR_GM_03,
        EUR_GM_04,
        EUR_GM_05,
        EUR_GM_06,
        EUR_GM_07,
        EUR_GM_08,
      ],
    ),
    SubthemeModel(
      type: SubthemeEnum.industriaTransformacao,
      title: 'INDÚSTRIA E TRANSFORMAÇÃO',
      description: 'Indústria e transformação',
      image: AppImages.industriasTransformacoes,
      color: AppTheme.colors.primaryBlue,
      contents: [EUR_IT_01, EUR_IT_02, EUR_IT_03, EUR_IT_04, EUR_IT_05, EUR_IT_06],
    ),
    SubthemeModel(
      type: SubthemeEnum.espacoRuralBrasileiro,
      title: 'ESPAÇO RURAL BRASILEIRO',
      description: 'Espaço rural brasileiro',
      image: AppImages.espacoRuralBrasleiro,
      color: AppTheme.colors.primaryBlue,
      contents: [
        EUR_ERB_01,
        EUR_ERB_02,
        EUR_ERB_03,
        EUR_ERB_04,
        EUR_ERB_05,
        EUR_ERB_06,
        EUR_ERB_07,
        EUR_ERB_08,
      ],
    ),
    SubthemeModel(
      type: SubthemeEnum.conflitosTerra,
      title: 'CONFLITOS DE TERRA',
      description: 'Conflitos de terra',
      image: AppImages.conflitosTerra,
      color: AppTheme.colors.primaryBlue,
      contents: [EUR_CT_01, EUR_CT_02, EUR_CT_03, EUR_CT_04, EUR_CT_05, EUR_CT_06, EUR_CT_07],
    ),
    SubthemeModel(
      type: SubthemeEnum.mercadoAgropecuario,
      title: 'MERCADO AGROPECUÁRIO',
      description: 'Mercado Agropecuário',
      image: AppImages.mercadoAgropecuario,
      color: AppTheme.colors.primaryBlue,
      contents: [EUR_MA_01, EUR_MA_02, EUR_MA_03, EUR_MA_04, EUR_MA_05, EUR_MA_06],
    ),
  ],
);
