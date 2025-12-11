import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_QUE_07 = ContentModel(
  id: 'NMA_QUE_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Nacional de Pesquisas Espaciais - INPE',
    collaborator: 'Terra Brasilis – Sala de Situação',
  ),
  contentInfo: ContentInfo(
    title: 'Análise - Focos de Queimadas',
    description:
        'WebSIG desenvolvido pelo INPE para acesso, consulta, análise e disseminação de dados geográficos gerados pelos projetos de monitoramento da vegetação nativa',
    subjects: ['Queimadas', 'Monitoramento', 'WebSIG'],
    contentNote:
        'Estes dados visam subsidiar os entes públicos na formulação das políticas públicas do Estado Brasileiro',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://terrabrasilis.dpi.inpe.br/ams/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
