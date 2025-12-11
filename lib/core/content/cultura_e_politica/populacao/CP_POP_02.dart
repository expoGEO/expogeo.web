import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_POP_02 = ContentModel(
  id: 'CP_POP_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Design Indaba',
  ),
  contentInfo: ContentInfo(
    title: 'As cores da África',
    description: 'Exposição virtual que apresenta a África sob diversos espectros culturais',
    subjects: ['Arte', 'África', 'Exposição'],
    contentNote:
        'Apresenta obras de arte relacionadas a um caledoscópio de cores: vermelho; laranja e ocre; amarelo, ouro e cobre; preto e cinza; verde; azul; roxo e branco',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/colours-of-africa',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
