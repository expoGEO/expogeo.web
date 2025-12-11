import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_UA_02 = ContentModel(
  id: 'NMA_UA_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Museu de Marinha - Portugal',
  ),
  contentInfo: ContentInfo(
    title: 'Portugal, um legado marítimo',
    description:
        'Exposição que apresenta a importância da navegação portuguesa ao longo dos séculos',
    subjects: ['Navegação marítima', 'Portugal', 'Exposição'],
    contentNote:
        'São apresentados diversos temas como: Curiosidades sobre Portugal, Bússola e instrumentos de navegação, Mapas antigos, Estrutura de embarcações históricas, Astronomia, Exploradores, Mundo subaquático, entre outros',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 5),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/sea-culture-in-portugal',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
