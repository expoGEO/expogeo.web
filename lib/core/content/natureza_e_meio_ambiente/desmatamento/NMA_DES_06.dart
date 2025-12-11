import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_DES_06 = ContentModel(
  id: 'NMA_DES_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Kanindé - Associação de defesa etnoambiental',
  ),
  contentInfo: ContentInfo(
    title: 'Almir Suruí - O herói da floresta',
    description:
        'Exposição que apresenta a história de vida de Chefe Almir Suruí, uma referência na luta ambiental e defesa da floresta',
    subjects: ['Almir Suruí', 'Luta ambiental', 'Exposição'],
    contentNote:
        'Chefe Almir Suruí é um índio visionário. Cresceu no meio da Amazônia brasileira, na aldeia Lapetanha em Rondônia, mas sua luta ultrapassa os limites da Terra Indígena Sete de Setembro, onde vive até hoje',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/5gURnmpUbtdrJw',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
