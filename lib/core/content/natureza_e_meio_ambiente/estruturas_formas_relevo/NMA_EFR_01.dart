import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_EFR_01 = ContentModel(
  id: 'NMA_EFR_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Patrimônio Mundial – UNESCO e Parques Nacionais da Tanzânia (TANAPA)',
  ),
  contentInfo: ContentInfo(
    title: 'Parque Nacional Kilimanjaro - República Unida da Tanzânia',
    description:
        'Exposição virtual que aborda as paisagens do Monte Kilimanjaro e da República Unida da Tanzânia',
    subjects: ['Relevo', 'Monte Kilimanjaro', 'Exposição'],
    contentNote:
        'O Parque Nacional Kilimanjaro protege a maior massa vulcânica independente do mundo e a montanha mais alta da África, elevando-se 4.877m acima das planícies circundantes até 5.895m no seu pico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/8AXhYqJPo7G5Ig',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
