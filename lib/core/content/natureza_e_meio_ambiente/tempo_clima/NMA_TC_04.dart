import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_TC_04 = ContentModel(
  id: 'NMA_TC_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de Brasília',
    collaborator: 'Museu virtual',
  ),
  contentInfo: ContentInfo(
    title: 'Antártica',
    description: 'Exposição virtual que narra a Antártica como o continente das incógnitas',
    subjects: ['Antártica', 'Polo Sul', 'Exposição'],
    contentNote:
        'Temas apresentados: Antártica, sua geografia, sua fauna e sua flora, aspectos geopolíticos e conservação ambiental',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'http://antartica.museuvirtual.unb.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
