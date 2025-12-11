import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_TC_02 = ContentModel(
  id: 'NMA_TC_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Google Arts and Culture',
  ),
  contentInfo: ContentInfo(
    title: '7 locais extremos ao redor do mundo',
    description:
        'Exposição virtual que aborda os efeitos do clima nos lugares mais extremos para a vida humana ao redor do mundo',
    subjects: ['Clima', 'Lugares extremos', 'Exposição'],
    contentNote: 'Os lugares mais loucos e remotos do mundo que você pode explorar em casa',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/8QVRZJWJ_NQYSQ',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
