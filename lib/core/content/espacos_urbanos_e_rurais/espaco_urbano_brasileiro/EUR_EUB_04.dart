import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_EUB_04 = ContentModel(
  id: 'EUR_EUB_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Jornalismo TV Cultura',
    collaborator: 'Jornalismo TV Cultura - Canal Youtube',
  ),
  contentInfo: ContentInfo(
    title: 'Cidades em movimento - Pedestres',
    description:
        'Reportagem da série Cidade em Movimento, sobre os desafios enfrentados pelos pedestres que andam pela capital paulista',
    subjects: ['Pedestres', 'Espaço urbano', 'Problemas urbanos'],
    contentNote:
        'Reportagem da série Cidade em Movimento, sobre os desafios enfrentados pelos pedestres que andam pela capital paulista',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/P_Hq1wHSAnY',
    issueYear: 2019,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
