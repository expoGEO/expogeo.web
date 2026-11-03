import 'package:expogeo/core/utils/enums/app_images.dart';

/// Instituições de realização e apoio, na ordem em que aparecem.
enum Partner {
  ufu(
    acronym: 'UFU',
    fullName: 'Universidade Federal de Uberlândia',
    url: 'https://ufu.br',
    image: AppImages.ufu,
  ),
  faced(
    acronym: 'FACED',
    fullName: 'Faculdade de Educação da UFU',
    url: 'https://faced.ufu.br',
    image: AppImages.faced,
  ),
  ppged(
    acronym: 'PPGED',
    fullName: 'Programa de Pós-Graduação em Educação da UFU',
    url: 'https://ppged.faced.ufu.br',
    image: AppImages.ppged,
  ),
  fapemig(
    acronym: 'FAPEMIG',
    fullName: 'Fundação de Amparo à Pesquisa do Estado de Minas Gerais',
    url: 'https://fapemig.br',
    image: AppImages.fapemig,
  ),
  capes(
    acronym: 'CAPES',
    fullName: 'Coordenação de Aperfeiçoamento de Pessoal de Nível Superior',
    url: 'https://www.gov.br/capes',
    image: AppImages.capes,
  ),
  cnpq(
    acronym: 'CNPq',
    fullName: 'Conselho Nacional de Desenvolvimento Científico e Tecnológico',
    url: 'https://www.gov.br/cnpq',
    image: AppImages.cnpq,
  );

  const Partner({
    required this.acronym,
    required this.fullName,
    required this.url,
    required this.image,
  });

  final String acronym;
  final String fullName;
  final String url;
  final AppImages image;
}
