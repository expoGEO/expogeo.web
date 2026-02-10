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
            '''Seja bem-vindo(a) à expoGEO — Curadoria Digital do Saber Geográfico!

Este é um espaço pensado especialmente para estudantes, professores e todos que se interessam por compreender o mundo a partir da Geografia. Aqui, você encontrará uma seleção cuidadosa de conteúdos digitais que abordam os principais temas geográficos de forma dinâmica, interativa e pedagogicamente qualificada.

A expoGEO reúne materiais confiáveis, recursos educacionais digitais e propostas inovadoras que potencializam os processos de ensino e aprendizagem da Geografia escolar, aproximando conhecimento científico, práticas pedagógicas e tecnologias contemporâneas.

Este projeto integra as ações do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia (PPGED/UFU) e foi desenvolvido no âmbito do Observatório do Ensino de História e Geografia (OEHGEO/UFU), fortalecendo a articulação entre pesquisa, formação docente e curadoria de conteúdos educacionais.''',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.mediumGray),
          ),
          SizedBox(height: AppTheme.dimensions.space.huge),
          Text(
            'Para começar sua experiência, explore os cards abaixo e embarque em um percurso de descobertas pelo universo do conhecimento geográfico.',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
