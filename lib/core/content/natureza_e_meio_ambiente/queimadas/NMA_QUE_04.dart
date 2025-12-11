import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_QUE_04 = ContentModel(
  id: 'NMA_QUE_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Nacional de Pesquisas Espaciais - INPE',
    collaborator: 'Instituto Nacional de Pesquisas Espaciais - INPE',
  ),
  contentInfo: ContentInfo(
    title: 'Monitoramento dos Focos Ativos por Países',
    description:
        'Site que fornece dados, tabelas e gráficos sobre a série histórica de queimadas por países da região amazônica',
    subjects: ['Queimadas', 'Monitoramento', 'Estatísticas'],
    contentNote:
        'Site que fornece dados, tabelas e gráficos sobre a série histórica de queimadas por países da região amazônica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://terrabrasilis.dpi.inpe.br/queimadas/situacao-atual/estatisticas/estatisticas_paises/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
