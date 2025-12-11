import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_EUB_07 = ContentModel(
  id: 'EUR_EUB_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'IBGE - Canal Youtube',
  ),
  contentInfo: ContentInfo(
    title: 'O que é concentração urbana?',
    description:
        'Vídeo que analisa o conceito de concentração urbana sob a ótica da realidade brasileira',
    subjects: ['Concentração urbana', 'Espaço urbano', 'IBGE'],
    contentNote:
        'Vídeo que analisa o conceito de concentração urbana sob a ótica da realidade brasileira',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/G5YsSBc98Po',
    issueYear: 2015,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
