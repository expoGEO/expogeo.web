import 'package:expogeo/core/content/cultura_e_politica/censo_demografico/CP_CD_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/censo_demografico/CP_CD_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/censo_demografico/CP_CD_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/censo_demografico/CP_CD_04.dart';
import 'package:expogeo/core/content/cultura_e_politica/censo_demografico/CP_CD_05.dart';
import 'package:expogeo/core/content/cultura_e_politica/geopolitica/CP_GP_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/geopolitica/CP_GP_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/geopolitica/CP_GP_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/geopolitica/CP_GP_04.dart';
import 'package:expogeo/core/content/cultura_e_politica/geopolitica/CP_GP_05.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_04.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_05.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_06.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_07.dart';
import 'package:expogeo/core/content/cultura_e_politica/identidades_culturais/CP_IC_08.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_04.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_05.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_06.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_07.dart';
import 'package:expogeo/core/content/cultura_e_politica/populacao/CP_POP_08.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_04.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_05.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_06.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_07.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_08.dart';
import 'package:expogeo/core/content/cultura_e_politica/povos_originarios/CP_PO_09.dart';
import 'package:expogeo/core/content/cultura_e_politica/regioes_administrativas/CP_RA_01.dart';
import 'package:expogeo/core/content/cultura_e_politica/regioes_administrativas/CP_RA_02.dart';
import 'package:expogeo/core/content/cultura_e_politica/regioes_administrativas/CP_RA_03.dart';
import 'package:expogeo/core/content/cultura_e_politica/regioes_administrativas/CP_RA_04.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

ThemeModel culturaPolitica = ThemeModel(
  type: ThemeEnum.culturaPolitica,
  title: 'Cultura e Política',
  description:
      'Navegue por objetos digitais que representam a diversidade, cultura identidades culturais, demografia e geopolítica global. ',
  imagePath: 'assets/images/cultura-politica.jpg',
  icon: Icons.people_outlined,
  subthemes: [
    SubthemeModel(
      type: SubthemeEnum.geopolitica,
      title: 'GEOPOLÍTICA',
      description: 'Geopolítica',
      image: AppImages.geopolitica,
      contents: [CP_GP_01, CP_GP_02, CP_GP_03, CP_GP_04, CP_GP_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.censoDemografico,
      title: 'CENSO DEMOGRÁFICO',
      description: 'Censo Demográfico',
      image: AppImages.censoDemografico,
      contents: [CP_CD_01, CP_CD_02, CP_CD_03, CP_CD_04, CP_CD_05],
    ),
    SubthemeModel(
      type: SubthemeEnum.regioesAdministrativas,
      title: 'REGIÕES ADMINISTRATIVAS',
      description: 'Regiões administrativas',
      image: AppImages.regioesBrasileiras,
      contents: [CP_RA_01, CP_RA_02, CP_RA_03, CP_RA_04],
    ),
    SubthemeModel(
      type: SubthemeEnum.populacao,
      title: 'POPULAÇÃO',
      description: 'População',
      image: AppImages.populacao,
      contents: [
        CP_POP_01,
        CP_POP_02,
        CP_POP_03,
        CP_POP_04,
        CP_POP_05,
        CP_POP_06,
        CP_POP_07,
        CP_POP_08,
      ],
    ),
    SubthemeModel(
      type: SubthemeEnum.identidadesCulturais,
      title: 'IDENTIDADES CULTURAIS',
      description: 'Identidades culturais',
      image: AppImages.identidadesCulturais,
      contents: [CP_IC_01, CP_IC_02, CP_IC_03, CP_IC_04, CP_IC_05, CP_IC_06, CP_IC_07, CP_IC_08],
    ),
    SubthemeModel(
      type: SubthemeEnum.povosOriginarios,
      title: 'POVOS ORIGINÁRIOS',
      description: 'Povos originários',
      image: AppImages.povosOriginarios,
      contents: [
        CP_PO_01,
        CP_PO_02,
        CP_PO_03,
        CP_PO_04,
        CP_PO_05,
        CP_PO_06,
        CP_PO_07,
        CP_PO_08,
        CP_PO_09,
      ],
    ),
  ],
);
