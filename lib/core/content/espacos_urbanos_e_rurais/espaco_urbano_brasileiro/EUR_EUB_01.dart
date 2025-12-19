import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_EUB_01 = ContentModel(
  id: 'EUR_EUB_01',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoUrbanoBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Prefeitura Municipal de São Paulo',
    collaborator: 'Secretaria Municipal de Cultura',
  ),
  contentInfo: ContentInfo(
    title: 'MAR 360 "Museu de Arte de Rua"',
    description:
        'Exposição virtual que apresenta painéis criados por diversos artistas de rua na cidade de São Paulo, se transformando em um museu aberto',
    subjects: ['Grafitti', 'Espaço urbano', 'Educação ambiental'],
    contentNote:
        'Apresentação de grafittis em áreas urbanas que promove a arte de rua na maior cidade da América Latina',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.mar360.art.br/pt/',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
