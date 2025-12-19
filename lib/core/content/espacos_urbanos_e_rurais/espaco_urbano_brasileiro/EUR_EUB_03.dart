import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_EUB_03 = ContentModel(
  id: 'EUR_EUB_03',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoUrbanoBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto dos Arquitetos do Brasil',
    collaborator: 'Departamento Distrito Federal',
  ),
  contentInfo: ContentInfo(
    title: 'Geometria',
    description:
        'A exposição apresenta ângulos pouco convencionais do Plano Piloto (Brasília/DF), revelando formas puras do desenho de seus edifícios, ruas e jardins',
    subjects: ['Imagem de satélite', 'Espaço urbano', 'Brasília'],
    contentNote:
        'Apresentação de imagens de satélite em áreas da cidade de Brasília e promove uma reflexão sobre a arquitetura da cidade e suas formas geométricas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/KwWxaQ3ch5ymTW',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
