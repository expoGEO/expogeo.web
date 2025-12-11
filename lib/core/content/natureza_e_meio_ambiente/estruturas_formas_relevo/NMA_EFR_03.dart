import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_EFR_03 = ContentModel(
  id: 'NMA_EFR_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Patrimônio Mundial - UNESCO e Cabildo de Gran Canaria',
  ),
  contentInfo: ContentInfo(
    title: 'Risco Caído e a Paisagem Cultural das Montanhas Sagradas de Gran Canaria - Espanha',
    description:
        'Exposição virtual que aborda as paisagens das Montanhas Sagradas de Gran Canaria - Espanha',
    subjects: ['Relevo', 'Gran Canaria', 'Exposição'],
    contentNote:
        'Os espaços sagrados de montanha são algumas das expressões mais eloquentes das paisagens, construídas, desenhadas e vividas pelo povo Canário-Amazigh, lar de formas particularmente sofisticadas de dominação simbólica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/CgWhGd4WpEP66Q',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
