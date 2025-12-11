import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_POP_03 = ContentModel(
  id: 'CP_POP_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Google Arts and Culture',
  ),
  contentInfo: ContentInfo(
    title: 'Uma jornada pela América',
    description:
        'Exposição virtual que apresenta a cultura, arte e tradições pelo continente americano',
    subjects: ['Cultura', 'América', 'Exposição'],
    contentNote:
        'Apresenta as diversas formas de gastronomia, história, costumes, paisagens urbanas, natureza, entre outros temas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/journey-americas',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
