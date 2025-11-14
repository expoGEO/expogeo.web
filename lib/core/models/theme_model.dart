import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/utils/enums/app_images.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String route;
  final Color color;
  final IconData icon;
  final List<SubthemeModel> subthemes;

  const ThemeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.route,
    required this.color,
    required this.icon,
    required this.subthemes,
  });
}

class SubthemeModel {
  final String id;
  final String title;
  final String description;
  final AppImages image;
  final String route;
  final Color color;

  const SubthemeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.route,
    required this.color,
  });
}

// Dados dos temas principais
class ThemeDataModel {
  static const List<ThemeModel> themes = [
    ThemeModel(
      id: 'representacoes',
      title: 'Representações Espaciais',
      description:
          'Explore mapas, cartografia e geotecnologias. Descubra como representamos o nosso planeta!',
      imagePath: 'assets/images/representacoes.jpg',
      route: AppRouter.representacoes,
      color: AppColors.primaryRed,
      icon: Icons.map_outlined,
      subthemes: [
        SubthemeModel(
          id: 'historia-cartografia',
          title: 'HISTÓRIA DA CARTOGRAFIA',
          description: 'História da Cartografia',
          image: AppImages.historiaCartografia,
          route: '/representacoes/historia-cartografia',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'movimentos-terra',
          title: 'MOVIMENTOS DA TERRA',
          description: 'Movimentos da Terra',
          image: AppImages.movimentosTerra,
          route: '/representacoes/movimentos-terra',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'pontos-cardeais',
          title: 'PONTOS CARDEAIS',
          description: 'Pontos cardeais',
          image: AppImages.pontosCardeais,
          route: '/representacoes/pontos-cardeais',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'coordenadas-geograficas',
          title: 'COORDENADAS GEOGRÁFICAS',
          description: 'Coordenadas geográficas',
          image: AppImages.coordenadasGeograficas,
          route: '/representacoes/coordenadas-geograficas',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'fuso-horario',
          title: 'FUSO HORÁRIO',
          description: 'Fuso horário',
          image: AppImages.fusoHorario,
          route: '/representacoes/fuso-horario',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'leitura-mapas',
          title: 'LEITURA DE MAPAS',
          description: 'Leitura de mapas',
          image: AppImages.leituraMapas,
          route: '/representacoes/leitura-mapas',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'geotecnologias',
          title: 'GEOTECNOLOGIAS',
          description: 'Geotecnologias',
          image: AppImages.geotecnologias,
          route: '/representacoes/geotecnologias',
          color: AppColors.primaryRed,
        ),
        SubthemeModel(
          id: 'compositor-mapas',
          title: 'COMPOSITOR DE MAPAS',
          description: 'Compositor de mapas',
          image: AppImages.compositorMapas,
          route: '/representacoes/compositor-mapas',
          color: AppColors.primaryRed,
        ),
      ],
    ),
    ThemeModel(
      id: 'meio-ambiente',
      title: 'Meio Ambiente e Natureza',
      description:
          'Conheça os elementos naturais e desafios ambientais do mundo: clima, água, relevo, biomas e sustentabilidade.',
      imagePath: 'assets/images/meio-ambiente.jpg',
      route: AppRouter.meioAmbiente,
      color: AppColors.primaryGreen,
      icon: Icons.eco_outlined,
      subthemes: [
        SubthemeModel(
          id: 'poluicao-agua',
          title: 'POLUIÇÃO DA ÁGUA',
          description: 'Poluição da água',
          image: AppImages.poluicaoAgua,
          route: '/meio-ambiente/poluicao-agua',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'poluicao-ar',
          title: 'POLUIÇÃO DO AR',
          description: 'Poluição do ar',
          image: AppImages.poluicaoAr,
          route: '/meio-ambiente/poluicao-ar',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'desmatamento',
          title: 'DESMATAMENTO',
          description: 'Desmatamento',
          image: AppImages.desmatamento,
          route: '/meio-ambiente/desmatamento',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'queimadas',
          title: 'QUEIMADAS',
          description: 'Queimadas',
          image: AppImages.queimadas,
          route: '/meio-ambiente/queimadas',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'sustentabilidade',
          title: 'SUSTENTABILIDADE',
          description: 'Sustentabilidade',
          image: AppImages.sustentabilidade,
          route: '/meio-ambiente/sustentabilidade',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'biomas',
          title: 'BIOMAS',
          description: 'Biomas',
          image: AppImages.biomas,
          route: '/meio-ambiente/biomas',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'recursos-minerais',
          title: 'RECURSOS MINERAIS',
          description: 'Recursos minerais',
          image: AppImages.recursosMinerais,
          route: '/meio-ambiente/recursos-minerais',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'estruturas-formas-relevo',
          title: 'ESTRUTURAS E FORMAS DE RELEVO',
          description: 'Estruturas e formas de relevo',
          image: AppImages.estruturasFormasRelevo,
          route: '/meio-ambiente/estruturas-formas-relevo',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'tipos-climaticos',
          title: 'TIPOS CLIMÁTICOS',
          description: 'Tipos climáticos',
          image: AppImages.tiposClimaticos,
          route: '/meio-ambiente/tipos-climaticos',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'tempo-clima',
          title: 'TEMPO E CLIMA',
          description: 'Tempo e Clima',
          image: AppImages.tempoClima,
          route: '/meio-ambiente/tempo-clima',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'bacias-hidrograficas',
          title: 'BACIAS HIDROGRÁFICAS',
          description: 'Bacias hidrográficas',
          image: AppImages.baciasHidrograficas,
          route: '/meio-ambiente/bacias-hidrograficas',
          color: AppColors.primaryGreen,
        ),
        SubthemeModel(
          id: 'uso-agua',
          title: 'USO DA ÁGUA',
          description: 'Uso da água',
          image: AppImages.usoAgua,
          route: '/meio-ambiente/uso-agua',
          color: AppColors.primaryGreen,
        ),
      ],
    ),
    ThemeModel(
      id: 'espacos-urbanos',
      title: 'Espaços Urbanos e Rurais',
      description:
          'Entenda a dinâmica das cidades, campo, indústria, mobilidade, e a vida em diferentes territórios.',
      imagePath: 'assets/images/espacos-urbanos.jpg',
      route: AppRouter.espacosUrbanos,
      color: AppColors.primaryBlue,
      icon: Icons.location_city_outlined,
      subthemes: [
        SubthemeModel(
          id: 'espaco-urbano-brasileiro',
          title: 'ESPAÇO URBANO BRASILEIRO',
          description: 'Espaço urbano brasileiro',
          image: AppImages.espacoUrbanoBrasileiro,
          route: '/espacos-urbanos/urbano-brasileiro',
          color: AppColors.primaryBlue,
        ),
        SubthemeModel(
          id: 'globalizacao-mobilidade',
          title: 'GLOBALIZAÇÃO E MOBILIDADE',
          description: 'Globalização e Mobilidade',
          image: AppImages.globalizacaoMobilidade,
          route: '/espacos-urbanos/globalizacao-mobilidade',
          color: AppColors.primaryBlue,
        ),
        SubthemeModel(
          id: 'industria-transformacao',
          title: 'INDÚSTRIA E TRANSFORMAÇÃO',
          description: 'Indústria e transformação',
          image: AppImages.industriasTransformacoes,
          route: '/espacos-urbanos/industria-transformacao',
          color: AppColors.primaryBlue,
        ),
        SubthemeModel(
          id: 'espaco-rural-brasileiro',
          title: 'ESPAÇO RURAL BRASILEIRO',
          description: 'Espaço rural brasileiro',
          image: AppImages.espacoRuralBrasleiro,
          route: '/espacos-urbanos/rural-brasileiro',
          color: AppColors.primaryBlue,
        ),
        SubthemeModel(
          id: 'conflitos-terra',
          title: 'CONFLITOS DE TERRA',
          description: 'Conflitos de terra',
          image: AppImages.conflitosTerra,
          route: '/espacos-urbanos/conflitos-terra',
          color: AppColors.primaryBlue,
        ),
        SubthemeModel(
          id: 'mercado-agropecuario',
          title: 'MERCADO AGROPECUÁRIO',
          description: 'Mercado Agropecuário',
          image: AppImages.mercadoAgropecuario,
          route: '/espacos-urbanos/mercado-agropecuario',
          color: AppColors.primaryBlue,
        ),
      ],
    ),
    ThemeModel(
      id: 'cultura-politica',
      title: 'Cultura e Política',
      description:
          'Mergulhe na diversidade, cultura e política global: povos originários, demografia e geopolítica!',
      imagePath: 'assets/images/cultura-politica.jpg',
      route: AppRouter.culturaPolitica,
      color: AppColors.secondaryRed,
      icon: Icons.people_outlined,
      subthemes: [
        SubthemeModel(
          id: 'geopolitica',
          title: 'GEOPOLÍTICA',
          description: 'Geopolítica',
          image: AppImages.geopolitica,
          route: '/cultura-politica/geopolitica',
          color: AppColors.secondaryRed,
        ),
        SubthemeModel(
          id: 'censo-demografico',
          title: 'CENSO DEMOGRÁFICO',
          description: 'Censo Demográfico',
          image: AppImages.censoDemografico,
          route: '/cultura-politica/censo-demografico',
          color: AppColors.secondaryRed,
        ),
        SubthemeModel(
          id: 'regioes-administrativas',
          title: 'REGIÕES ADMINISTRATIVAS',
          description: 'Regiões administrativas',
          image: AppImages.regioesBrasileiras,
          route: '/cultura-politica/regioes-administrativas',
          color: AppColors.secondaryRed,
        ),
        SubthemeModel(
          id: 'demografia',
          title: 'DEMOGRAFIA',
          description: 'Demografia',
          image: AppImages.demografia,
          route: '/cultura-politica/demografia',
          color: AppColors.secondaryRed,
        ),
        SubthemeModel(
          id: 'identidades-culturais',
          title: 'IDENTIDADES CULTURAIS',
          description: 'Identidades culturais',
          image: AppImages.identidadesCulturais,
          route: '/cultura-politica/identidades-culturais',
          color: AppColors.secondaryRed,
        ),
        SubthemeModel(
          id: 'povos-originarios',
          title: 'POVOS ORIGINÁRIOS',
          description: 'Povos originários',
          image: AppImages.povosOriginarios,
          route: '/cultura-politica/povos-originarios',
          color: AppColors.secondaryRed,
        ),
      ],
    ),
  ];
}

// Cores auxiliares para os modelos
class AppColors {
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryGreen = Color(0xFF16A34A);
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color secondaryRed = Color(0xFFEF4444);
}
