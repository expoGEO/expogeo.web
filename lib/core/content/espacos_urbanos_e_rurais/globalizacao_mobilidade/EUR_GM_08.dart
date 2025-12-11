import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_08 = ContentModel(
  id: 'EUR_GM_08',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu Marítimo EXEA',
    collaborator: 'George Henrique',
  ),
  contentInfo: ContentInfo(
    title: 'A navegação mercante em tempos de guerra',
    description:
        'A Exposição aborda o caso dos Vapores alemães em Cabedelo / PB / Brasil durante a 1ª Guerra Mundial (1914-1918)',
    subjects: ['Transporte marítimo', 'Mobilidade', 'Navegação mercante'],
    contentNote:
        'A Exposição aborda o caso dos Vapores alemães em Cabedelo / PB / Brasil durante a 1ª Guerra Mundial (1914-1918)',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/8wURGS09WWWcBg',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
