import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_06 = ContentModel(
  id: 'NMA_SUS_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Momento Ambiental',
    collaborator: 'Momento Ambiental',
  ),
  contentInfo: ContentInfo(
    title: 'Desperdício de alimentos',
    description:
        'Vídeo que apresenta como evitar o desperdício é uma forma de preservar a natureza e um desafio possível',
    subjects: ['Sustentabilidade', 'Desperdício', 'Vídeo'],
    contentNote:
        'Estudos mostram que boa parte dos alimentos jogados fora poderia ser reaproveitada e ter o destino correto. Uma mudança de hábitos que passa por consciência e planejamento',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/BgZyNW14ptc',
    issueYear: 2010,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
