import 'package:expogeo/core/content/representacoes_espaciais/compositor_mapas/RE_CM_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/compositor_mapas/RE_CM_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/compositor_mapas/RE_CM_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/compositor_mapas/RE_CM_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_05.dart';
import 'package:expogeo/core/content/representacoes_espaciais/fuso_horario/RE_FH_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/fuso_horario/RE_FH_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/fuso_horario/RE_FH_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/fuso_horario/RE_FH_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/geotecnologias/RE_GT_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/geotecnologias/RE_GT_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/geotecnologias/RE_GT_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/geotecnologias/RE_GT_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/geotecnologias/RE_GT_05.dart';
import 'package:expogeo/core/content/representacoes_espaciais/historia_cartografia/RE_HC_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/historia_cartografia/RE_HC_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/historia_cartografia/RE_HC_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/historia_cartografia/RE_HC_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/historia_cartografia/RE_HC_05.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_05.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_06.dart';
import 'package:expogeo/core/content/representacoes_espaciais/leitura_mapas/RE_LM_07.dart';
import 'package:expogeo/core/content/representacoes_espaciais/pontos_cardeais/RE_PC_01.dart';
import 'package:expogeo/core/content/representacoes_espaciais/pontos_cardeais/RE_PC_02.dart';
import 'package:expogeo/core/content/representacoes_espaciais/pontos_cardeais/RE_PC_03.dart';
import 'package:expogeo/core/content/representacoes_espaciais/pontos_cardeais/RE_PC_04.dart';
import 'package:expogeo/core/content/representacoes_espaciais/pontos_cardeais/RE_PC_05.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

ThemeModel representacoesEspaciais = ThemeModel(
  type: ThemeEnum.representacoesEspaciais,
  title: 'Representações Espaciais',
  description:
      'Explore conteúdos relacionados aos diferentes modos de representação da superfície terrestre. Descubra mais sobre Cartografia, Geotecnologias e Mapas.',
  imagePath: 'assets/images/representacoes.jpg',
  icon: Icons.map_outlined,
  subthemes: [
    SubthemeModel(
      type: SubthemeEnum.historiaCartografia,
      title: 'HISTÓRIA DA CARTOGRAFIA',
      description: 'História da Cartografia',
      image: AppImages.historiaCartografia,
      contents: [RE_HC_01, RE_HC_02, RE_HC_03, RE_HC_04, RE_HC_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.pontosCardeais,
      title: 'PONTOS CARDEAIS',
      description: 'Pontos cardeais',
      image: AppImages.pontosCardeais,
      contents: [RE_PC_01, RE_PC_02, RE_PC_03, RE_PC_04, RE_PC_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.coordenadasGeograficas,
      title: 'COORDENADAS GEOGRÁFICAS',
      description: 'Coordenadas geográficas',
      image: AppImages.coordenadasGeograficas,
      contents: [RE_CG_01, RE_CG_02, RE_CG_03, RE_CG_04, RE_CG_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.fusoHorario,
      title: 'FUSO HORÁRIO',
      description: 'Fuso horário',
      image: AppImages.fusoHorario,
      contents: [RE_FH_01, RE_FH_02, RE_FH_03, RE_FH_04],
    ),
    SubthemeModel(
      type: SubthemeEnum.leituraMapas,
      title: 'LEITURA DE MAPAS',
      description: 'Leitura de mapas',
      image: AppImages.leituraMapas,
      contents: [RE_LM_01, RE_LM_02, RE_LM_03, RE_LM_04, RE_LM_05, RE_LM_06, RE_LM_07],
    ),
    SubthemeModel(
      type: SubthemeEnum.geotecnologias,
      title: 'GEOTECNOLOGIAS',
      description: 'Geotecnologias',
      image: AppImages.geotecnologias,
      contents: [RE_GT_01, RE_GT_02, RE_GT_03, RE_GT_04, RE_GT_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.compositorMapas,
      title: 'COMPOSITOR DE MAPAS',
      description: 'Compositor de mapas',
      image: AppImages.compositorMapas,
      contents: [RE_CM_01, RE_CM_02, RE_CM_03, RE_CM_04],
    ),
  ],
);
