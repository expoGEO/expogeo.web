import 'package:expogeo/core/components/image/app_asset_image.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: AppTheme.dimensions.space.huge.height,
        left: AppTheme.dimensions.space.huge.width,
        right: AppTheme.dimensions.space.huge.width,
      ),
      child: Column(
        children: [
          AppAssetImage(image: AppImages.logo, width: MediaQuery.of(context).size.width * 0.3),
          SizedBox(height: AppTheme.dimensions.space.large),
          Text(
            'Bem-vindo(a) à curadoria digital expoGEO! Essa é uma plataforma criada '
            'para atender estudantes e professores, com o intuito de divulgar '
            'materiais que fazem relação com o saber geográfico. Aqui você '
            'encontrará conteúdos digitais relacionados aos temas do currículo '
            'geográfico escolar de forma dinâmica e interativa.\n\n'
            'A expoGEO faz parte de uma pesquisa acadêmica em nível de Doutorado '
            'desenvolvida no Programa de Pós-Graduação em Educação da Universidade '
            'Federal de Uberlândia (PPGED/UFU). Conta com o apoio financeiro da '
            'Coordenação de Aperfeiçoamento de Pessoal de Nível Superior '
            '(CAPES/CNPQ/MEC) e vinculada ao Grupo de Estudos e Pesquisas '
            '"Observatório do Ensino de História e Geografia" da Universidade '
            'Federal de Uberlândia (OEHGEO/UFU).',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.mediumGray),
          ),
          SizedBox(height: AppTheme.dimensions.space.huge),
          Text(
            'Para facilitar a sua navegação, clique nos cards abaixo e inicie um passeio através do conhecimento geográfico.',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
