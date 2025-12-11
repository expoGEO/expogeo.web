import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_07 = ContentModel(
  id: 'NMA_SUS_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
    collaborator: 'IBGE Explica',
  ),
  contentInfo: ContentInfo(
    title: 'Objetos do Desenvolvimento Sustentável',
    description:
        'Playlist de vídeos que apresenta o conceito relacionada a cada um dos 17 Objetivos do Desenvolvimento Sustentável estipulados pela ONU',
    subjects: ['Sustentabilidade', 'Objetivos do Desenvolvimento Sustentável', 'Vídeo'],
    contentNote:
        'As mudanças climáticas são transformações a longo prazo nos padrões de temperatura e clima. As atividades humanas têm sido o principal impulsionador das mudanças climáticas, principalmente devido à queima de combustíveis fósseis como carvão, petróleo e gás',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtube.com/playlist?list=PLAvMMJyHZEaFnbAHb_0limdkGL5Z_HBli&feature=shared',
    issueYear: 2016,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
