import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_POP_04 = ContentModel(
  id: 'CP_POP_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Google Arts and Culture',
  ),
  contentInfo: ContentInfo(
    title: 'Meshiagare! Sabores do Japão',
    description:
        'Exposição virtual que apresenta a gastronomia, cultura, arte e tradições do Japão',
    subjects: ['Gastronomia', 'Japão', 'Cultura'],
    contentNote: 'Representa a importância da gastronomia na cultura japonesa',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/japanese-food',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
