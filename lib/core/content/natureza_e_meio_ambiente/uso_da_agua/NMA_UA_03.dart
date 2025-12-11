import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_UA_03 = ContentModel(
  id: 'NMA_UA_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Jornalismo TV Cultura',
    collaborator: 'Jornalismo TV Cultura',
  ),
  contentInfo: ContentInfo(
    title: 'Belo Monte: Usina de Problemas',
    description:
        'O vídeo traz à luz os conflitos causados pela obra da quarta maior hidrelétrica do mundo. Ao longo do documentário, a TV Cultura conversa com lideranças indígenas, ambientalistas, pesquisadores e com a população impactada para colocar em pauta as problemáticas que a usina traz',
    subjects: ['Usina hidrelétrica', 'Impactos ambientais', 'Documentário'],
    contentNote:
        'Entre os danos associados à Belo Monte estão ribeirinhos desalojados, populações indígenas sem sustento de suas tradições e a região amazônica com a perda de espécies endêmicas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/VWE3tkef3Ts',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
